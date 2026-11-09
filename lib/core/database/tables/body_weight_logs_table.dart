import 'package:drift/drift.dart';

/// Database table storing historical body weight weigh-ins for trend analysis.
@DataClassName('BodyWeightLog')
class BodyWeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Weight in kilograms (e.g. 78.5 kg).
  RealColumn get weightKg => real()();

  /// Timestamp of the weigh-in.
  DateTimeColumn get loggedAt => dateTime().withDefault(currentDateAndTime)();

  /// Optional athlete note (e.g. "À jeun au réveil", "Après séance").
  TextColumn get notes => text().nullable()();
}
