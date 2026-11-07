import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/experience_level.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

/// Cubit managing the athlete's biometrics, weekly targets, and consistency tracking.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription? _profileSubscription;
  StreamSubscription? _weeklyCountSubscription;

  ProfileCubit(this._profileRepository) : super(const ProfileState()) {
    init();
  }

  void init() {
    emit(state.copyWith(status: ProfileStatus.loading));

    _profileSubscription?.cancel();
    _profileSubscription = _profileRepository.watchProfile().listen(
      (profile) {
        emit(
          state.copyWith(
            status: ProfileStatus.loaded,
            profile: profile,
          ),
        );
        refreshLifetimeStats();
      },
      onError: (err) {
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: err.toString(),
          ),
        );
      },
    );

    _weeklyCountSubscription?.cancel();
    _weeklyCountSubscription =
        _profileRepository.watchWeeklyCompletedWorkoutsCount().listen(
      (count) {
        emit(state.copyWith(weeklyCompletedCount: count));
        refreshLifetimeStats();
      },
    );
  }

  Future<void> refreshLifetimeStats() async {
    try {
      final stats = await _profileRepository.getLifetimeStats();
      final distribution = await _profileRepository.getMuscleGroupSetDistribution();
      emit(state.copyWith(
        lifetimeStats: stats,
        muscleDistribution: distribution,
      ));
    } catch (_) {}
  }

  Future<void> updateProfileMetrics({
    String? name,
    double? weightKg,
    double? heightCm,
    int? weeklyWorkoutGoal,
    ExperienceLevel? experienceLevel,
  }) async {
    try {
      await _profileRepository.updateProfile(
        name: name,
        weightKg: weightKg,
        heightCm: heightCm,
        weeklyWorkoutGoal: weeklyWorkoutGoal,
        experienceLevel: experienceLevel,
      );
      refreshLifetimeStats();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> deleteProfileAndData() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      await _profileRepository.deleteProfileAndData();
      await refreshLifetimeStats();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    _weeklyCountSubscription?.cancel();
    return super.close();
  }
}
