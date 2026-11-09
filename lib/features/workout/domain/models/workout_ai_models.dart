import 'package:equatable/equatable.dart';

/// Aggregated exercise summary for AI physical preparation analysis.
class ExerciseSummary extends Equatable {
  final String exerciseName;
  final String muscleGroup;
  final int totalSets;
  final int totalReps;
  final double topWeightKg;
  final double? avgRpe;
  final bool hasPersonalRecord;

  const ExerciseSummary({
    required this.exerciseName,
    required this.muscleGroup,
    required this.totalSets,
    required this.totalReps,
    required this.topWeightKg,
    this.avgRpe,
    this.hasPersonalRecord = false,
  });

  Map<String, dynamic> toJson() => {
    'exercise': exerciseName,
    'muscle_group': muscleGroup,
    'sets': totalSets,
    'reps': totalReps,
    'top_weight_kg': topWeightKg,
    if (avgRpe != null) 'avg_rpe': avgRpe,
    'has_pr': hasPersonalRecord,
  };

  @override
  List<Object?> get props => [
    exerciseName,
    muscleGroup,
    totalSets,
    totalReps,
    topWeightKg,
    avgRpe,
    hasPersonalRecord,
  ];
}

/// Workout session payload provided to the Gemini model for athletic analysis.
class WorkoutSummary extends Equatable {
  final String athleteName;
  final String? experienceLevel;
  final double? bodyWeightKg;
  final String workoutTitle;
  final DateTime date;
  final int durationMinutes;
  final double totalVolumeKg;
  final List<ExerciseSummary> exercises;
  final List<String> recentPrs;
  final String? athleteFeedback;

  const WorkoutSummary({
    required this.athleteName,
    this.experienceLevel,
    this.bodyWeightKg,
    required this.workoutTitle,
    required this.date,
    required this.durationMinutes,
    required this.totalVolumeKg,
    required this.exercises,
    this.recentPrs = const [],
    this.athleteFeedback,
  });

  Map<String, dynamic> toJson() => {
    'athlete': {
      'name': athleteName,
      if (experienceLevel != null) 'experience_level': experienceLevel,
      if (bodyWeightKg != null) 'body_weight_kg': bodyWeightKg,
    },
    'session': {
      'title': workoutTitle,
      'date': date.toIso8601String(),
      'duration_minutes': durationMinutes,
      'total_volume_kg': totalVolumeKg,
      if (athleteFeedback != null) 'athlete_feedback': athleteFeedback,
    },
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'personal_records': recentPrs,
  };

  @override
  List<Object?> get props => [
    athleteName,
    experienceLevel,
    bodyWeightKg,
    workoutTitle,
    date,
    durationMinutes,
    totalVolumeKg,
    exercises,
    recentPrs,
    athleteFeedback,
  ];
}

/// Structured AI feedback returned by the Gemini physical preparation coach.
class WorkoutAiAnalysis extends Equatable {
  final String overview;
  final String progressiveOverloadAssessment;
  final String recoveryAndRpeAssessment;
  final List<String> strengthHighlights;
  final List<String> plateausOrRisks;
  final List<String> nextCycleRecommendations;
  final int overallScore; // 1 to 10

  const WorkoutAiAnalysis({
    required this.overview,
    required this.progressiveOverloadAssessment,
    required this.recoveryAndRpeAssessment,
    required this.strengthHighlights,
    required this.plateausOrRisks,
    required this.nextCycleRecommendations,
    required this.overallScore,
  });

  factory WorkoutAiAnalysis.fromJson(Map<String, dynamic> json) {
    return WorkoutAiAnalysis(
      overview:
          json['overview'] as String? ?? 'Analyse générale non disponible.',
      progressiveOverloadAssessment:
          json['progressive_overload'] as String? ??
          'Surcharge progressive continue.',
      recoveryAndRpeAssessment:
          json['recovery_and_rpe'] as String? ??
          'Gestion de l\'intensité adéquate.',
      strengthHighlights:
          (json['highlights'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      plateausOrRisks:
          (json['plateaus_or_risks'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      nextCycleRecommendations:
          (json['next_cycle_recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      overallScore: (json['overall_score'] as num?)?.toInt().clamp(1, 10) ?? 8,
    );
  }

  @override
  List<Object?> get props => [
    overview,
    progressiveOverloadAssessment,
    recoveryAndRpeAssessment,
    strengthHighlights,
    plateausOrRisks,
    nextCycleRecommendations,
    overallScore,
  ];
}
