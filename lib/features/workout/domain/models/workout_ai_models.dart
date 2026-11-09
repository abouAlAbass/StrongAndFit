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

/// Athlete's questionnaire responses used to tailor program analysis.
class ProgramAiQuestionnaire extends Equatable {
  final String fatigueLevel;
  final String targetFocus;
  final String sessionDuration;
  final String painOrInjuries;
  final String? freeTextNotes;

  const ProgramAiQuestionnaire({
    required this.fatigueLevel,
    required this.targetFocus,
    required this.sessionDuration,
    required this.painOrInjuries,
    this.freeTextNotes,
  });

  Map<String, dynamic> toJson() => {
    'fatigue_level': fatigueLevel,
    'target_focus': targetFocus,
    'session_duration': sessionDuration,
    'pain_or_injuries': painOrInjuries,
    if (freeTextNotes != null && freeTextNotes!.trim().isNotEmpty)
      'free_text_notes': freeTextNotes!.trim(),
  };

  @override
  List<Object?> get props => [
    fatigueLevel,
    targetFocus,
    sessionDuration,
    painOrInjuries,
    freeTextNotes,
  ];
}

/// Deep athletic analysis of a workout program or routine.
class ProgramAiAnalysis extends Equatable {
  final String summary;
  final int programMatchScore; // 1-10
  final String volumeAssessment;
  final List<String> customizedModifications;
  final List<String> injuryPreventionTips;
  final List<String> periodizationAdvice;

  const ProgramAiAnalysis({
    required this.summary,
    required this.programMatchScore,
    required this.volumeAssessment,
    required this.customizedModifications,
    required this.injuryPreventionTips,
    required this.periodizationAdvice,
  });

  factory ProgramAiAnalysis.fromJson(Map<String, dynamic> json) {
    return ProgramAiAnalysis(
      summary: json['summary'] as String? ?? 'Analyse du programme terminée.',
      programMatchScore:
          (json['program_match_score'] as num?)?.toInt().clamp(1, 10) ?? 8,
      volumeAssessment:
          json['volume_assessment'] as String? ??
          'Volume d\'entraînement équilibré.',
      customizedModifications:
          (json['modifications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      injuryPreventionTips:
          (json['injury_prevention'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      periodizationAdvice:
          (json['periodization'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'program_match_score': programMatchScore,
    'volume_assessment': volumeAssessment,
    'modifications': customizedModifications,
    'injury_prevention': injuryPreventionTips,
    'periodization': periodizationAdvice,
  };

  @override
  List<Object?> get props => [
    summary,
    programMatchScore,
    volumeAssessment,
    customizedModifications,
    injuryPreventionTips,
    periodizationAdvice,
  ];
}

/// Long-term athletic progress analysis across completed workout history.
class HistoryAiAnalysis extends Equatable {
  final String executiveSummary;
  final int progressionScore; // 1-10
  final String progressiveOverloadRate;
  final String volumeTrajectory;
  final String muscularBalance;
  final List<String> fatigueAndPlateauAlerts;
  final List<String> nextCycleMilestones;

  const HistoryAiAnalysis({
    required this.executiveSummary,
    required this.progressionScore,
    required this.progressiveOverloadRate,
    required this.volumeTrajectory,
    required this.muscularBalance,
    required this.fatigueAndPlateauAlerts,
    required this.nextCycleMilestones,
  });

  factory HistoryAiAnalysis.fromJson(Map<String, dynamic> json) {
    return HistoryAiAnalysis(
      executiveSummary:
          json['executive_summary'] as String? ??
          'Progression globale positive.',
      progressionScore:
          (json['progression_score'] as num?)?.toInt().clamp(1, 10) ?? 8,
      progressiveOverloadRate:
          json['progressive_overload_rate'] as String? ??
          'Surcharge progressive régulière.',
      volumeTrajectory:
          json['volume_trajectory'] as String? ?? 'Volume stable et maîtrisé.',
      muscularBalance:
          json['muscular_balance'] as String? ??
          'Répartition musculaire proportionnée.',
      fatigueAndPlateauAlerts:
          (json['plateaus_and_fatigue'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      nextCycleMilestones:
          (json['next_milestones'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'executive_summary': executiveSummary,
    'progression_score': progressionScore,
    'progressive_overload_rate': progressiveOverloadRate,
    'volume_trajectory': volumeTrajectory,
    'muscular_balance': muscularBalance,
    'plateaus_and_fatigue': fatigueAndPlateauAlerts,
    'next_milestones': nextCycleMilestones,
  };

  @override
  List<Object?> get props => [
    executiveSummary,
    progressionScore,
    progressiveOverloadRate,
    volumeTrajectory,
    muscularBalance,
    fatigueAndPlateauAlerts,
    nextCycleMilestones,
  ];
}

/// Single exercise recommendation inside an AI-generated routine template.
class GeneratedAiRoutineExercise extends Equatable {
  final int exerciseId;
  final String? exerciseSlug;
  final String exerciseName;
  final int targetSets;

  const GeneratedAiRoutineExercise({
    required this.exerciseId,
    this.exerciseSlug,
    required this.exerciseName,
    required this.targetSets,
  });

  Map<String, dynamic> toJson() => {
    'exercise_id': exerciseId,
    'exercise_slug': ?exerciseSlug,
    'exercise_name': exerciseName,
    'target_sets': targetSets,
  };

  factory GeneratedAiRoutineExercise.fromJson(Map<String, dynamic> json) {
    return GeneratedAiRoutineExercise(
      exerciseId:
          (json['exercise_id'] as num?)?.toInt() ??
          (json['exerciseId'] as num?)?.toInt() ??
          0,
      exerciseSlug:
          json['exercise_slug'] as String? ??
          json['exerciseSlug'] as String? ??
          json['slug'] as String?,
      exerciseName:
          json['exercise_name'] as String? ??
          json['exerciseName'] as String? ??
          json['name'] as String? ??
          'Exercice',
      targetSets:
          ((json['target_sets'] ?? json['targetSets']) as num?)?.toInt().clamp(
            1,
            10,
          ) ??
          3,
    );
  }

  @override
  List<Object?> get props => [
    exerciseId,
    exerciseSlug,
    exerciseName,
    targetSets,
  ];
}

/// Fully designed workout routine generated by Gemini AI ready for 1-click SQLite insertion.
class GeneratedAiRoutine extends Equatable {
  final String name;
  final String rationale;
  final List<GeneratedAiRoutineExercise> exercises;

  const GeneratedAiRoutine({
    required this.name,
    required this.rationale,
    required this.exercises,
  });

  factory GeneratedAiRoutine.fromJson(Map<String, dynamic> json) {
    final rawExercises = json['exercises'] as List<dynamic>? ?? [];
    return GeneratedAiRoutine(
      name:
          json['name'] as String? ??
          json['program_name'] as String? ??
          'Programme Personnalisé IA',
      rationale:
          json['rationale'] as String? ??
          json['notes'] as String? ??
          'Programme d\'entraînement optimisé par le Coach IA Gemini.',
      exercises: rawExercises
          .map(
            (e) =>
                GeneratedAiRoutineExercise.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'rationale': rationale,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [name, rationale, exercises];
}
