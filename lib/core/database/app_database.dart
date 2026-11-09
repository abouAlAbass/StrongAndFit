import 'package:drift/drift.dart';
import '../enums/equipment_type.dart';
import '../enums/experience_level.dart';
import '../enums/muscle_group.dart';
import '../enums/set_type.dart';
import 'connection/connection.dart';
import 'daos/exercise_dao.dart';
import 'daos/profile_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/template_dao.dart';
import 'daos/workout_dao.dart';
import 'seeds/initial_exercises.dart';
import 'seeds/initial_templates.dart';
import 'tables/exercises_table.dart';
import 'tables/body_weight_logs_table.dart';
import 'tables/rest_settings_table.dart';
import 'tables/set_logs_table.dart';
import 'tables/template_exercises_table.dart';
import 'tables/templates_table.dart';
import 'tables/user_profiles_table.dart';
import 'tables/workout_exercises_table.dart';
import 'tables/workout_sessions_table.dart';

part 'app_database.g.dart';

/// Central Drift Database for the offline-first workout tracking application.
@DriftDatabase(
  tables: [
    Exercises,
    WorkoutSessions,
    WorkoutExercises,
    SetLogs,
    Templates,
    TemplateExercises,
    UserProfiles,
    RestSettings,
    BodyWeightLogs,
  ],
  daos: [ExerciseDao, WorkoutDao, TemplateDao, ProfileDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      // Initialize table structures
      await m.createAll();

      // 1. Seed foundational exercises
      await batch((b) {
        b.insertAll(
          exercises,
          kInitialExercises.map(
            (seed) => ExercisesCompanion.insert(
              slug: seed.slug,
              muscleGroup: seed.muscleGroup,
              equipment: seed.equipment,
              isCustom: const Value(false),
            ),
          ),
        );
      });

      // 2. Seed initial pre-designed workout routines
      await _seedDefaultTemplates(this);

      // 3. Seed initial user profile
      await _seedDefaultProfile(this);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(userProfiles);
        final templatesCount = await (select(templates).get());
        if (templatesCount.isEmpty) {
          await _seedDefaultTemplates(this);
        }
        await _seedDefaultProfile(this);
      }
      if (from < 3) {
        await m.addColumn(exercises, exercises.restSeconds);
        await m.createTable(restSettings);
      }
      if (from < 4) {
        await m.addColumn(workoutExercises, workoutExercises.supersetGroupId);
      }
      if (from < 5) {
        await m.createTable(bodyWeightLogs);
        final profiles = await select(userProfiles).get();
        if (profiles.isNotEmpty && profiles.first.weightKg != null) {
          await into(bodyWeightLogs).insert(
            BodyWeightLogsCompanion.insert(
              weightKg: profiles.first.weightKg!,
              loggedAt: Value(profiles.first.updatedAt),
              notes: const Value('Poids initial'),
            ),
          );
        }
      }
    },
    beforeOpen: (details) async {
      // Enforce foreign key constraints at SQLite level
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  static Future<void> _seedDefaultTemplates(AppDatabase db) async {
    final allExercises = await db.select(db.exercises).get();
    final exerciseMap = {for (final e in allExercises) e.slug: e.id};

    for (final seed in kInitialTemplates) {
      final templateId = await db
          .into(db.templates)
          .insert(
            TemplatesCompanion.insert(
              name: seed.name,
              notes: Value(seed.notes),
            ),
          );

      for (var i = 0; i < seed.exercises.length; i++) {
        final item = seed.exercises[i];
        final exId = exerciseMap[item.exerciseSlug];
        if (exId != null) {
          await db
              .into(db.templateExercises)
              .insert(
                TemplateExercisesCompanion.insert(
                  templateId: templateId,
                  exerciseId: exId,
                  orderIndex: Value(i),
                  targetSets: Value(item.targetSets),
                  notes: Value(item.notes),
                ),
              );
        }
      }
    }
  }

  static Future<void> _seedDefaultProfile(AppDatabase db) async {
    final existing = await db.select(db.userProfiles).get();
    if (existing.isEmpty) {
      final now = DateTime.now();
      await db
          .into(db.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              name: const Value('Athlete'),
              weightKg: const Value(75.0),
              heightCm: const Value(178.0),
              weeklyWorkoutGoal: const Value(4),
              experienceLevel: const Value(ExperienceLevel.intermediate),
              updatedAt: Value(now),
            ),
          );
      await db
          .into(db.bodyWeightLogs)
          .insert(
            BodyWeightLogsCompanion.insert(
              weightKg: 75.0,
              loggedAt: Value(now),
              notes: const Value('Poids initial'),
            ),
          );
    }
  }
}
