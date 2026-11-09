import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Abstraction over OS-level alerts used by the rest chronometer.
///
/// The countdown itself is computed from a wall-clock deadline, so it stays
/// correct while the app is backgrounded. This service makes sure the athlete
/// is still alerted when the phone is locked or in a pocket.
abstract class RestNotificationService {
  Future<void> init();

  /// Schedules the "rest is over" alert at the absolute instant [endsAt].
  Future<void> scheduleRestEnd({
    required DateTime endsAt,
    required String title,
    required String body,
  });

  Future<void> cancelRestEnd();
}

/// No-op implementation for tests and unsupported platforms (web).
class NoopRestNotificationService implements RestNotificationService {
  const NoopRestNotificationService();

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleRestEnd({
    required DateTime endsAt,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> cancelRestEnd() async {}
}

/// Production implementation backed by `flutter_local_notifications`.
///
/// Every call is defensive: a notification failure must never break the
/// in-app timer, which remains the source of truth.
class LocalRestNotificationService implements RestNotificationService {
  static const int _restNotificationId = 4201;
  static const String _channelId = 'rest_timer';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  bool _exactAllowed = false;

  LocalRestNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    if (kIsWeb || _ready) return;
    try {
      tz_data.initializeTimeZones();

      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: false,
        ),
        macOS: DarwinInitializationSettings(),
        linux: LinuxInitializationSettings(defaultActionName: 'Open'),
        windows: WindowsInitializationSettings(
          appName: 'Strong Track',
          appUserModelId: 'com.strongtrack.app',
          guid: '6f1c2a9e-4b7d-4e15-9a3c-2d8e5f0b7c41',
        ),
      );
      await _plugin.initialize(settings: settings);

      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        await android.requestNotificationsPermission();
        _exactAllowed = await android.canScheduleExactNotifications() ?? false;
      }
      _ready = true;
    } catch (e) {
      debugPrint('RestNotificationService init failed: $e');
    }
  }

  @override
  Future<void> scheduleRestEnd({
    required DateTime endsAt,
    required String title,
    required String body,
  }) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _restNotificationId);
      // An absolute UTC instant avoids needing the device's IANA zone name.
      final when = tz.TZDateTime.from(endsAt.toUtc(), tz.UTC);
      if (!when.isAfter(tz.TZDateTime.now(tz.UTC))) return;

      await _plugin.zonedSchedule(
        id: _restNotificationId,
        scheduledDate: when,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Rest timer',
            channelDescription: 'Alerts when your rest between sets is over',
            importance: Importance.max,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
        ),
        androidScheduleMode: _exactAllowed
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('RestNotificationService schedule failed: $e');
    }
  }

  @override
  Future<void> cancelRestEnd() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _restNotificationId);
    } catch (e) {
      debugPrint('RestNotificationService cancel failed: $e');
    }
  }
}
