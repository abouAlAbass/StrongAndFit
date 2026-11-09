import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/enums/set_type.dart';
import '../../domain/models/exercise_personal_records.dart';
import '../../domain/repositories/workout_repository.dart';
import 'workout_session_event.dart';
import 'workout_session_state.dart';

/// Full-featured BLoC managing the lifecycle and real-time state of an active workout session.
class WorkoutSessionBloc
    extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  final WorkoutRepository _workoutRepository;
  StreamSubscription? _sessionSubscription;
  Timer? _timer;

  WorkoutSessionBloc(this._workoutRepository)
      : super(const WorkoutSessionState()) {
    on<StartSessionRequested>(_onStartSessionRequested);
    on<StartSessionFromTemplateRequested>(_onStartSessionFromTemplateRequested);
    on<LoadSessionRequested>(_onLoadSessionRequested);
    on<ResumeActiveSessionRequested>(_onResumeActiveSessionRequested);
    on<AddExerciseRequested>(_onAddExerciseRequested);
    on<AddSetRequested>(_onAddSetRequested);
    on<UpdateSetRequested>(_onUpdateSetRequested);
    on<ToggleSetCompletionRequested>(_onToggleSetCompletionRequested);
    on<DeleteSetRequested>(_onDeleteSetRequested);
    on<DeleteExerciseRequested>(_onDeleteExerciseRequested);
    on<SetExerciseSupersetRequested>(_onSetExerciseSupersetRequested);
    on<CompleteSessionRequested>(_onCompleteSessionRequested);
    on<DiscardSessionRequested>(_onDiscardSessionRequested);
    on<TimerTicked>(_onTimerTicked);
    on<TimerReset>((event, emit) => emit(state.copyWith(elapsedSeconds: event.initialSeconds)));
    on<SessionStreamUpdated>(_onSessionStreamUpdated);
  }

  Future<void> _onStartSessionRequested(
    StartSessionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    emit(state.copyWith(status: WorkoutSessionStatus.loading));
    try {
      final sessionId = await _workoutRepository.startNewSession(title: event.title);
      _startTimer(0);
      _subscribeToSession(sessionId);
    } catch (e) {
      emit(state.copyWith(
        status: WorkoutSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onStartSessionFromTemplateRequested(
    StartSessionFromTemplateRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    emit(state.copyWith(status: WorkoutSessionStatus.loading));
    try {
      final template = event.template;
      final sessionId = await _workoutRepository.startNewSession(
        title: template.template.name,
      );

      final previousMap = <int, List<SetLog>>{};

      for (final item in template.exercises) {
        final workoutExerciseId = await _workoutRepository.addExerciseToSession(
          sessionId: sessionId,
          exerciseId: item.exercise.id,
        );

        final lastSets = await _workoutRepository.fetchLastLoggedSetsForExercise(
          item.exercise.id,
          excludeSessionId: sessionId,
        );
        previousMap[item.exercise.id] = lastSets;

        final targetSets = item.templateExercise.targetSets;
        for (var setNum = 1; setNum <= targetSets; setNum++) {
          double? prefillWeight;
          int? prefillReps;
          if (setNum <= lastSets.length) {
            prefillWeight = lastSets[setNum - 1].weightKg;
            prefillReps = lastSets[setNum - 1].reps;
          }
          await _workoutRepository.addSet(
            workoutExerciseId: workoutExerciseId,
            setNumber: setNum,
            setType: SetType.normal,
            weightKg: prefillWeight,
            reps: prefillReps,
          );
        }
      }

      final prs = await _workoutRepository.fetchHistoricalPersonalRecords(
        excludeSessionId: sessionId,
      );

      emit(state.copyWith(
        previousExerciseSets: previousMap,
        personalRecords: prs,
      ));
      _startTimer(0);
      _subscribeToSession(sessionId);
    } catch (e) {
      emit(state.copyWith(
        status: WorkoutSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLoadSessionRequested(
    LoadSessionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) {
    emit(state.copyWith(status: WorkoutSessionStatus.loading));
    _subscribeToSession(event.sessionId);
  }

  Future<void> _onResumeActiveSessionRequested(
    ResumeActiveSessionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    try {
      final activeSession = await _workoutRepository.getActiveUnfinishedSession();
      if (activeSession != null) {
        _subscribeToSession(activeSession.id);
      }
    } catch (_) {
      // Ignore startup resume errors to keep main dashboard accessible
    }
  }

  void _subscribeToSession(int sessionId) {
    _sessionSubscription?.cancel();
    _sessionSubscription = _workoutRepository
        .watchSessionWithSets(sessionId)
        .listen((detail) {
      add(SessionStreamUpdated(detail));
    });
  }

  Future<void> _onSessionStreamUpdated(
    SessionStreamUpdated event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final detail = event.detail;
    if (detail == null) {
      emit(state.copyWith(
        status: WorkoutSessionStatus.initial,
        detail: null,
      ));
      return;
    }

    // Determine elapsed time based on session start
    final elapsed = DateTime.now().difference(detail.session.startedAt).inSeconds;
    if (_timer == null || !_timer!.isActive) {
      _startTimer(elapsed > 0 ? elapsed : 0);
    }

    // Fetch previous sets for any exercise not yet in previousExerciseSets cache
    final updatedPreviousMap = Map<int, List<SetLog>>.from(state.previousExerciseSets);
    final updatedPrMap = Map<int, ExercisePersonalRecords>.from(state.personalRecords);
    for (final exerciseItem in detail.exercises) {
      final exerciseId = exerciseItem.exercise.id;
      if (!updatedPreviousMap.containsKey(exerciseId)) {
        final lastSets = await _workoutRepository.fetchLastLoggedSetsForExercise(
          exerciseId,
          excludeSessionId: detail.session.id,
        );
        updatedPreviousMap[exerciseId] = lastSets;
      }
    }

    if (updatedPrMap.isEmpty && detail.exercises.isNotEmpty) {
      final historicalPrs = await _workoutRepository.fetchHistoricalPersonalRecords(
        excludeSessionId: detail.session.id,
      );
      updatedPrMap.addAll(historicalPrs);
    }

    emit(state.copyWith(
      status: detail.session.completedAt == null
          ? WorkoutSessionStatus.active
          : WorkoutSessionStatus.completed,
      detail: detail,
      previousExerciseSets: updatedPreviousMap,
      personalRecords: updatedPrMap,
    ));
  }

  Future<void> _onAddExerciseRequested(
    AddExerciseRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final session = state.detail?.session;
    if (session == null) return;

    try {
      final workoutExerciseId = await _workoutRepository.addExerciseToSession(
        sessionId: session.id,
        exerciseId: event.exerciseId,
      );

      // Fetch previous sets for this exercise to pre-fill default values
      final lastSets = await _workoutRepository.fetchLastLoggedSetsForExercise(
        event.exerciseId,
        excludeSessionId: session.id,
      );

      // Pre-fill Set 1 using the first set of the previous workout, or sensible defaults
      final defaultWeight = lastSets.isNotEmpty ? lastSets.first.weightKg : null;
      final defaultReps = lastSets.isNotEmpty ? lastSets.first.reps : null;

      await _workoutRepository.addSet(
        workoutExerciseId: workoutExerciseId,
        setNumber: 1,
        setType: SetType.normal,
        weightKg: defaultWeight,
        reps: defaultReps,
      );

      final updatedPreviousMap = Map<int, List<SetLog>>.from(state.previousExerciseSets);
      updatedPreviousMap[event.exerciseId] = lastSets;
      emit(state.copyWith(previousExerciseSets: updatedPreviousMap));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddSetRequested(
    AddSetRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final detail = state.detail;
    if (detail == null) return;

    // Find the target exercise group
    final exerciseItem = detail.exercises.firstWhere(
      (e) => e.workoutExercise.id == event.workoutExerciseId,
      orElse: () => throw Exception('Exercise not found in active session'),
    );

    final nextSetNumber = exerciseItem.sets.length + 1;

    // Check if previous session had a matching set number for ghost hints
    final previousSets = state.previousExerciseSets[exerciseItem.exercise.id] ?? [];
    double? prefillWeight;
    int? prefillReps;

    if (nextSetNumber <= previousSets.length) {
      prefillWeight = previousSets[nextSetNumber - 1].weightKg;
      prefillReps = previousSets[nextSetNumber - 1].reps;
    } else if (exerciseItem.sets.isNotEmpty) {
      // Otherwise carry forward weight from previous set of current session
      prefillWeight = exerciseItem.sets.last.weightKg;
      prefillReps = exerciseItem.sets.last.reps;
    }

    final finalWeight = event.weightKg ?? prefillWeight;
    final finalReps = event.reps ?? prefillReps;

    await _workoutRepository.addSet(
      workoutExerciseId: event.workoutExerciseId,
      setNumber: nextSetNumber,
      setType: event.setType,
      weightKg: finalWeight,
      reps: finalReps,
    );
  }

  Future<void> _onUpdateSetRequested(
    UpdateSetRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await _workoutRepository.updateSet(
      SetLogsCompanion(
        id: Value(event.setId),
        workoutExerciseId: Value(event.workoutExerciseId),
        setNumber: Value(event.setNumber),
        setType: Value(event.setType),
        weightKg: Value(event.weightKg),
        reps: Value(event.reps),
        rpe: Value(event.rpe),
        isCompleted: Value(event.isCompleted),
      ),
    );
  }

  Future<void> _onToggleSetCompletionRequested(
    ToggleSetCompletionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await _workoutRepository.toggleSetCompletion(
      setId: event.setId,
      isCompleted: event.isCompleted,
    );
  }

  Future<void> _onDeleteSetRequested(
    DeleteSetRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await _workoutRepository.deleteSet(event.setId);
  }

  Future<void> _onDeleteExerciseRequested(
    DeleteExerciseRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await _workoutRepository.deleteWorkoutExercise(event.workoutExerciseId);
  }

  Future<void> _onSetExerciseSupersetRequested(
    SetExerciseSupersetRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    await _workoutRepository.setExerciseSuperset(
      workoutExerciseId: event.workoutExerciseId,
      supersetGroupId: event.supersetGroupId,
    );
  }

  Future<void> _onCompleteSessionRequested(
    CompleteSessionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final session = state.detail?.session;
    if (session == null) return;

    _timer?.cancel();
    await _workoutRepository.completeSession(
      sessionId: session.id,
      durationSeconds: state.elapsedSeconds,
    );
    emit(state.copyWith(status: WorkoutSessionStatus.completed));
  }

  Future<void> _onDiscardSessionRequested(
    DiscardSessionRequested event,
    Emitter<WorkoutSessionState> emit,
  ) async {
    final session = state.detail?.session;
    if (session == null) return;

    _timer?.cancel();
    await _workoutRepository.discardSession(session.id);
    emit(const WorkoutSessionState(status: WorkoutSessionStatus.discarded));
  }

  void _onTimerTicked(
    TimerTicked event,
    Emitter<WorkoutSessionState> emit,
  ) {
    emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
  }

  void _startTimer(int initialSeconds) {
    _timer?.cancel();
    add(TimerReset(initialSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTicked());
    });
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _timer?.cancel();
    return super.close();
  }
}
