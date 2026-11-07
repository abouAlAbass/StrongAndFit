import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/profile_dao.dart';
import '../../../../core/enums/experience_level.dart';
import '../../../../core/enums/muscle_group.dart';

/// Contract defining user profile and consistency metrics operations.
abstract class ProfileRepository {
  /// Reactive stream of the athlete's profile.
  Stream<UserProfile> watchProfile();

  /// Reactive stream of workouts completed in the current week.
  Stream<int> watchWeeklyCompletedWorkoutsCount();

  /// Update profile metrics.
  Future<int> updateProfile({
    String? name,
    double? weightKg,
    double? heightCm,
    int? weeklyWorkoutGoal,
    ExperienceLevel? experienceLevel,
  });

  /// Retrieve lifetime aggregated workout metrics.
  Future<AthleteLifetimeStats> getLifetimeStats();

  /// Retrieve completed sets count per muscle group across completed sessions.
  Future<Map<MuscleGroup, int>> getMuscleGroupSetDistribution();

  /// Completely deletes all profile and workout data, resetting to clean initial state.
  Future<void> deleteProfileAndData();
}
