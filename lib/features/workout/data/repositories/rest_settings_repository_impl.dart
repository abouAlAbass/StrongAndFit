import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/settings_dao.dart';
import '../../domain/models/rest_preferences.dart';
import '../../domain/repositories/rest_settings_repository.dart';

/// Drift-backed implementation of [RestSettingsRepository].
class RestSettingsRepositoryImpl implements RestSettingsRepository {
  final SettingsDao _dao;

  RestSettingsRepositoryImpl(this._dao);

  @override
  Future<RestPreferences> load() async {
    final row = await _dao.getOrCreateRestSettings();
    return RestPreferences(
      betweenSetsSeconds: row.betweenSetsSeconds,
      betweenExercisesSeconds: row.betweenExercisesSeconds,
      autoStart: row.autoStart,
      notificationsEnabled: row.notificationsEnabled,
      vibrationEnabled: row.vibrationEnabled,
    );
  }

  @override
  Future<void> save(RestPreferences p) {
    return _dao.updateRestSettings(
      RestSettingsCompanion(
        betweenSetsSeconds: Value(p.betweenSetsSeconds),
        betweenExercisesSeconds: Value(p.betweenExercisesSeconds),
        autoStart: Value(p.autoStart),
        notificationsEnabled: Value(p.notificationsEnabled),
        vibrationEnabled: Value(p.vibrationEnabled),
      ),
    );
  }

  @override
  Future<void> setExerciseRest(int exerciseId, int? seconds) {
    return _dao.setExerciseRest(exerciseId, seconds);
  }
}
