import 'package:drift/drift.dart';
import 'exercises_table.dart';
import 'workout_sessions_table.dart';

/// Database join table linking exercises performed within a specific workout session.
@DataClassName('WorkoutExercise')
class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key linking to the parent workout session.
  IntColumn get sessionId => integer().references(
        WorkoutSessions,
        #id,
        onDelete: KeyAction.cascade,
      )();

  /// Foreign key referencing the master exercise record.
  IntColumn get exerciseId => integer().references(
        Exercises,
        #id,
        onDelete: KeyAction.restrict,
      )();

  /// Sequence ordering index of the exercise within the workout session (0-indexed).
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();

  /// Optional grouping key linking two or more exercises in a superset circuit (e.g. 1 for A1/A2, 2 for B1/B2).
  IntColumn get supersetGroupId => integer().nullable()();
}
