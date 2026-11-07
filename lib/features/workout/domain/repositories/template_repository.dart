import '../../../../core/database/daos/template_dao.dart';

/// Contract defining routine template queries and mutations.
abstract class TemplateRepository {
  /// Stream of all routine templates with their planned exercises.
  Stream<List<TemplateDetail>> watchAllTemplatesWithDetails();

  /// Creates a new custom workout routine template with ordered exercises and target sets.
  Future<int> createRoutine({
    required String name,
    String? notes,
    required List<({int exerciseId, int targetSets})> exercises,
  });

  /// Deletes a routine template by id.
  Future<int> deleteRoutine(int templateId);
}
