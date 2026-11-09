import 'package:equatable/equatable.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../../../core/enums/set_type.dart';
import '../../domain/models/workout_session_detail.dart';

abstract class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => [];
}

class StartSessionRequested extends WorkoutSessionEvent {
  final String? title;

  const StartSessionRequested({this.title});

  @override
  List<Object?> get props => [title];
}

class StartSessionFromTemplateRequested extends WorkoutSessionEvent {
  final TemplateDetail template;

  const StartSessionFromTemplateRequested(this.template);

  @override
  List<Object?> get props => [template];
}

class LoadSessionRequested extends WorkoutSessionEvent {
  final int sessionId;

  const LoadSessionRequested(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

/// Checks if an unfinished workout session exists in SQLite and resumes it automatically.
class ResumeActiveSessionRequested extends WorkoutSessionEvent {
  const ResumeActiveSessionRequested();
}

class AddExerciseRequested extends WorkoutSessionEvent {
  final int exerciseId;

  const AddExerciseRequested(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class AddSetRequested extends WorkoutSessionEvent {
  final int workoutExerciseId;
  final SetType setType;
  final double? weightKg;
  final int? reps;

  const AddSetRequested(
    this.workoutExerciseId, {
    this.setType = SetType.normal,
    this.weightKg,
    this.reps,
  });

  @override
  List<Object?> get props => [workoutExerciseId, setType, weightKg, reps];
}

class UpdateSetRequested extends WorkoutSessionEvent {
  final int setId;
  final int workoutExerciseId;
  final int setNumber;
  final SetType setType;
  final double? weightKg;
  final int? reps;
  final double? rpe;
  final bool isCompleted;

  const UpdateSetRequested({
    required this.setId,
    required this.workoutExerciseId,
    required this.setNumber,
    required this.setType,
    this.weightKg,
    this.reps,
    this.rpe,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
    setId,
    workoutExerciseId,
    setNumber,
    setType,
    weightKg,
    reps,
    rpe,
    isCompleted,
  ];
}

class ToggleSetCompletionRequested extends WorkoutSessionEvent {
  final int setId;
  final bool isCompleted;

  const ToggleSetCompletionRequested({
    required this.setId,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [setId, isCompleted];
}

class DeleteSetRequested extends WorkoutSessionEvent {
  final int setId;

  const DeleteSetRequested(this.setId);

  @override
  List<Object?> get props => [setId];
}

class DeleteExerciseRequested extends WorkoutSessionEvent {
  final int workoutExerciseId;

  const DeleteExerciseRequested(this.workoutExerciseId);

  @override
  List<Object?> get props => [workoutExerciseId];
}

class SetExerciseSupersetRequested extends WorkoutSessionEvent {
  final int workoutExerciseId;
  final int? supersetGroupId;

  const SetExerciseSupersetRequested({
    required this.workoutExerciseId,
    required this.supersetGroupId,
  });

  @override
  List<Object?> get props => [workoutExerciseId, supersetGroupId];
}

class CompleteSessionRequested extends WorkoutSessionEvent {
  const CompleteSessionRequested();
}

class DiscardSessionRequested extends WorkoutSessionEvent {
  const DiscardSessionRequested();
}

class TimerTicked extends WorkoutSessionEvent {
  const TimerTicked();
}

class TimerReset extends WorkoutSessionEvent {
  final int initialSeconds;

  const TimerReset(this.initialSeconds);

  @override
  List<Object?> get props => [initialSeconds];
}

/// Internal event fired when Drift database stream emits updated session details.
class SessionStreamUpdated extends WorkoutSessionEvent {
  final WorkoutSessionDetail? detail;

  const SessionStreamUpdated(this.detail);

  @override
  List<Object?> get props => [detail];
}
