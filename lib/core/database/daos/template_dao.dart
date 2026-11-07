import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/exercises_table.dart';
import '../tables/template_exercises_table.dart';
import '../tables/templates_table.dart';

part 'template_dao.g.dart';

/// Data class representing a template joined with its planned exercises.
class TemplateDetail {
  final Template template;
  final List<TemplateExerciseItem> exercises;

  const TemplateDetail({
    required this.template,
    required this.exercises,
  });
}

class TemplateExerciseItem {
  final TemplateExercise templateExercise;
  final Exercise exercise;

  const TemplateExerciseItem({
    required this.templateExercise,
    required this.exercise,
  });
}

/// Data Access Object managing recurring workout templates and routine presets.
@DriftAccessor(tables: [Templates, TemplateExercises, Exercises])
class TemplateDao extends DatabaseAccessor<AppDatabase> with _$TemplateDaoMixin {
  TemplateDao(super.db);

  /// Watch all templates headers.
  Stream<List<Template>> watchAllTemplates() {
    return (select(templates)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  }

  /// Watch all routine templates joined with their constituent exercises.
  Stream<List<TemplateDetail>> watchAllTemplatesWithDetails() {
    final query = select(templates).join([
      leftOuterJoin(
        templateExercises,
        templateExercises.templateId.equalsExp(templates.id),
      ),
      leftOuterJoin(
        exercises,
        exercises.id.equalsExp(templateExercises.exerciseId),
      ),
    ])..orderBy([
        OrderingTerm.asc(templates.id),
        OrderingTerm.asc(templateExercises.orderIndex),
      ]);

    return query.watch().map((rows) {
      final map = <int, TemplateDetail>{};
      for (final row in rows) {
        final t = row.readTable(templates);
        final detail = map.putIfAbsent(
          t.id,
          () => TemplateDetail(template: t, exercises: []),
        );
        final te = row.readTableOrNull(templateExercises);
        final ex = row.readTableOrNull(exercises);
        if (te != null && ex != null) {
          if (!detail.exercises.any((item) => item.templateExercise.id == te.id)) {
            detail.exercises.add(
              TemplateExerciseItem(templateExercise: te, exercise: ex),
            );
          }
        }
      }
      return map.values.toList();
    });
  }

  /// Watch a specific template with its constituent exercises.
  Stream<TemplateDetail?> watchTemplateDetail(int templateId) {
    final query = select(templates).join([
      leftOuterJoin(
        templateExercises,
        templateExercises.templateId.equalsExp(templates.id),
      ),
      leftOuterJoin(
        exercises,
        exercises.id.equalsExp(templateExercises.exerciseId),
      ),
    ])
      ..where(templates.id.equals(templateId))
      ..orderBy([OrderingTerm.asc(templateExercises.orderIndex)]);

    return query.watch().map((rows) {
      if (rows.isEmpty) return null;
      final template = rows.first.readTable(templates);
      final items = <TemplateExerciseItem>[];

      for (final row in rows) {
        final te = row.readTableOrNull(templateExercises);
        final ex = row.readTableOrNull(exercises);
        if (te != null && ex != null) {
          items.add(TemplateExerciseItem(templateExercise: te, exercise: ex));
        }
      }

      return TemplateDetail(template: template, exercises: items);
    });
  }

  /// Create a new template header.
  Future<int> createTemplate(TemplatesCompanion entry) {
    return into(templates).insert(entry);
  }

  /// Add an exercise to a template.
  Future<int> addExerciseToTemplate(TemplateExercisesCompanion entry) {
    return into(templateExercises).insert(entry);
  }

  /// Delete a template and cascade its exercise references.
  Future<int> deleteTemplate(int templateId) {
    return (delete(templates)..where((t) => t.id.equals(templateId))).go();
  }
}
