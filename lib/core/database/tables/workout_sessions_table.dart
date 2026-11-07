import 'package:drift/drift.dart';

/// Database table representing an individual workout session.
@DataClassName('WorkoutSession')
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Session title, e.g., 'Morning Workout', 'Leg Day', or custom user title.
  TextColumn get title => text().withLength(min: 1, max: 200)();

  /// Timestamp when the user initiated the session.
  DateTimeColumn get startedAt => dateTime()();

  /// Timestamp when the user completed the session. Null while session is active.
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Total workout duration in seconds.
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  /// Optional free-form notes on workout performance, recovery, etc.
  TextColumn get notes => text().nullable()();
}
