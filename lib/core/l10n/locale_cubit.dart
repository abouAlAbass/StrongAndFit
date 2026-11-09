import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/workout/domain/repositories/rest_settings_repository.dart';

/// Cubit managing the active application [Locale] ('ar', 'en', 'fr')
/// with non-blocking asynchronous SQLite persistence.
class LocaleCubit extends Cubit<Locale> {
  final RestSettingsRepository? _settingsRepository;

  LocaleCubit({
    RestSettingsRepository? settingsRepository,
    Locale initialLocale = const Locale('en'),
  }) : _settingsRepository = settingsRepository,
       super(initialLocale) {
    _hydrateLocale();
  }

  Future<void> _hydrateLocale() async {
    final repo = _settingsRepository;
    if (repo == null) return;
    try {
      final prefs = await repo.load();
      final code = prefs.preferredLocale.trim();
      if (code.isNotEmpty && !isClosed && state.languageCode != code) {
        emit(Locale(code));
      }
    } catch (_) {
      // Fallback silently to initial locale if database is unavailable in unit tests
    }
  }

  /// Updates the active locale immediately and persists it asynchronously.
  void setLocale(Locale locale) {
    emit(locale);
    _settingsRepository?.savePreferredLocale(locale.languageCode);
  }
}
