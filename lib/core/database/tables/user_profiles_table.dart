import 'package:drift/drift.dart';
import '../../enums/experience_level.dart';

/// Database table representing user body metrics, training goals, and experience level.
@DataClassName('UserProfile')
class UserProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Athlete's display name.
  TextColumn get name => text().withLength(min: 1, max: 100).withDefault(const Constant('Athlete'))();

  /// Body weight in kilograms.
  RealColumn get weightKg => real().nullable()();

  /// Height in centimeters.
  RealColumn get heightCm => real().nullable()();

  /// Target workout sessions per week (e.g., 3, 4, 5, 6).
  IntColumn get weeklyWorkoutGoal => integer().withDefault(const Constant(4))();

  /// Athlete proficiency level: beginner, intermediate, or advanced (pro).
  TextColumn get experienceLevel => textEnum<ExperienceLevel>().withDefault(
        Constant(ExperienceLevel.intermediate.name),
      )();

  /// Last updated timestamp.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
