import 'package:drift/drift.dart';
import '../../enums/muscle_group.dart';
import '../app_database.dart';
import '../tables/exercises_table.dart';

part 'exercise_dao.g.dart';

/// Data Access Object for querying and mutating exercise records.
@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Reactive stream of all exercises sorted alphabetically.
  Stream<List<Exercise>> watchAllExercises() {
    return (select(exercises)
          ..orderBy([(t) => OrderingTerm.asc(t.slug)]))
        .watch();
  }

  /// Reactive stream of exercises filtered by target muscle group.
  Stream<List<Exercise>> watchExercisesByMuscleGroup(MuscleGroup group) {
    return (select(exercises)
          ..where((t) => t.muscleGroup.equalsValue(group))
          ..orderBy([(t) => OrderingTerm.asc(t.slug)]))
        .watch();
  }

  /// Search exercises by slug or custom name with case-insensitive matching.
  Future<List<Exercise>> searchExercises(String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(exercises)
          ..where((t) => t.slug.lower().like(pattern) | t.customName.lower().like(pattern))
          ..orderBy([(t) => OrderingTerm.asc(t.slug)]))
        .get();
  }

  /// Fetch a single exercise by unique primary key.
  Future<Exercise?> getExerciseById(int id) {
    return (select(exercises)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Fetch a single exercise by unique slug identifier.
  Future<Exercise?> getExerciseBySlug(String slug) {
    return (select(exercises)..where((t) => t.slug.equals(slug))).getSingleOrNull();
  }

  /// Create a user-defined custom exercise.
  Future<int> insertCustomExercise(ExercisesCompanion entry) {
    return into(exercises).insert(entry);
  }
}
