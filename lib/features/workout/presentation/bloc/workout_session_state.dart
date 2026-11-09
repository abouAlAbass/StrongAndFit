import 'package:equatable/equatable.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/models/exercise_personal_records.dart';
import '../../domain/models/workout_session_detail.dart';

enum WorkoutSessionStatus {
  initial,
  loading,
  active,
  completed,
  discarded,
  error,
}

class WorkoutSessionState extends Equatable {
  final WorkoutSessionStatus status;
  final WorkoutSessionDetail? detail;

  /// Cached previous session set logs mapped by exercise ID (for ghost-prefill hints).
  final Map<int, List<SetLog>> previousExerciseSets;

  /// Historical personal records mapped by exercise ID.
  final Map<int, ExercisePersonalRecords> personalRecords;

  final int elapsedSeconds;
  final String? errorMessage;

  const WorkoutSessionState({
    this.status = WorkoutSessionStatus.initial,
    this.detail,
    this.previousExerciseSets = const {},
    this.personalRecords = const {},
    this.elapsedSeconds = 0,
    this.errorMessage,
  });

  bool get hasActiveSession =>
      status == WorkoutSessionStatus.active && detail != null;

  String get formattedDuration {
    final hours = elapsedSeconds ~/ 3600;
    final minutes = (elapsedSeconds % 3600) ~/ 60;
    final seconds = elapsedSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  WorkoutSessionState copyWith({
    WorkoutSessionStatus? status,
    WorkoutSessionDetail? detail,
    Map<int, List<SetLog>>? previousExerciseSets,
    Map<int, ExercisePersonalRecords>? personalRecords,
    int? elapsedSeconds,
    String? errorMessage,
  }) {
    return WorkoutSessionState(
      status: status ?? this.status,
      detail: detail ?? this.detail,
      previousExerciseSets: previousExerciseSets ?? this.previousExerciseSets,
      personalRecords: personalRecords ?? this.personalRecords,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    detail,
    previousExerciseSets,
    personalRecords,
    elapsedSeconds,
    errorMessage,
  ];
}
