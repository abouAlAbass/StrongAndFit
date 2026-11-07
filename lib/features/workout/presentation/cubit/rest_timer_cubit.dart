import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/notifications/rest_notification_service.dart';
import '../../domain/models/rest_preferences.dart';
import '../../domain/repositories/rest_settings_repository.dart';
import 'rest_timer_state.dart';

/// Cubit managing the rest chronometer between sets and between exercises.
///
/// Design notes:
/// - The countdown is derived from an absolute deadline ([RestTimerState.endsAt])
///   and an injectable clock, never from counting ticks. Backgrounding the app,
///   locking the screen or dropped frames cannot make it drift.
/// - An OS notification is scheduled at the deadline so the athlete is alerted
///   even when the app is not visible.
/// - Preferences are persisted offline through [RestSettingsRepository].
class RestTimerCubit extends Cubit<RestTimerState> {
  final RestSettingsRepository _settings;
  final RestNotificationService _notifications;
  final DateTime Function() _now;
  Timer? _ticker;

  String _notificationTitle = 'Rest is over';
  String _notificationBody = 'Time for your next set 💪';

  static const int minDuration = 5;
  static const int maxDuration = 3600;

  RestTimerCubit({
    RestSettingsRepository? settings,
    RestNotificationService notifications = const NoopRestNotificationService(),
    DateTime Function()? clock,
  })  : _settings = settings ?? InMemoryRestSettingsRepository(),
        _notifications = notifications,
        _now = clock ?? DateTime.now,
        super(const RestTimerState()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await _settings.load();
      if (!isClosed) emit(state.copyWith(preferences: prefs));
    } catch (_) {
      // Keep defaults; the timer must remain usable.
    }
  }

  /// Localized copy used for the OS notification (set from the UI layer).
  void updateNotificationText({required String title, required String body}) {
    _notificationTitle = title;
    _notificationBody = body;
  }

  // ---------------------------------------------------------------------------
  // Timer lifecycle
  // ---------------------------------------------------------------------------

  /// Starts or restarts the rest countdown.
  void startTimer({
    int? seconds,
    RestKind kind = RestKind.manual,
    String? nextExerciseName,
  }) {
    final duration =
        (seconds ?? state.preferences.betweenSetsSeconds).clamp(minDuration, maxDuration);
    final endsAt = _now().add(Duration(seconds: duration));

    _haptic(HapticFeedback.mediumImpact);
    emit(
      state.copyWith(
        status: RestTimerStatus.running,
        totalDuration: duration,
        remainingSeconds: duration,
        endsAt: endsAt,
        kind: kind,
        nextExerciseName: nextExerciseName,
        clearNextExercise: nextExerciseName == null,
      ),
    );
    _scheduleNotification(endsAt);
    _startTicker();
  }

  /// Called when the athlete ticks off a set.
  ///
  /// - Not the last set → rest between sets (per-exercise override if any).
  /// - Last set and another exercise follows → longer transition rest.
  /// - Last set of the whole workout → no rest; the session is done.
  void onSetCompleted({
    int? exerciseRestSeconds,
    bool isLastSetOfExercise = false,
    String? nextExerciseName,
  }) {
    if (!state.preferences.autoStart) return;

    if (isLastSetOfExercise) {
      if (nextExerciseName == null) {
        stop();
        return;
      }
      startTimer(
        seconds: state.preferences.betweenExercisesSeconds,
        kind: RestKind.betweenExercises,
        nextExerciseName: nextExerciseName,
      );
      return;
    }

    startTimer(
      seconds: exerciseRestSeconds ?? state.preferences.betweenSetsSeconds,
      kind: RestKind.betweenSets,
    );
  }

  void pause() {
    if (!state.isRunning) return;
    sync();
    if (!state.isRunning) return; // finished during sync
    _ticker?.cancel();
    _notifications.cancelRestEnd();
    emit(state.copyWith(status: RestTimerStatus.paused, clearEndsAt: true));
  }

  void resume() {
    if (!state.isPaused || state.remainingSeconds <= 0) return;
    final endsAt = _now().add(Duration(seconds: state.remainingSeconds));
    emit(state.copyWith(status: RestTimerStatus.running, endsAt: endsAt));
    _scheduleNotification(endsAt);
    _startTicker();
  }

  void stop() {
    _ticker?.cancel();
    _notifications.cancelRestEnd();
    emit(
      state.copyWith(
        status: RestTimerStatus.idle,
        remainingSeconds: 0,
        clearEndsAt: true,
        clearNextExercise: true,
      ),
    );
  }

  /// Adjusts the remaining rest by [deltaSeconds] (e.g. +15 / -15).
  void adjustTime(int deltaSeconds) {
    if (!state.isRunning && !state.isPaused) return;
    _haptic(HapticFeedback.selectionClick);

    final newRemaining = state.remainingSeconds + deltaSeconds;
    if (newRemaining <= 0) {
      _finish();
      return;
    }
    final clamped = newRemaining.clamp(1, maxDuration);
    final newTotal = (state.totalDuration + deltaSeconds).clamp(clamped, maxDuration);

    if (state.isRunning) {
      final endsAt = _now().add(Duration(seconds: clamped));
      emit(state.copyWith(
        remainingSeconds: clamped,
        totalDuration: newTotal,
        endsAt: endsAt,
      ));
      _scheduleNotification(endsAt);
    } else {
      emit(state.copyWith(remainingSeconds: clamped, totalDuration: newTotal));
    }
  }

  /// Recomputes remaining time from the wall clock. Safe to call anytime
  /// (e.g. when the app returns to the foreground).
  void sync() {
    final endsAt = state.endsAt;
    if (!state.isRunning || endsAt == null) return;
    final remainingMs = endsAt.difference(_now()).inMilliseconds;
    if (remainingMs <= 0) {
      _finish();
      return;
    }
    final remaining = (remainingMs / 1000).ceil();
    if (remaining != state.remainingSeconds) {
      emit(state.copyWith(remainingSeconds: remaining));
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    // Sub-second polling keeps the display aligned with the real deadline.
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => sync());
  }

  void _finish() {
    _ticker?.cancel();
    _haptic(HapticFeedback.vibrate);
    emit(
      state.copyWith(
        status: RestTimerStatus.finished,
        remainingSeconds: 0,
        clearEndsAt: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Preferences (persisted)
  // ---------------------------------------------------------------------------

  Future<void> _savePrefs(RestPreferences prefs) async {
    emit(state.copyWith(preferences: prefs));
    try {
      await _settings.save(prefs);
    } catch (_) {
      // Preference persistence failures are non-fatal.
    }
  }

  void setBetweenSetsDuration(int seconds) => _savePrefs(
        state.preferences.copyWith(
          betweenSetsSeconds: seconds.clamp(minDuration, maxDuration),
        ),
      );

  void setBetweenExercisesDuration(int seconds) => _savePrefs(
        state.preferences.copyWith(
          betweenExercisesSeconds: seconds.clamp(minDuration, maxDuration),
        ),
      );

  /// Kept for backwards compatibility with existing callers.
  void setDefaultDuration(int seconds) => setBetweenSetsDuration(seconds);

  void toggleAutoStart(bool enabled) =>
      _savePrefs(state.preferences.copyWith(autoStart: enabled));

  void toggleNotifications(bool enabled) {
    _savePrefs(state.preferences.copyWith(notificationsEnabled: enabled));
    if (!enabled) {
      _notifications.cancelRestEnd();
    } else if (state.isRunning && state.endsAt != null) {
      _scheduleNotification(state.endsAt!);
    }
  }

  void toggleVibration(bool enabled) =>
      _savePrefs(state.preferences.copyWith(vibrationEnabled: enabled));

  /// Persists a per-exercise rest override (`null` = use global default).
  Future<void> setExerciseRest(int exerciseId, int? seconds) async {
    try {
      await _settings.setExerciseRest(
        exerciseId,
        seconds?.clamp(minDuration, maxDuration),
      );
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _scheduleNotification(DateTime endsAt) {
    if (!state.preferences.notificationsEnabled) return;
    _notifications.scheduleRestEnd(
      endsAt: endsAt,
      title: _notificationTitle,
      body: _notificationBody,
    );
  }

  void _haptic(Future<void> Function() feedback) {
    if (!state.preferences.vibrationEnabled) return;
    feedback();
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
