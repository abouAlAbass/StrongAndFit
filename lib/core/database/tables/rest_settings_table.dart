import 'package:drift/drift.dart';

/// Single-row table persisting the athlete's rest chronometer preferences.
///
/// Two distinct rest intervals are tracked, because physiology differs:
/// - [betweenSetsSeconds]: recovery between two sets of the same exercise.
/// - [betweenExercisesSeconds]: transition after the last set of an exercise
///   (moving equipment, loading plates, setting up the next lift).
@DataClassName('RestSettingsData')
class RestSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get betweenSetsSeconds =>
      integer().withDefault(const Constant(90))();

  IntColumn get betweenExercisesSeconds =>
      integer().withDefault(const Constant(150))();

  BoolColumn get autoStart => boolean().withDefault(const Constant(true))();

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get vibrationEnabled =>
      boolean().withDefault(const Constant(true))();

  /// Persisted application language code ('ar', 'en', 'fr').
  TextColumn get preferredLocale => text().withDefault(const Constant('en'))();

  /// Persisted visual theme mode ('system', 'light', 'dark').
  TextColumn get themeMode => text().withDefault(const Constant('dark'))();
}
