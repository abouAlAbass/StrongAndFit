import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/exercise_dao.dart';
import '../../../../core/enums/equipment_type.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../data/exercise_guides_data.dart';
import '../../domain/models/exercise_guide.dart';
import '../../domain/repositories/exercise_repository.dart';

/// Concrete implementation of [ExerciseRepository] backed by Drift SQLite DAO.
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseDao _exerciseDao;

  ExerciseRepositoryImpl(this._exerciseDao);

  @override
  Stream<List<Exercise>> watchAllExercises() {
    return _exerciseDao.watchAllExercises();
  }

  @override
  Stream<List<Exercise>> watchExercisesByMuscleGroup(MuscleGroup muscleGroup) {
    return _exerciseDao.watchExercisesByMuscleGroup(muscleGroup);
  }

  @override
  Future<List<Exercise>> searchExercises(String query) {
    return _exerciseDao.searchExercises(query);
  }

  @override
  Future<Exercise?> getExerciseById(int id) {
    return _exerciseDao.getExerciseById(id);
  }

  @override
  Future<int> createCustomExercise({
    required String name,
    required MuscleGroup muscleGroup,
    required EquipmentType equipment,
  }) {
    // Generate a sanitized slug for custom exercise identifier uniqueness
    final sanitizedSlug =
        'custom_${DateTime.now().millisecondsSinceEpoch}_${name.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';

    return _exerciseDao.insertCustomExercise(
      ExercisesCompanion.insert(
        slug: sanitizedSlug,
        customName: Value(name),
        muscleGroup: muscleGroup,
        equipment: equipment,
        isCustom: const Value(true),
      ),
    );
  }

  @override
  ExerciseGuide getExerciseGuide(
    String slug,
    String languageCode, {
    String? displayName,
  }) {
    return ExerciseGuidesData.getGuide(
      slug,
      languageCode,
      displayName: displayName,
    );
  }
}
