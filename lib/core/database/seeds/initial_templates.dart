/// Representation of a planned exercise inside a seed routine template.
class SeedTemplateExercise {
  final String exerciseSlug;
  final int targetSets;
  final String? notes;

  const SeedTemplateExercise({
    required this.exerciseSlug,
    this.targetSets = 3,
    this.notes,
  });
}

/// Representation of a pre-designed workout routine template.
class SeedTemplate {
  final String slug;
  final String name;
  final String notes;
  final List<SeedTemplateExercise> exercises;

  const SeedTemplate({
    required this.slug,
    required this.name,
    required this.notes,
    required this.exercises,
  });
}

/// Curated pre-designed routines crafted for both beginners (Full Body) and advanced athletes (Split / Upper-Lower).
const List<SeedTemplate> kInitialTemplates = [
  SeedTemplate(
    slug: 'full_body_split',
    name: 'Full Body Split (Foundation)',
    notes: 'Balanced whole-body workout targeting compound patterns. Recommended 3x per week for optimal recovery and strength gains.',
    exercises: [
      SeedTemplateExercise(exerciseSlug: 'squat', targetSets: 3, notes: 'Focus on depth and brace core'),
      SeedTemplateExercise(exerciseSlug: 'bench_press', targetSets: 3, notes: 'Retract scapula and drive with legs'),
      SeedTemplateExercise(exerciseSlug: 'barbell_row', targetSets: 3, notes: '45 degree torso angle, pull to hips'),
      SeedTemplateExercise(exerciseSlug: 'overhead_press', targetSets: 3, notes: 'Full lockout overhead'),
      SeedTemplateExercise(exerciseSlug: 'romanian_deadlift', targetSets: 3, notes: 'Hinge at the hips, feel hamstring stretch'),
      SeedTemplateExercise(exerciseSlug: 'plank', targetSets: 3, notes: 'Keep pelvis neutral and glutes engaged'),
    ],
  ),
  SeedTemplate(
    slug: 'upper_body_power',
    name: 'Upper Body Power & Hypertrophy',
    notes: 'Complete upper body push & pull supersets. Great for 4-day Upper/Lower splits.',
    exercises: [
      SeedTemplateExercise(exerciseSlug: 'bench_press', targetSets: 4, notes: 'Heavy working sets'),
      SeedTemplateExercise(exerciseSlug: 'pull_up', targetSets: 3, notes: 'Full dead-hang to chin over bar'),
      SeedTemplateExercise(exerciseSlug: 'incline_dumbbell_press', targetSets: 3, notes: '30-degree incline for upper clavicular head'),
      SeedTemplateExercise(exerciseSlug: 'barbell_row', targetSets: 3, notes: 'Strict form, no excessive momentum'),
      SeedTemplateExercise(exerciseSlug: 'lateral_raise', targetSets: 3, notes: 'Controlled tempo for lateral deltoids'),
      SeedTemplateExercise(exerciseSlug: 'barbell_curl', targetSets: 3, notes: 'Elbows pinned to sides'),
      SeedTemplateExercise(exerciseSlug: 'triceps_pushdown', targetSets: 3, notes: 'Full elbow extension at bottom'),
    ],
  ),
  SeedTemplate(
    slug: 'lower_body_core',
    name: 'Lower Body & Core Engine',
    notes: 'Heavy compound leg training paired with functional anterior core stabilization.',
    exercises: [
      SeedTemplateExercise(exerciseSlug: 'squat', targetSets: 4, notes: 'Primary leg compound builder'),
      SeedTemplateExercise(exerciseSlug: 'romanian_deadlift', targetSets: 3, notes: 'Hamstrings & glutes development'),
      SeedTemplateExercise(exerciseSlug: 'leg_press', targetSets: 3, notes: 'Foot placement high on sled for quad pump'),
      SeedTemplateExercise(exerciseSlug: 'hanging_leg_raise', targetSets: 3, notes: 'Avoid swinging, lift using lower abs'),
      SeedTemplateExercise(exerciseSlug: 'plank', targetSets: 3, notes: 'Time-based isometric hold'),
    ],
  ),
  SeedTemplate(
    slug: 'push_hypertrophy',
    name: 'Push Day (Chest, Shoulders, Triceps)',
    notes: 'Classic push workout focusing on pressing angles and shoulder width.',
    exercises: [
      SeedTemplateExercise(exerciseSlug: 'bench_press', targetSets: 4, notes: 'Primary heavy chest compound'),
      SeedTemplateExercise(exerciseSlug: 'overhead_press', targetSets: 3, notes: 'Strict overhead shoulder press'),
      SeedTemplateExercise(exerciseSlug: 'incline_dumbbell_press', targetSets: 3, notes: 'Controlled eccentric'),
      SeedTemplateExercise(exerciseSlug: 'lateral_raise', targetSets: 3, notes: 'Constant tension on medial delts'),
      SeedTemplateExercise(exerciseSlug: 'triceps_pushdown', targetSets: 3, notes: 'Flared grip for triceps lateral head'),
      SeedTemplateExercise(exerciseSlug: 'push_up', targetSets: 3, notes: 'Burnout sets to near failure'),
    ],
  ),
  SeedTemplate(
    slug: 'pull_strength',
    name: 'Pull Day (Back, Biceps, Posterior Chain)',
    notes: 'Heavy back builder with deadlifts, rows, vertical pulls and biceps focus.',
    exercises: [
      SeedTemplateExercise(exerciseSlug: 'deadlift', targetSets: 4, notes: 'The king of posterior chain exercises'),
      SeedTemplateExercise(exerciseSlug: 'pull_up', targetSets: 3, notes: 'Wide grip lat activation'),
      SeedTemplateExercise(exerciseSlug: 'barbell_row', targetSets: 3, notes: 'Mid-back and rhomboid thickness'),
      SeedTemplateExercise(exerciseSlug: 'lat_pulldown', targetSets: 3, notes: 'Deep squeeze at the clavicle'),
      SeedTemplateExercise(exerciseSlug: 'barbell_curl', targetSets: 3, notes: 'Heavy bicep overload'),
    ],
  ),
];
