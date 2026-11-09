import 'package:drift/drift.dart';
import '../../enums/equipment_type.dart';
import '../../enums/muscle_group.dart';

/// Database table definition for Exercises.
///
/// Supports offline-first operation with built-in localization awareness:
/// - [slug] is a canonical key used to resolve localized names from ARB files.
/// - [customName] stores user-provided exercise titles when [isCustom] is true.
@DataClassName('Exercise')
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Canonical unique identifier (e.g., 'bench_press', 'squat', 'custom_12345').
  TextColumn get slug => text().withLength(min: 1, max: 100)();

  /// User-defined name for custom exercises. Null for default seeded exercises.
  TextColumn get customName => text().nullable().withLength(min: 1, max: 100)();

  /// Primary muscle group targeted by this exercise.
  TextColumn get muscleGroup => textEnum<MuscleGroup>()();

  /// Equipment required for execution.
  TextColumn get equipment => textEnum<EquipmentType>()();

  /// Flag indicating whether this was created by the user or seeded as default.
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// Optional per-exercise rest override (seconds) between sets.
  /// Null means "use the global between-sets default".
  IntColumn get restSeconds => integer().nullable()();

  /// Creation timestamp.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {slug},
  ];
}
