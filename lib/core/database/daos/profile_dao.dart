import 'package:drift/drift.dart';
import '../../enums/experience_level.dart';
import '../../enums/muscle_group.dart';
import '../app_database.dart';
import '../tables/set_logs_table.dart';
import '../tables/user_profiles_table.dart';
import '../tables/workout_exercises_table.dart';
import '../tables/workout_sessions_table.dart';

part 'profile_dao.g.dart';

/// Aggregated lifetime metrics for an athlete.
class AthleteLifetimeStats {
  final int totalWorkouts;
  final double totalVolumeKg;
  final int totalDurationSeconds;

  const AthleteLifetimeStats({
    required this.totalWorkouts,
    required this.totalVolumeKg,
    required this.totalDurationSeconds,
  });
}

/// Data Access Object managing user profile, biometric data, and weekly consistency metrics.
@DriftAccessor(tables: [UserProfiles, WorkoutSessions, WorkoutExercises, SetLogs])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  ProfileDao(super.db);

  /// Streams the primary user profile. Auto-seeds an initial record if none exists.
  Stream<UserProfile> watchProfile() {
    return (select(userProfiles)..limit(1)).watchSingleOrNull().map((profile) {
      if (profile != null) return profile;
      // Emit virtual default profile while initial record is asynchronously seeded
      return UserProfile(
        id: 1,
        name: 'Athlete',
        weightKg: 75.0,
        heightCm: 178.0,
        weeklyWorkoutGoal: 4,
        experienceLevel: ExperienceLevel.intermediate,
        updatedAt: DateTime.now(),
      );
    });
  }

  /// Fetches the profile or inserts default if table is empty.
  Future<UserProfile> getOrCreateProfile() async {
    final existing = await (select(userProfiles)..limit(1)).getSingleOrNull();
    if (existing != null) return existing;

    final id = await into(userProfiles).insert(
      UserProfilesCompanion.insert(
        name: const Value('Athlete'),
        weightKg: const Value(75.0),
        heightCm: const Value(178.0),
        weeklyWorkoutGoal: const Value(4),
        experienceLevel: const Value(ExperienceLevel.intermediate),
      ),
    );
    return (select(userProfiles)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Updates profile attributes (weight, height, weekly goal, experience level).
  Future<int> updateProfile(UserProfilesCompanion companion) async {
    final profile = await getOrCreateProfile();
    return (update(userProfiles)..where((t) => t.id.equals(profile.id))).write(
      companion.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  /// Completely deletes all athlete profile data, workout sessions, logs, and resets to a clean initial state.
  Future<void> deleteProfileAndData() async {
    // Delete in order of foreign key constraints
    await delete(setLogs).go();
    await delete(workoutExercises).go();
    await delete(workoutSessions).go();
    await delete(userProfiles).go();

    // Re-insert pristine default profile record so stream listeners stay stable
    await into(userProfiles).insert(
      UserProfilesCompanion.insert(
        name: const Value('Athlete'),
        weightKg: const Value(75.0),
        heightCm: const Value(178.0),
        weeklyWorkoutGoal: const Value(4),
        experienceLevel: const Value(ExperienceLevel.intermediate),
      ),
    );
  }

  /// Calculates how many workouts have been completed during the current calendar week.
  Future<int> getWeeklyCompletedWorkoutsCount() async {
    final now = DateTime.now();
    // Start of week (Monday at 00:00:00)
    final daysFromMonday = (now.weekday - DateTime.monday) % 7;
    final startOfWeek = DateTime(now.year, now.month, now.day - daysFromMonday);

    final countExpression = workoutSessions.id.count();
    final query = selectOnly(workoutSessions)
      ..addColumns([countExpression])
      ..where(workoutSessions.completedAt.isNotNull())
      ..where(workoutSessions.completedAt.isBiggerOrEqualValue(startOfWeek));

    final result = await query.map((row) => row.read(countExpression)).getSingleOrNull();
    return result ?? 0;
  }

  /// Streams weekly completed workouts count reactively.
  Stream<int> watchWeeklyCompletedWorkoutsCount() {
    final now = DateTime.now();
    final daysFromMonday = (now.weekday - DateTime.monday) % 7;
    final startOfWeek = DateTime(now.year, now.month, now.day - daysFromMonday);

    final countExpression = workoutSessions.id.count();
    final query = selectOnly(workoutSessions)
      ..addColumns([countExpression])
      ..where(workoutSessions.completedAt.isNotNull())
      ..where(workoutSessions.completedAt.isBiggerOrEqualValue(startOfWeek));

    return query.watch().map((rows) {
      if (rows.isEmpty) return 0;
      return rows.first.read(countExpression) ?? 0;
    });
  }

  /// Computes lifetime stats: total completed workouts, total volume lifted (kg), total seconds.
  Future<AthleteLifetimeStats> getLifetimeStats() async {
    final completedSessions = await (select(workoutSessions)
          ..where((t) => t.completedAt.isNotNull()))
        .get();

    final totalDuration = completedSessions.fold(0, (acc, s) => acc + s.durationSeconds);

    // Calculate total completed volume
    final completedSets = await (select(setLogs)..where((t) => t.isCompleted.equals(true))).get();
    final totalVolume = completedSets.fold(
      0.0,
      (acc, s) => acc + ((s.weightKg ?? 0.0) * (s.reps ?? 0)),
    );

    return AthleteLifetimeStats(
      totalWorkouts: completedSessions.length,
      totalVolumeKg: totalVolume,
      totalDurationSeconds: totalDuration,
    );
  }

  /// Computes completed set counts grouped by primary [MuscleGroup].
  Future<Map<MuscleGroup, int>> getMuscleGroupSetDistribution() async {
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
      ..where(setLogs.isCompleted.equals(true))
      ..where(workoutSessions.completedAt.isNotNull());

    final rows = await query.get();
    final counts = <MuscleGroup, int>{
      for (final group in MuscleGroup.values) group: 0,
    };

    for (final row in rows) {
      final ex = row.readTable(exercises);
      counts[ex.muscleGroup] = (counts[ex.muscleGroup] ?? 0) + 1;
    }

    return counts;
  }
}
