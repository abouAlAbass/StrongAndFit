import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../domain/repositories/exercise_repository.dart';
import 'exercise_list_state.dart';

/// Cubit managing exercise catalogue listing, filtering by muscle group, and search.
class ExerciseListCubit extends Cubit<ExerciseListState> {
  final ExerciseRepository _exerciseRepository;
  StreamSubscription? _subscription;

  ExerciseListCubit(this._exerciseRepository) : super(const ExerciseListState()) {
    loadExercises();
  }

  void loadExercises() {
    emit(state.copyWith(status: ExerciseListStatus.loading));
    _subscribeToStream();
  }

  void selectMuscleGroup(MuscleGroup? group) {
    if (state.selectedMuscleGroup == group) {
      // Toggle filter off if already selected
      emit(state.copyWith(clearMuscleGroup: true));
    } else {
      emit(state.copyWith(selectedMuscleGroup: group));
    }
    _subscribeToStream();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void _subscribeToStream() {
    _subscription?.cancel();

    final stream = state.selectedMuscleGroup == null
        ? _exerciseRepository.watchAllExercises()
        : _exerciseRepository.watchExercisesByMuscleGroup(state.selectedMuscleGroup!);

    _subscription = stream.listen(
      (exercises) {
        emit(
          state.copyWith(
            status: ExerciseListStatus.loaded,
            exercises: exercises,
          ),
        );
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: ExerciseListStatus.error,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
