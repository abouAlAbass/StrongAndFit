import 'package:drift/drift.dart';
import '../../enums/set_type.dart';
import 'workout_exercises_table.dart';

/// Database table storing individual set logs recorded for an exercise during a session.
@DataClassName('SetLog')
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key linking this set to its parent workout exercise instance.
  IntColumn get workoutExerciseId => integer().references(
    WorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// Set order number within the exercise (1, 2, 3, ...).
  IntColumn get setNumber => integer()();

  /// Set category classification: warmup, normal, dropset, or failure.
  TextColumn get setType =>
      textEnum<SetType>().withDefault(Constant(SetType.normal.name))();

  /// Weight lifted in kilograms. Nullable for purely bodyweight reps.
  RealColumn get weightKg => real().nullable()();

  /// Number of completed repetitions.
  IntColumn get reps => integer().nullable()();

  /// Rate of Perceived Exertion (RPE), on a 1.0 to 10.0 scale.
  RealColumn get rpe => real().nullable()();

  /// Checkmark status indicating whether the set was performed and verified.
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
