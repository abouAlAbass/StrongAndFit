import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/profile_dao.dart';
import '../../../../core/enums/muscle_group.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final int weeklyCompletedCount;
  final AthleteLifetimeStats? lifetimeStats;
  final Map<MuscleGroup, int> muscleDistribution;
  final List<BodyWeightLog> weightLogs;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.weeklyCompletedCount = 0,
    this.lifetimeStats,
    this.muscleDistribution = const {},
    this.weightLogs = const [],
    this.errorMessage,
  });

  /// Computed Body Mass Index (BMI) = weight (kg) / [height (m)]^2
  double? get bmi {
    if (profile == null) return null;
    final w = profile!.weightKg;
    final h = profile!.heightCm;
    if (w == null || h == null || h <= 0) return null;
    final heightInMeters = h / 100.0;
    return w / (heightInMeters * heightInMeters);
  }

  /// Weekly consistency progress clamped between 0.0 and 1.0.
  double get weeklyProgress {
    final goal = profile?.weeklyWorkoutGoal ?? 4;
    if (goal <= 0) return 0.0;
    return (weeklyCompletedCount / goal).clamp(0.0, 1.0);
  }

  /// Weight delta between the latest entry and the earliest recorded entry.
  double? get weightDeltaFromStart {
    if (weightLogs.length < 2) return null;
    // weightLogs is sorted newest first
    final latest = weightLogs.first.weightKg;
    final initial = weightLogs.last.weightKg;
    return latest - initial;
  }

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    int? weeklyCompletedCount,
    AthleteLifetimeStats? lifetimeStats,
    Map<MuscleGroup, int>? muscleDistribution,
    List<BodyWeightLog>? weightLogs,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      weeklyCompletedCount: weeklyCompletedCount ?? this.weeklyCompletedCount,
      lifetimeStats: lifetimeStats ?? this.lifetimeStats,
      muscleDistribution: muscleDistribution ?? this.muscleDistribution,
      weightLogs: weightLogs ?? this.weightLogs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profile,
    weeklyCompletedCount,
    lifetimeStats,
    muscleDistribution,
    weightLogs,
    errorMessage,
  ];
}
