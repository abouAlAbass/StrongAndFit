import 'package:drift/drift.dart';
import '../../../features/workout/domain/models/exercise_personal_records.dart';
import '../../../features/workout/domain/models/workout_session_detail.dart';
import '../../../features/workout/domain/services/one_rep_max_calculator.dart';
import '../../enums/set_type.dart';
import '../app_database.dart';
import '../tables/exercises_table.dart';
import '../tables/set_logs_table.dart';
import '../tables/workout_exercises_table.dart';
import '../tables/workout_sessions_table.dart';

part 'workout_dao.g.dart';

/// Represents a chronological 1RM progression data point for a given exercise.
class ExerciseProgressionPoint {
  final DateTime date;
  final double maxWeightKg;
  final double estimatedOneRepMax;

  const ExerciseProgressionPoint({
    required this.date,
    required this.maxWeightKg,
    required this.estimatedOneRepMax,
  });
}

/// Data Access Object managing workout sessions, exercise groupings, and set logs.
@DriftAccessor(tables: [
  WorkoutSessions,
  WorkoutExercises,
  Exercises,
  SetLogs,
])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  /// Reactive stream yielding real-time updates of a session and all its nested
  /// exercises and completed/pending sets.
  Stream<WorkoutSessionDetail?> watchSessionWithSets(int sessionId) {
    final query = select(workoutSessions).join([
      leftOuterJoin(
        workoutExercises,
        workoutExercises.sessionId.equalsExp(workoutSessions.id),
      ),
      leftOuterJoin(
        exercises,
        exercises.id.equalsExp(workoutExercises.exerciseId),
      ),
      leftOuterJoin(
        setLogs,
        setLogs.workoutExerciseId.equalsExp(workoutExercises.id),
      ),
    ])
      ..where(workoutSessions.id.equals(sessionId))
      ..orderBy([
        OrderingTerm.asc(workoutExercises.orderIndex),
        OrderingTerm.asc(workoutExercises.id),
        OrderingTerm.asc(setLogs.setNumber),
      ]);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;

      final session = rows.first.readTable(workoutSessions);
      final exerciseMap = <int, WorkoutExerciseDetail>{};

      for (final row in rows) {
        final workoutExercise = row.readTableOrNull(workoutExercises);
        final exercise = row.readTableOrNull(exercises);

        if (workoutExercise == null || exercise == null) {
          continue;
        }

        final detail = exerciseMap.putIfAbsent(
          workoutExercise.id,
          () => WorkoutExerciseDetail(
            workoutExercise: workoutExercise,
            exercise: exercise,
            sets: [],
          ),
        );

        final setLog = row.readTableOrNull(setLogs);
        if (setLog != null) {
          if (!detail.sets.any((s) => s.id == setLog.id)) {
            detail.sets.add(setLog);
          }
        }
      }

      return WorkoutSessionDetail(
        session: session,
        exercises: exerciseMap.values.toList(),
      );
    });
  }

  /// Queries the most recent prior session where this exercise was performed,
  /// returning all its recorded sets to pre-fill weight and reps for the next session.
  Future<List<SetLog>> fetchLastLoggedSetsForExercise(
    int exerciseId, {
    int? excludeSessionId,
  }) async {
    final query = select(workoutExercises).join([
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(workoutExercises.sessionId),
      ),
    ])
      ..where(workoutExercises.exerciseId.equals(exerciseId));

    if (excludeSessionId != null) {
      query.where(workoutSessions.id.isNotValue(excludeSessionId));
    }

    query
      ..orderBy([
        OrderingTerm.desc(workoutSessions.startedAt),
        OrderingTerm.desc(workoutExercises.id),
      ])
      ..limit(1);

    final row = await query.getSingleOrNull();
    if (row == null) return [];

    final workoutExercise = row.readTable(workoutExercises);

    return (select(setLogs)
          ..where((t) => t.workoutExerciseId.equals(workoutExercise.id))
          ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
        .get();
  }

  /// Queries all-time personal records across completed sessions for each exercise.
  Future<Map<int, ExercisePersonalRecords>> fetchHistoricalPersonalRecords({
    int? excludeSessionId,
  }) async {
    final query = select(workoutExercises).join([
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(workoutExercises.sessionId),
      ),
      innerJoin(
        setLogs,
        setLogs.workoutExerciseId.equalsExp(workoutExercises.id),
      ),
    ])
      ..where(setLogs.isCompleted.equals(true));

    if (excludeSessionId != null) {
      query.where(workoutSessions.id.isNotValue(excludeSessionId));
    }

    final rows = await query.get();
    final tempMap = <int, List<SetLog>>{};

    for (final row in rows) {
      final we = row.readTable(workoutExercises);
      final set = row.readTable(setLogs);
      tempMap.putIfAbsent(we.exerciseId, () => []).add(set);
    }

    final recordsMap = <int, ExercisePersonalRecords>{};

    for (final entry in tempMap.entries) {
      double maxWeight = 0.0;
      double max1RM = 0.0;
      double maxVolume = 0.0;

      for (final s in entry.value) {
        final w = s.weightKg ?? 0.0;
        final r = s.reps ?? 0;
        if (w > maxWeight) maxWeight = w;
        final oneRm = OneRepMaxCalculator.epley(weight: w, reps: r);
        if (oneRm > max1RM) max1RM = oneRm;
        final vol = w * r;
        if (vol > maxVolume) maxVolume = vol;
      }

      recordsMap[entry.key] = ExercisePersonalRecords(
        maxWeight: maxWeight,
        maxOneRepMax: max1RM,
        maxVolume: maxVolume,
      );
    }

    return recordsMap;
  }

  /// Watch recent workout sessions ordered by latest started timestamp.
  Stream<List<WorkoutSession>> watchRecentSessions({int limit = 50}) {
    return (select(workoutSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(limit))
        .watch();
  }

  /// Fetch a workout session by id.
  Future<WorkoutSession?> getSessionById(int id) {
    return (select(workoutSessions)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Finds the most recent unfinished workout session (where completedAt is null).
  Future<WorkoutSession?> getActiveUnfinishedSession() {
    return (select(workoutSessions)
          ..where((t) => t.completedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Initiates a new workout session record.
  Future<int> createSession(WorkoutSessionsCompanion session) {
    return into(workoutSessions).insert(session);
  }

  /// Appends an exercise to an active session.
  Future<int> addExerciseToSession({
    required int sessionId,
    required int exerciseId,
    int? orderIndex,
  }) async {
    final int effectiveOrder = orderIndex ??
        await (select(workoutExercises)
              ..where((t) => t.sessionId.equals(sessionId)))
            .get()
            .then((list) => list.length);

    return into(workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
        sessionId: sessionId,
        exerciseId: exerciseId,
        orderIndex: Value(effectiveOrder),
      ),
    );
  }

  /// Appends a new set log under a workout exercise.
  Future<int> addSetToExercise({
    required int workoutExerciseId,
    required int setNumber,
    SetType setType = SetType.normal,
    double? weightKg,
    int? reps,
    double? rpe,
  }) {
    return into(setLogs).insert(
      SetLogsCompanion.insert(
        workoutExerciseId: workoutExerciseId,
        setNumber: setNumber,
        setType: Value(setType),
        weightKg: Value(weightKg),
        reps: Value(reps),
        rpe: Value(rpe),
        isCompleted: const Value(false),
      ),
    );
  }

  /// Updates weight, reps, or RPE for an existing set.
  Future<bool> updateSetLog(SetLogsCompanion updated) {
    return update(setLogs).replace(updated);
  }

  /// Toggles the completion checkbox status of a specific set.
  Future<int> toggleSetCompletion(int setId, bool isCompleted) {
    return (update(setLogs)..where((t) => t.id.equals(setId))).write(
      SetLogsCompanion(isCompleted: Value(isCompleted)),
    );
  }

  /// Removes an individual set from an exercise.
  Future<int> deleteSet(int setId) {
    return (delete(setLogs)..where((t) => t.id.equals(setId))).go();
  }

  /// Removes an exercise (and its cascading sets) from a session.
  Future<int> deleteWorkoutExercise(int workoutExerciseId) {
    return (delete(workoutExercises)..where((t) => t.id.equals(workoutExerciseId))).go();
  }

  /// Finalizes and completes a session with total elapsed duration.
  Future<int> completeSession({
    required int sessionId,
    required int durationSeconds,
    DateTime? completedAt,
  }) {
    return (update(workoutSessions)..where((t) => t.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        completedAt: Value(completedAt ?? DateTime.now()),
        durationSeconds: Value(durationSeconds),
      ),
    );
  }

  /// Discards or deletes an entire workout session.
  Future<int> deleteSession(int sessionId) {
    return (delete(workoutSessions)..where((t) => t.id.equals(sessionId))).go();
  }

  /// Queries historical 1RM progression points for a specific exercise slug across completed sessions.
  Future<List<ExerciseProgressionPoint>> fetchExerciseProgressionBySlug(String slug) async {
    final query = select(setLogs).join([
      innerJoin(
        workoutExercises,
        workoutExercises.id.equalsExp(setLogs.workoutExerciseId),
      ),
      innerJoin(
        exercises,
        exercises.id.equalsExp(workoutExercises.exerciseId),
      ),
      innerJoin(
        workoutSessions,
        workoutSessions.id.equalsExp(workoutExercises.sessionId),
      ),
    ])
      ..where(exercises.slug.equals(slug))
      ..where(setLogs.isCompleted.equals(true))
      ..where(workoutSessions.completedAt.isNotNull())
      ..orderBy([OrderingTerm.asc(workoutSessions.startedAt)]);

    final rows = await query.get();
    final sessionPoints = <int, ExerciseProgressionPoint>{};

    for (final row in rows) {
      final session = row.readTable(workoutSessions);
      final set = row.readTable(setLogs);
      final w = set.weightKg ?? 0.0;
      final r = set.reps ?? 0;
      if (w <= 0 || r <= 0) continue;

      final oneRm = OneRepMaxCalculator.epley(weight: w, reps: r);
      final existing = sessionPoints[session.id];
      if (existing == null || oneRm > existing.estimatedOneRepMax) {
        sessionPoints[session.id] = ExerciseProgressionPoint(
          date: session.startedAt,
          maxWeightKg: w,
          estimatedOneRepMax: oneRm,
        );
      }
    }

    return sessionPoints.values.toList();
  }
}
