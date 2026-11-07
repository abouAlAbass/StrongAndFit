// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dao.dart';

// ignore_for_file: type=lint
mixin _$SettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RestSettingsTable get restSettings => attachedDatabase.restSettings;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  SettingsDaoManager get managers => SettingsDaoManager(this);
}

class SettingsDaoManager {
  final _$SettingsDaoMixin _db;
  SettingsDaoManager(this._db);
  $$RestSettingsTableTableManager get restSettings =>
      $$RestSettingsTableTableManager(_db.attachedDatabase, _db.restSettings);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
}
