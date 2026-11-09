// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTable get userProfiles => attachedDatabase.userProfiles;
  $WorkoutSessionsTable get workoutSessions => attachedDatabase.workoutSessions;
  $ExercisesTable get exercises => attachedDatabase.exercises;
  $WorkoutExercisesTable get workoutExercises =>
      attachedDatabase.workoutExercises;
  $SetLogsTable get setLogs => attachedDatabase.setLogs;
  $BodyWeightLogsTable get bodyWeightLogs => attachedDatabase.bodyWeightLogs;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db.attachedDatabase, _db.userProfiles);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(
        _db.attachedDatabase,
        _db.workoutSessions,
      );
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db.attachedDatabase, _db.exercises);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(
        _db.attachedDatabase,
        _db.workoutExercises,
      );
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db.attachedDatabase, _db.setLogs);
  $$BodyWeightLogsTableTableManager get bodyWeightLogs =>
      $$BodyWeightLogsTableTableManager(
        _db.attachedDatabase,
        _db.bodyWeightLogs,
      );
}
