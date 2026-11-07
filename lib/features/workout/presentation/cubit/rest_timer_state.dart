import 'package:equatable/equatable.dart';
import '../../domain/models/rest_preferences.dart';

enum RestTimerStatus { idle, running, paused, finished }

/// Why the current rest was started — drives copy and colors in the UI.
enum RestKind { betweenSets, betweenExercises, manual }

class RestTimerState extends Equatable {
  final RestTimerStatus status;
  final int totalDuration;
  final int remainingSeconds;

  /// Absolute wall-clock deadline while running. Remaining time is always
  /// derived from this, so the countdown survives backgrounding and jank.
  final DateTime? endsAt;
  final RestKind kind;

  /// Display name of the upcoming exercise (only for [RestKind.betweenExercises]).
  final String? nextExerciseName;
  final RestPreferences preferences;

  const RestTimerState({
    this.status = RestTimerStatus.idle,
    this.totalDuration = 90,
    this.remainingSeconds = 0,
    this.endsAt,
    this.kind = RestKind.manual,
    this.nextExerciseName,
    this.preferences = const RestPreferences(),
  });

  bool get isRunning => status == RestTimerStatus.running;
  bool get isPaused => status == RestTimerStatus.paused;
  bool get isFinished => status == RestTimerStatus.finished;
  bool get isActive => status != RestTimerStatus.idle;

  int get defaultDuration => preferences.betweenSetsSeconds;
  bool get autoStartEnabled => preferences.autoStart;

  /// Fraction of rest remaining (1.0 → 0.0).
  double get progress {
    if (totalDuration <= 0) return 0.0;
    return (remainingSeconds / totalDuration).clamp(0.0, 1.0);
  }

  String get formattedRemaining => formatSeconds(remainingSeconds);

  static String formatSeconds(int totalSeconds) {
    final s = totalSeconds < 0 ? 0 : totalSeconds;
    final minutes = s ~/ 60;
    final seconds = s % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  RestTimerState copyWith({
    RestTimerStatus? status,
    int? totalDuration,
    int? remainingSeconds,
    DateTime? endsAt,
    bool clearEndsAt = false,
    RestKind? kind,
    String? nextExerciseName,
    bool clearNextExercise = false,
    RestPreferences? preferences,
  }) {
    return RestTimerState(
      status: status ?? this.status,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      endsAt: clearEndsAt ? null : (endsAt ?? this.endsAt),
      kind: kind ?? this.kind,
      nextExerciseName:
          clearNextExercise ? null : (nextExerciseName ?? this.nextExerciseName),
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        status,
        totalDuration,
        remainingSeconds,
        endsAt,
        kind,
        nextExerciseName,
        preferences,
      ];
}
