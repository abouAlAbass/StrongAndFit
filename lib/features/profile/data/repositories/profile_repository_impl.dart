import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/profile_dao.dart';
import '../../../../core/enums/experience_level.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../domain/repositories/profile_repository.dart';

/// Concrete implementation of [ProfileRepository] backed by Drift SQLite DAO.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDao _profileDao;

  ProfileRepositoryImpl(this._profileDao);

  @override
  Stream<UserProfile> watchProfile() {
    return _profileDao.watchProfile();
  }

  @override
  Stream<int> watchWeeklyCompletedWorkoutsCount() {
    return _profileDao.watchWeeklyCompletedWorkoutsCount();
  }

  @override
  Future<int> updateProfile({
    String? name,
    double? weightKg,
    double? heightCm,
    int? weeklyWorkoutGoal,
    ExperienceLevel? experienceLevel,
  }) {
    return _profileDao.updateProfile(
      UserProfilesCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        weightKg: weightKg != null ? Value(weightKg) : const Value.absent(),
        heightCm: heightCm != null ? Value(heightCm) : const Value.absent(),
        weeklyWorkoutGoal: weeklyWorkoutGoal != null
            ? Value(weeklyWorkoutGoal)
            : const Value.absent(),
        experienceLevel: experienceLevel != null
            ? Value(experienceLevel)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<AthleteLifetimeStats> getLifetimeStats() {
    return _profileDao.getLifetimeStats();
  }

  @override
  Future<Map<MuscleGroup, int>> getMuscleGroupSetDistribution() {
    return _profileDao.getMuscleGroupSetDistribution();
  }

  @override
  Future<void> deleteProfileAndData() {
    return _profileDao.deleteProfileAndData();
  }
}
