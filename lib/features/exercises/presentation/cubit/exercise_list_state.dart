import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/enums/muscle_group.dart';

enum ExerciseListStatus { initial, loading, loaded, error }

class ExerciseListState extends Equatable {
  final ExerciseListStatus status;
  final List<Exercise> exercises;
  final MuscleGroup? selectedMuscleGroup;
  final String searchQuery;
  final String? errorMessage;

  const ExerciseListState({
    this.status = ExerciseListStatus.initial,
    this.exercises = const [],
    this.selectedMuscleGroup,
    this.searchQuery = '',
    this.errorMessage,
  });

  ExerciseListState copyWith({
    ExerciseListStatus? status,
    List<Exercise>? exercises,
    MuscleGroup? selectedMuscleGroup,
    bool clearMuscleGroup = false,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ExerciseListState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      selectedMuscleGroup: clearMuscleGroup
          ? null
          : (selectedMuscleGroup ?? this.selectedMuscleGroup),
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    exercises,
    selectedMuscleGroup,
    searchQuery,
    errorMessage,
  ];
}
