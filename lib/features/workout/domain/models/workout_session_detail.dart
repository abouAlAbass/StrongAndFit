import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';

/// Aggregated detail model containing a workout exercise, its exercise metadata, and recorded sets.
class WorkoutExerciseDetail extends Equatable {
  final WorkoutExercise workoutExercise;
  final Exercise exercise;
  final List<SetLog> sets;

  const WorkoutExerciseDetail({
    required this.workoutExercise,
    required this.exercise,
    required this.sets,
  });

  WorkoutExerciseDetail copyWith({
    WorkoutExercise? workoutExercise,
    Exercise? exercise,
    List<SetLog>? sets,
  }) {
    return WorkoutExerciseDetail(
      workoutExercise: workoutExercise ?? this.workoutExercise,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
    );
  }

  @override
  List<Object?> get props => [workoutExercise, exercise, sets];
}

/// Fully-hydrated domain model representing an entire workout session and its exercise tree.
class WorkoutSessionDetail extends Equatable {
  final WorkoutSession session;
  final List<WorkoutExerciseDetail> exercises;

  const WorkoutSessionDetail({
    required this.session,
    required this.exercises,
  });

  /// Total number of completed sets across all exercises in this session.
  int get completedSetsCount => exercises.fold(
        0,
        (acc, item) =>
            acc + item.sets.where((s) => s.isCompleted).length,
      );

  /// Total volume lifted in kilograms (weight * reps for completed sets).
  double get totalVolumeKg => exercises.fold(
        0.0,
        (acc, item) =>
            acc +
            item.sets.where((s) => s.isCompleted).fold(
                  0.0,
                  (setAcc, s) =>
                      setAcc + ((s.weightKg ?? 0.0) * (s.reps ?? 0)),
                ),
      );

  WorkoutSessionDetail copyWith({
    WorkoutSession? session,
    List<WorkoutExerciseDetail>? exercises,
  }) {
    return WorkoutSessionDetail(
      session: session ?? this.session,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [session, exercises];
}
