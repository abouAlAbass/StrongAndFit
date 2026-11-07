import '../../../../core/enums/experience_level.dart';

/// Athlete's primary training goal.
enum TrainingGoal {
  hypertrophy,
  strength,
  fitness,
}

/// Algorithmic match result linking athlete availability and level to the optimal routine.
class RoutineRecommendation {
  final String templateSlug;
  final String routineName;
  final String rationale;
  final int recommendedDaysPerWeek;
  final ExperienceLevel recommendedLevel;
  final TrainingGoal goal;

  const RoutineRecommendation({
    required this.templateSlug,
    required this.routineName,
    required this.rationale,
    required this.recommendedDaysPerWeek,
    required this.recommendedLevel,
    required this.goal,
  });
}

/// Science-based routine recommender matching frequency, athletic maturity,
/// and muscular adaptation goals to pre-designed training splits.
class RoutineRecommender {
  RoutineRecommender._();

  static RoutineRecommendation match({
    required TrainingGoal goal,
    required int daysPerWeek,
    required ExperienceLevel experienceLevel,
  }) {
    // 1. Beginners (< 1 year) or 3-day lifters -> Full Body Split
    if (daysPerWeek <= 3 || experienceLevel == ExperienceLevel.beginner) {
      return RoutineRecommendation(
        templateSlug: 'full_body_split',
        routineName: 'Full Body Split (Foundation)',
        rationale:
            'Full-body frequency (3x/week) provides optimal neuromuscular adaptation, motor pattern reinforcement, and 48h systemic recovery.',
        recommendedDaysPerWeek: 3,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    // 2. 4 days availability -> Upper / Lower Split
    if (daysPerWeek == 4) {
      return RoutineRecommendation(
        templateSlug: 'upper_body_power',
        routineName: 'Upper Body Power & Hypertrophy',
        rationale:
            'An Upper/Lower 4-day split offers the ideal distribution for hypertrophy and heavy compound recovery across the week.',
        recommendedDaysPerWeek: 4,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    // 3. 5+ days availability -> Push / Pull / Legs Split
    if (goal == TrainingGoal.strength) {
      return RoutineRecommendation(
        templateSlug: 'pull_strength',
        routineName: 'Pull Day (Back, Biceps, Posterior Chain)',
        rationale:
            'High-frequency Push/Pull/Legs rotation isolating posterior chain mechanics and heavy pulling density for advanced athletes.',
        recommendedDaysPerWeek: 5,
        recommendedLevel: experienceLevel,
        goal: goal,
      );
    }

    return RoutineRecommendation(
      templateSlug: 'push_hypertrophy',
      routineName: 'Push Day (Chest, Shoulders, Triceps)',
      rationale:
          'Specialized Push/Pull/Legs volume split maximizing mechanical tension and metabolic stress across pressing muscle groups.',
      recommendedDaysPerWeek: 5,
      recommendedLevel: experienceLevel,
      goal: goal,
    );
  }
}
