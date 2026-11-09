import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/exercises_table.dart';
import '../tables/rest_settings_table.dart';

part 'settings_dao.g.dart';

/// Data Access Object for persisted rest chronometer preferences.
@DriftAccessor(tables: [RestSettings, Exercises])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<RestSettingsData> getOrCreateRestSettings() async {
    final existing = await (select(restSettings)..limit(1)).getSingleOrNull();
    if (existing != null) return existing;
    final id = await into(restSettings).insert(const RestSettingsCompanion());
    return (select(restSettings)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> updateRestSettings(RestSettingsCompanion companion) async {
    final current = await getOrCreateRestSettings();
    await (update(
      restSettings,
    )..where((t) => t.id.equals(current.id))).write(companion);
  }

  /// Sets (or clears with `null`) the per-exercise rest override.
  Future<void> setExerciseRest(int exerciseId, int? seconds) {
    return (update(exercises)..where((t) => t.id.equals(exerciseId))).write(
      ExercisesCompanion(restSeconds: Value(seconds)),
    );
  }

  /// Persists the preferred locale language code ('ar', 'en', 'fr').
  Future<void> setPreferredLocale(String languageCode) async {
    await updateRestSettings(
      RestSettingsCompanion(preferredLocale: Value(languageCode)),
    );
  }

  /// Persists the preferred visual theme mode ('system', 'light', 'dark').
  Future<void> setThemeMode(String themeModeName) async {
    await updateRestSettings(
      RestSettingsCompanion(themeMode: Value(themeModeName)),
    );
  }
}
