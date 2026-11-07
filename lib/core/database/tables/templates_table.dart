import 'package:drift/drift.dart';

/// Database table representing routine templates (e.g., 'Push Day A', 'Upper Body').
@DataClassName('Template')
class Templates extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Routine template title.
  TextColumn get name => text().withLength(min: 1, max: 200)();

  /// Template description or focus notes.
  TextColumn get notes => text().nullable()();

  /// Timestamp when the template was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
