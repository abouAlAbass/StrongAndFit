import '../../enums/equipment_type.dart';
import '../../enums/muscle_group.dart';

/// Representation of a default exercise seed entry identified by its canonical [slug].
class SeedExercise {
  final String slug;
  final MuscleGroup muscleGroup;
  final EquipmentType equipment;

  const SeedExercise({
    required this.slug,
    required this.muscleGroup,
    required this.equipment,
  });
}

/// Curated catalogue of 34 foundational compound and isolation exercises.
///
/// These canonical slugs correspond directly to localized keys in the ARB files
/// (`exercise_<slug>`) resolved dynamically via `ExerciseTranslationHelper`.
const List<SeedExercise> kInitialExercises = [
  // --- CHEST ---
  SeedExercise(
    slug: 'bench_press',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'incline_dumbbell_press',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'push_up',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'dips',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'cable_fly',
    muscleGroup: MuscleGroup.chest,
    equipment: EquipmentType.cables,
  ),

  // --- BACK ---
  SeedExercise(
    slug: 'deadlift',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'barbell_row',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'pull_up',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'chin_up',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'lat_pulldown',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.machine,
  ),
  SeedExercise(
    slug: 'dumbbell_row',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'seated_cable_row',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.cables,
  ),

  // --- LEGS ---
  SeedExercise(
    slug: 'squat',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'leg_press',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.machine,
  ),
  SeedExercise(
    slug: 'romanian_deadlift',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'lunges',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'hip_thrust',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'bulgarian_split_squat',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'leg_extension',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.machine,
  ),
  SeedExercise(
    slug: 'leg_curl',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.machine,
  ),
  SeedExercise(
    slug: 'calf_raise',
    muscleGroup: MuscleGroup.legs,
    equipment: EquipmentType.machine,
  ),

  // --- SHOULDERS ---
  SeedExercise(
    slug: 'overhead_press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'dumbbell_shoulder_press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'lateral_raise',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'face_pull',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.cables,
  ),

  // --- ARMS ---
  SeedExercise(
    slug: 'barbell_curl',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'hammer_curl',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'incline_dumbbell_curl',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.dumbbell,
  ),
  SeedExercise(
    slug: 'triceps_pushdown',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.cables,
  ),
  SeedExercise(
    slug: 'overhead_triceps_extension',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.cables,
  ),
  SeedExercise(
    slug: 'skull_crusher',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.barbell,
  ),

  // --- CORE ---
  SeedExercise(
    slug: 'plank',
    muscleGroup: MuscleGroup.core,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'hanging_leg_raise',
    muscleGroup: MuscleGroup.core,
    equipment: EquipmentType.bodyweight,
  ),
  SeedExercise(
    slug: 'cable_crunch',
    muscleGroup: MuscleGroup.core,
    equipment: EquipmentType.cables,
  ),
];
