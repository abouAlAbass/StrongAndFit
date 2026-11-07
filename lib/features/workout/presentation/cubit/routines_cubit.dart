import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/template_repository.dart';
import 'routines_state.dart';

/// Cubit managing pre-designed workout routines and user routine presets.
class RoutinesCubit extends Cubit<RoutinesState> {
  final TemplateRepository _templateRepository;
  StreamSubscription? _subscription;

  RoutinesCubit(this._templateRepository) : super(const RoutinesState()) {
    loadTemplates();
  }

  void loadTemplates() {
    emit(state.copyWith(status: RoutinesStatus.loading));
    _subscription?.cancel();
    _subscription = _templateRepository.watchAllTemplatesWithDetails().listen(
      (templates) {
        emit(
          state.copyWith(
            status: RoutinesStatus.loaded,
            templates: templates,
          ),
        );
      },
      onError: (err) {
        emit(
          state.copyWith(
            status: RoutinesStatus.error,
            errorMessage: err.toString(),
          ),
        );
      },
    );
  }

  Future<int> createRoutine({
    required String name,
    String? notes,
    required List<({int exerciseId, int targetSets})> exercises,
  }) {
    return _templateRepository.createRoutine(
      name: name,
      notes: notes,
      exercises: exercises,
    );
  }

  Future<void> deleteRoutine(int templateId) async {
    await _templateRepository.deleteRoutine(templateId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
