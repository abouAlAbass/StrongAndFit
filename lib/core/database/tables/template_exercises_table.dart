import 'package:drift/drift.dart';
import 'exercises_table.dart';
import 'templates_table.dart';

/// Database join table representing exercises configured inside a workout routine template.
@DataClassName('TemplateExercise')
class TemplateExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key linking to the parent template.
  IntColumn get templateId => integer().references(
        Templates,
        #id,
        onDelete: KeyAction.cascade,
      )();

  /// Foreign key referencing the master exercise record.
  IntColumn get exerciseId => integer().references(
        Exercises,
        #id,
        onDelete: KeyAction.restrict,
      )();

  /// Sequence ordering index of the exercise within the template (0-indexed).
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  /// Planned number of target sets for this exercise.
  IntColumn get targetSets => integer().withDefault(const Constant(3))();

  /// Exercise-specific notes or cues inside this routine.
  TextColumn get notes => text().nullable()();
}
