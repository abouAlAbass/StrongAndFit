import '../../../../core/database/app_database.dart';
import '../../../../core/enums/equipment_type.dart';
import '../../../../core/enums/muscle_group.dart';
import '../models/exercise_guide.dart';

/// Contract defining exercise domain operations.
abstract class ExerciseRepository {
  /// Stream of all exercises.
  Stream<List<Exercise>> watchAllExercises();

  /// Stream of exercises filtered by muscle group.
  Stream<List<Exercise>> watchExercisesByMuscleGroup(MuscleGroup muscleGroup);

  /// Search exercises by name/slug.
  Future<List<Exercise>> searchExercises(String query);

  /// Fetch a single exercise by id.
  Future<Exercise?> getExerciseById(int id);

  /// Create a user-defined custom exercise.
  Future<int> createCustomExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required EquipmentType equipment,
  });

  /// Retrieve the biomechanical and technique guide for an exercise.
  ExerciseGuide getExerciseGuide(
    String slug,
    String languageCode, {
    String? displayName,
  });
}
