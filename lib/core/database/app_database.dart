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

/// Summary statistics returned after a successful JSON backup import transaction.
class BackupImportResult {
  final int customExercisesImported;
  final int sessionsImported;
  final int setsImported;
  final bool profileUpdated;

  const BackupImportResult({
    required this.customExercisesImported,
    required this.sessionsImported,
    required this.setsImported,
    required this.profileUpdated,
  });
}

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
  int get schemaVersion => 6;

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
      if (from < 6) {
        await m.addColumn(restSettings, restSettings.preferredLocale);
        await m.addColumn(restSettings, restSettings.themeMode);
        await _seedMissingDefaultExercises(this);
      }
    },
    beforeOpen: (details) async {
      // Enforce foreign key constraints at SQLite level
      await customStatement('PRAGMA foreign_keys = ON;');
      await _seedMissingDefaultExercises(this);
    },
  );

  /// Ensures any new exercises added to [kInitialExercises] in app updates
  /// are seamlessly inserted without duplicating existing slugs.
  static Future<void> _seedMissingDefaultExercises(AppDatabase db) async {
    final existing = await db.select(db.exercises).get();
    final existingSlugs = existing.map((e) => e.slug).toSet();

    final missing = kInitialExercises
        .where((seed) => !existingSlugs.contains(seed.slug))
        .toList();
    if (missing.isEmpty) return;

    await db.batch((b) {
      b.insertAll(
        db.exercises,
        missing.map(
          (seed) => ExercisesCompanion.insert(
            slug: seed.slug,
            muscleGroup: seed.muscleGroup,
            equipment: seed.equipment,
            isCustom: const Value(false),
          ),
        ),
      );
    });
  }

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

  /// Atomically validates and imports a structured JSON backup produced by [WorkoutExportService].
  ///
  /// When [overwrite] is `true`, existing workout sessions, sets, and weigh-ins are cleared
  /// prior to importing. When `false`, sessions and custom exercises are merged cleanly
  /// with full foreign-key remapping (`workout_sessions` -> `workout_exercises` -> `set_logs`).
  Future<BackupImportResult> importBackupTransaction(
    Map<String, dynamic> json, {
    bool overwrite = false,
  }) async {
    // 1. Validate schema & version
    if (!json.containsKey('sessions') && json['app'] != 'Strong Track') {
      throw const FormatException(
        'Invalid backup format: missing Strong Track signature or sessions array.',
      );
    }

    final version = json['version']?.toString() ?? '1.0.0';
    if (!version.startsWith('1.')) {
      throw FormatException('Unsupported backup schema version: $version');
    }

    if (json['sessions'] != null && json['sessions'] is! List) {
      throw const FormatException(
        'Invalid backup format: "sessions" must be a list.',
      );
    }
    if (json['workoutExercises'] != null && json['workoutExercises'] is! List) {
      throw const FormatException(
        'Invalid backup format: "workoutExercises" must be a list.',
      );
    }
    if (json['sets'] != null && json['sets'] is! List) {
      throw const FormatException(
        'Invalid backup format: "sets" must be a list.',
      );
    }

    return transaction(() async {
      int customExercisesImported = 0;
      int sessionsImported = 0;
      int setsImported = 0;
      bool profileUpdated = false;

      if (overwrite) {
        await delete(setLogs).go();
        await delete(workoutExercises).go();
        await delete(workoutSessions).go();
        await delete(bodyWeightLogs).go();
      }

      // 2. Restore Athlete Profile
      final profileMap = json['profile'];
      if (profileMap is Map<String, dynamic>) {
        final name = (profileMap['name'] as String?)?.trim();
        final weightKg = (profileMap['weightKg'] as num?)?.toDouble();
        final heightCm = (profileMap['heightCm'] as num?)?.toDouble();
        final weeklyGoal = (profileMap['weeklyWorkoutGoal'] as num?)?.toInt();
        final expStr = profileMap['experienceLevel']?.toString();
        final expLevel = expStr != null
            ? ExperienceLevel.values.firstWhere(
                (e) => e.name == expStr,
                orElse: () => ExperienceLevel.intermediate,
              )
            : ExperienceLevel.intermediate;

        final existingProfiles = await select(userProfiles).get();
        if (existingProfiles.isNotEmpty) {
          await (update(
            userProfiles,
          )..where((t) => t.id.equals(existingProfiles.first.id))).write(
            UserProfilesCompanion(
              name: name != null && name.isNotEmpty
                  ? Value(name)
                  : const Value.absent(),
              weightKg: Value(weightKg),
              heightCm: Value(heightCm),
              weeklyWorkoutGoal: weeklyGoal != null
                  ? Value(weeklyGoal)
                  : const Value.absent(),
              experienceLevel: Value(expLevel),
              updatedAt: Value(DateTime.now()),
            ),
          );
        } else {
          await into(userProfiles).insert(
            UserProfilesCompanion.insert(
              name: Value(name != null && name.isNotEmpty ? name : 'Athlete'),
              weightKg: Value(weightKg),
              heightCm: Value(heightCm),
              weeklyWorkoutGoal: Value(weeklyGoal ?? 4),
              experienceLevel: Value(expLevel),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }

        if (weightKg != null) {
          final existingLogs = await select(bodyWeightLogs).get();
          if (existingLogs.isEmpty) {
            await into(bodyWeightLogs).insert(
              BodyWeightLogsCompanion.insert(
                weightKg: weightKg,
                loggedAt: Value(DateTime.now()),
                notes: const Value('Import backup'),
              ),
            );
          }
        }
        profileUpdated = true;
      }

      // 3. Reconstruct Exercises & Foreign Key Map (oldExerciseId -> newExerciseId)
      final currentExercises = await select(exercises).get();
      final Map<int, int> exerciseIdMap = {
        for (final e in currentExercises) e.id: e.id,
      };
      final Map<String, int> slugToExerciseId = {
        for (final e in currentExercises) e.slug: e.id,
      };

      final customList = json['customExercises'] as List<dynamic>? ?? const [];
      for (final rawCe in customList) {
        if (rawCe is! Map<String, dynamic>) continue;
        final oldId = (rawCe['id'] as num?)?.toInt();
        final slug =
            (rawCe['slug'] as String?)?.trim() ??
            'custom_${DateTime.now().microsecondsSinceEpoch}';
        final customName = rawCe['customName'] as String?;
        final muscleStr = rawCe['muscleGroup']?.toString();
        final equipStr = rawCe['equipment']?.toString();

        final muscleGroup = MuscleGroup.values.firstWhere(
          (m) => m.name == muscleStr,
          orElse: () => MuscleGroup.chest,
        );
        final equipment = EquipmentType.values.firstWhere(
          (eq) => eq.name == equipStr,
          orElse: () => EquipmentType.barbell,
        );

        if (slugToExerciseId.containsKey(slug)) {
          final existingId = slugToExerciseId[slug]!;
          if (oldId != null) {
            exerciseIdMap[oldId] = existingId;
          }
        } else {
          final insertedId = await into(exercises).insert(
            ExercisesCompanion.insert(
              slug: slug,
              customName: Value(customName),
              muscleGroup: muscleGroup,
              equipment: equipment,
              isCustom: const Value(true),
            ),
          );
          slugToExerciseId[slug] = insertedId;
          if (oldId != null) {
            exerciseIdMap[oldId] = insertedId;
          }
          customExercisesImported++;
        }
      }

      final fallbackExerciseId = currentExercises.isNotEmpty
          ? currentExercises.first.id
          : (slugToExerciseId.values.isNotEmpty
                ? slugToExerciseId.values.first
                : null);

      // 4. Reconstruct WorkoutSessions (oldSessionId -> newSessionId)
      final Map<int, int> sessionIdMap = {};
      final sessionsList = json['sessions'] as List<dynamic>? ?? const [];
      for (final rawSession in sessionsList) {
        if (rawSession is! Map<String, dynamic>) continue;
        final oldSessionId = (rawSession['id'] as num?)?.toInt();
        final title = (rawSession['title'] as String?)?.trim() ?? 'Workout';
        final startedAt =
            DateTime.tryParse(rawSession['startedAt']?.toString() ?? '') ??
            DateTime.now();
        final durationSeconds =
            (rawSession['durationSeconds'] as num?)?.toInt() ?? 0;
        final completedAtRaw = rawSession['completedAt']?.toString();
        final completedAt = completedAtRaw != null && completedAtRaw.isNotEmpty
            ? DateTime.tryParse(completedAtRaw)
            : null;
        final notes = rawSession['notes'] as String?;

        final newSessionId = await into(workoutSessions).insert(
          WorkoutSessionsCompanion.insert(
            title: title,
            startedAt: startedAt,
            durationSeconds: Value(durationSeconds),
            completedAt: Value(completedAt),
            notes: Value(notes),
          ),
        );

        if (oldSessionId != null) {
          sessionIdMap[oldSessionId] = newSessionId;
        }
        sessionsImported++;
      }

      // 5. Reconstruct WorkoutExercises (oldWeId -> newWeId)
      final Map<int, int> workoutExerciseIdMap = {};
      final weList = json['workoutExercises'] as List<dynamic>? ?? const [];
      for (final rawWe in weList) {
        if (rawWe is! Map<String, dynamic>) continue;
        final oldWeId = (rawWe['id'] as num?)?.toInt();
        final oldSessionId = (rawWe['sessionId'] as num?)?.toInt();
        final oldExerciseId = (rawWe['exerciseId'] as num?)?.toInt();
        final exerciseSlug = rawWe['exerciseSlug'] as String?;
        final orderIndex = (rawWe['orderIndex'] as num?)?.toInt() ?? 0;
        final supersetGroupId = (rawWe['supersetGroupId'] as num?)?.toInt();

        final newSessionId = oldSessionId != null
            ? sessionIdMap[oldSessionId]
            : null;
        final newExerciseId =
            (exerciseSlug != null ? slugToExerciseId[exerciseSlug] : null) ??
            (oldExerciseId != null ? exerciseIdMap[oldExerciseId] : null) ??
            fallbackExerciseId;

        if (newSessionId == null || newExerciseId == null) continue;

        final newWeId = await into(workoutExercises).insert(
          WorkoutExercisesCompanion.insert(
            sessionId: newSessionId,
            exerciseId: newExerciseId,
            orderIndex: Value(orderIndex),
            supersetGroupId: Value(supersetGroupId),
          ),
        );

        if (oldWeId != null) {
          workoutExerciseIdMap[oldWeId] = newWeId;
        }
      }

      // 6. Reconstruct SetLogs
      final setsList = json['sets'] as List<dynamic>? ?? const [];
      for (final rawSet in setsList) {
        if (rawSet is! Map<String, dynamic>) continue;
        final oldWeId = (rawSet['workoutExerciseId'] as num?)?.toInt();
        final newWeId = oldWeId != null ? workoutExerciseIdMap[oldWeId] : null;
        if (newWeId == null) continue;

        final setNumber = (rawSet['setNumber'] as num?)?.toInt() ?? 1;
        final setTypeStr = rawSet['setType']?.toString() ?? 'normal';
        final setType = SetType.values.firstWhere(
          (t) => t.name == setTypeStr,
          orElse: () => SetType.normal,
        );
        final weightKg = (rawSet['weightKg'] as num?)?.toDouble();
        final reps = (rawSet['reps'] as num?)?.toInt();
        final rpe = (rawSet['rpe'] as num?)?.toDouble();
        final isCompleted = rawSet['isCompleted'] == true;

        await into(setLogs).insert(
          SetLogsCompanion.insert(
            workoutExerciseId: newWeId,
            setNumber: setNumber,
            setType: Value(setType),
            weightKg: Value(weightKg),
            reps: Value(reps),
            rpe: Value(rpe),
            isCompleted: Value(isCompleted),
          ),
        );
        setsImported++;
      }

      return BackupImportResult(
        customExercisesImported: customExercisesImported,
        sessionsImported: sessionsImported,
        setsImported: setsImported,
        profileUpdated: profileUpdated,
      );
    });
  }
}
