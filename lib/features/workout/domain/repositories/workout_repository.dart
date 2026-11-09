import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/workout_dao.dart';
import '../../../../core/enums/set_type.dart';
import '../models/exercise_personal_records.dart';
import '../models/workout_session_detail.dart';

/// Contract defining all workout session operations.
abstract class WorkoutRepository {
  /// Watches the active session along with all nested exercises and sets reactively.
  Stream<WorkoutSessionDetail?> watchSessionWithSets(int sessionId);

  /// Watches recent workout sessions for history overview.
  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 50});

  /// Finds the latest unfinished workout session to resume after an app restart.
  Future<WorkoutSession?> getActiveUnfinishedSession();

  /// Queries the most recent prior session sets logged for a specific exercise.
  Future<List<SetLog>> fetchLastLoggedSetsForExercise(
    int exerciseId, {
    int? excludeSessionId,
  });

  /// Queries all-time personal records across completed sessions.
  Future<Map<int, ExercisePersonalRecords>> fetchHistoricalPersonalRecords({
    int? excludeSessionId,
  });

  /// Starts a new session.
  Future<int> startNewSession({String? title});

  /// Appends an exercise to the session.
  Future<int> addExerciseToSession({
    required int sessionId,
    required int exerciseId,
  });

  /// Appends a new set to a workout exercise.
  Future<int> addSet({
    required int workoutExerciseId,
    required int setNumber,
    SetType setType = SetType.normal,
    double? weightKg,
    int? reps,
    double? rpe,
  });

  /// Updates weight, reps, or RPE on a set.
  Future<bool> updateSet(SetLogsCompanion updated);

  /// Toggles whether a set is completed.
  Future<int> toggleSetCompletion({
    required int setId,
    required bool isCompleted,
  });

  /// Deletes a set.
  Future<int> deleteSet(int setId);

  /// Deletes an exercise from the session.
  Future<int> deleteWorkoutExercise(int workoutExerciseId);

  /// Sets or clears a superset group linkage for a workout exercise.
  Future<int> setExerciseSuperset({
    required int workoutExerciseId,
    required int? supersetGroupId,
  });

  /// Finalizes and completes a session.
  Future<int> completeSession({
    required int sessionId,
    required int durationSeconds,
  });

  /// Discards and deletes a workout session entirely.
  Future<int> discardSession(int sessionId);

  /// Queries chronological 1RM progression points for a given exercise slug.
  Future<List<ExerciseProgressionPoint>> fetchExerciseProgressionBySlug(
    String slug,
  );
}
