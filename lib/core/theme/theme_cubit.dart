import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/workout/domain/repositories/rest_settings_repository.dart';

/// Cubit managing theme mode state (dark, light, system)
/// with non-blocking asynchronous SQLite persistence.
class ThemeCubit extends Cubit<ThemeMode> {
  final RestSettingsRepository? _settingsRepository;

  ThemeCubit({
    RestSettingsRepository? settingsRepository,
    ThemeMode initialThemeMode = ThemeMode.dark,
  }) : _settingsRepository = settingsRepository,
       super(initialThemeMode) {
    _hydrateThemeMode();
  }

  Future<void> _hydrateThemeMode() async {
    final repo = _settingsRepository;
    if (repo == null) return;
    try {
      final prefs = await repo.load();
      final mode = parseThemeMode(prefs.themeMode);
      if (!isClosed && state != mode) {
        emit(mode);
      }
    } catch (_) {
      // Fallback silently to initial theme mode if database is unavailable
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    emit(mode);
    _settingsRepository?.saveThemeMode(mode.name);
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(next);
  }

  static ThemeMode parseThemeMode(String raw) {
    switch (raw.toLowerCase()) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }
}
