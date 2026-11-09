import '../models/rest_preferences.dart';

/// Contract for persisting rest chronometer preferences offline.
abstract class RestSettingsRepository {
  Future<RestPreferences> load();

  Future<void> save(RestPreferences preferences);

  /// Sets a per-exercise rest override; `null` reverts to the global default.
  Future<void> setExerciseRest(int exerciseId, int? seconds);

  /// Persists the preferred application locale ('ar', 'en', 'fr').
  Future<void> savePreferredLocale(String languageCode);

  /// Persists the preferred visual theme mode ('system', 'light', 'dark').
  Future<void> saveThemeMode(String themeModeName);
}

/// In-memory implementation, used by tests and as a safe fallback.
class InMemoryRestSettingsRepository implements RestSettingsRepository {
  RestPreferences _prefs;
  final Map<int, int?> exerciseRest = {};

  InMemoryRestSettingsRepository([this._prefs = const RestPreferences()]);

  @override
  Future<RestPreferences> load() async => _prefs;

  @override
  Future<void> save(RestPreferences preferences) async => _prefs = preferences;

  @override
  Future<void> setExerciseRest(int exerciseId, int? seconds) async =>
      exerciseRest[exerciseId] = seconds;

  @override
  Future<void> savePreferredLocale(String languageCode) async {
    _prefs = _prefs.copyWith(preferredLocale: languageCode);
  }

  @override
  Future<void> saveThemeMode(String themeModeName) async {
    _prefs = _prefs.copyWith(themeMode: themeModeName);
  }
}
