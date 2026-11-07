import '../../enums/equipment_type.dart';
import '../../enums/muscle_group.dart';

/// Representation of a default exercise seed entry.
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

/// Curated catalogue of 16 foundational compound and isolation exercises.
///
/// These canonical slugs correspond directly to localized keys in the ARB files:
/// `exercise_<slug>`
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
    slug: 'lat_pulldown',
    muscleGroup: MuscleGroup.back,
    equipment: EquipmentType.machine,
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

  // --- SHOULDERS ---
  SeedExercise(
    slug: 'overhead_press',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'lateral_raise',
    muscleGroup: MuscleGroup.shoulders,
    equipment: EquipmentType.dumbbell,
  ),

  // --- ARMS ---
  SeedExercise(
    slug: 'barbell_curl',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.barbell,
  ),
  SeedExercise(
    slug: 'triceps_pushdown',
    muscleGroup: MuscleGroup.arms,
    equipment: EquipmentType.cables,
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
];
