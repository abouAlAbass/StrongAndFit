import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../domain/repositories/template_repository.dart';

/// Concrete implementation of [TemplateRepository] backed by Drift [TemplateDao].
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateDao _templateDao;

  TemplateRepositoryImpl(this._templateDao);

  @override
  Stream<List<TemplateDetail>> watchAllTemplatesWithDetails() {
    return _templateDao.watchAllTemplatesWithDetails();
  }

  @override
  Future<int> createRoutine({
    required String name,
    String? notes,
    required List<({int exerciseId, int targetSets})> exercises,
  }) async {
    final templateId = await _templateDao.createTemplate(
      TemplatesCompanion.insert(name: name, notes: Value(notes)),
    );

    for (var i = 0; i < exercises.length; i++) {
      final item = exercises[i];
      await _templateDao.addExerciseToTemplate(
        TemplateExercisesCompanion.insert(
          templateId: templateId,
          exerciseId: item.exerciseId,
          orderIndex: Value(i),
          targetSets: Value(item.targetSets),
        ),
      );
    }

    return templateId;
  }

  @override
  Future<int> deleteRoutine(int templateId) {
    return _templateDao.deleteTemplate(templateId);
  }
}
