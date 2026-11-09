import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/workout_dao.dart';
import '../../../../core/enums/set_type.dart';
import '../../domain/models/exercise_personal_records.dart';
import '../../domain/models/workout_session_detail.dart';
import '../../domain/repositories/workout_repository.dart';

/// Concrete implementation of [WorkoutRepository] delegating to [WorkoutDao].
class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDao _workoutDao;

  WorkoutRepositoryImpl(this._workoutDao);

  @override
  Stream<WorkoutSessionDetail?> watchSessionWithSets(int sessionId) {
    return _workoutDao.watchSessionWithSets(sessionId);
  }

  @override
  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 50}) {
    return _workoutDao.watchRecentSessions(limit: limit);
  }

  @override
  Future<WorkoutSession?> getActiveUnfinishedSession() {
    return _workoutDao.getActiveUnfinishedSession();
  }

  @override
  Future<List<SetLog>> fetchLastLoggedSetsForExercise(
    int exerciseId, {
    int? excludeSessionId,
  }) {
    return _workoutDao.fetchLastLoggedSetsForExercise(
      exerciseId,
      excludeSessionId: excludeSessionId,
    );
  }

  @override
  Future<Map<int, ExercisePersonalRecords>> fetchHistoricalPersonalRecords({
    int? excludeSessionId,
  }) {
    return _workoutDao.fetchHistoricalPersonalRecords(
      excludeSessionId: excludeSessionId,
    );
  }

  @override
  Future<int> startNewSession({String? title}) {
    final now = DateTime.now();
    return _workoutDao.createSession(
      WorkoutSessionsCompanion.insert(
        title: title ?? 'Workout - ${now.month}/${now.day}',
        startedAt: now,
      ),
    );
  }

  @override
  Future<int> addExerciseToSession({
    required int sessionId,
    required int exerciseId,
  }) {
    return _workoutDao.addExerciseToSession(
      sessionId: sessionId,
      exerciseId: exerciseId,
    );
  }

  @override
  Future<int> addSet({
    required int workoutExerciseId,
    required int setNumber,
    SetType setType = SetType.normal,
    double? weightKg,
    int? reps,
    double? rpe,
  }) {
    return _workoutDao.addSetToExercise(
      workoutExerciseId: workoutExerciseId,
      setNumber: setNumber,
      setType: setType,
      weightKg: weightKg,
      reps: reps,
      rpe: rpe,
    );
  }

  @override
  Future<bool> updateSet(SetLogsCompanion updated) {
    return _workoutDao.updateSetLog(updated);
  }

  @override
  Future<int> toggleSetCompletion({
    required int setId,
    required bool isCompleted,
  }) {
    return _workoutDao.toggleSetCompletion(setId, isCompleted);
  }

  @override
  Future<int> deleteSet(int setId) {
    return _workoutDao.deleteSet(setId);
  }

  @override
  Future<int> deleteWorkoutExercise(int workoutExerciseId) {
    return _workoutDao.deleteWorkoutExercise(workoutExerciseId);
  }

  @override
  Future<int> setExerciseSuperset({
    required int workoutExerciseId,
    required int? supersetGroupId,
  }) {
    return _workoutDao.setExerciseSuperset(workoutExerciseId, supersetGroupId);
  }

  @override
  Future<int> completeSession({
    required int sessionId,
    required int durationSeconds,
  }) {
    return _workoutDao.completeSession(
      sessionId: sessionId,
      durationSeconds: durationSeconds,
    );
  }

  @override
  Future<int> discardSession(int sessionId) {
    return _workoutDao.deleteSession(sessionId);
  }

  @override
  Future<List<ExerciseProgressionPoint>> fetchExerciseProgressionBySlug(
    String slug,
  ) {
    return _workoutDao.fetchExerciseProgressionBySlug(slug);
  }
}
