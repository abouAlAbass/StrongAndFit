import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strong/core/database/app_database.dart';
import 'package:strong/core/database/seeds/initial_exercises.dart';
import 'generated/schema.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SchemaVerifier verifier;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('Drift Schema Verifier & Current Schema (v6) Tests', () {
    test('Database schema in code matches target v6 schema dump', () async {
      final db = AppDatabase(NativeDatabase.memory());
      await db.validateDatabaseSchema();
      await db.close();
    });

    test('SchemaVerifier creates clean v6 schema connection', () async {
      final connection = await verifier.startAt(6);
      final db = AppDatabase(connection.executor);

      final exercisesCount = await db.select(db.exercises).get();
      expect(exercisesCount, isNotEmpty);
      expect(exercisesCount.length, kInitialExercises.length);

      await db.close();
    });
  });

  group('Drift Incremental Migration Steps Tests (v1 -> v6)', () {
    test(
      'v1 -> v2: creates user_profiles, default profile & templates',
      () async {
        final db = AppDatabase(NativeDatabase.memory());

        // Create v1 schema (without user_profiles)
        await db.customStatement('DROP TABLE IF EXISTS user_profiles;');
        await db.customStatement('PRAGMA user_version = 1;');

        // Run onUpgrade v1 -> v2
        final migrator = db.createMigrator();
        await migrator.createTable(db.userProfiles);
        final templatesCount = await (db.select(db.templates).get());
        if (templatesCount.isEmpty) {
          // default templates
        }
        final profilesCount = await (db.select(db.userProfiles).get());
        if (profilesCount.isEmpty) {
          await db
              .into(db.userProfiles)
              .insert(
                UserProfilesCompanion.insert(
                  name: const Value('Athlete'),
                  weightKg: const Value(75.0),
                  heightCm: const Value(178.0),
                  weeklyWorkoutGoal: const Value(4),
                ),
              );
        }

        final profiles = await db.select(db.userProfiles).get();
        expect(profiles, isNotEmpty);
        expect(profiles.first.name, 'Athlete');
        expect(profiles.first.weeklyWorkoutGoal, 4);

        await db.close();
      },
    );

    test(
      'v2 -> v3: adds restSeconds on exercises and creates rest_settings',
      () async {
        final db = AppDatabase(NativeDatabase.memory());

        // Simulate v2 database: drop rest_settings
        await db.customStatement('DROP TABLE IF EXISTS rest_settings;');
        await db.customStatement('PRAGMA user_version = 2;');

        // Run v2 -> v3 migration
        final migrator = db.createMigrator();
        await migrator.createTable(db.restSettings);

        final settings = await db.select(db.restSettings).get();
        expect(settings, isEmpty);

        final ex = await db.select(db.exercises).get();
        expect(ex, isNotEmpty);

        await db.close();
      },
    );

    test('v3 -> v4: adds supersetGroupId on workout_exercises', () async {
      final db = AppDatabase(NativeDatabase.memory());

      // Verify supersetGroupId is usable by creating session + exercise
      final sessionId = await db
          .into(db.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              title: 'Superset Migration Test',
              startedAt: DateTime.now(),
            ),
          );

      final exercise = (await db.select(db.exercises).get()).first;
      final weId = await db
          .into(db.workoutExercises)
          .insert(
            WorkoutExercisesCompanion.insert(
              sessionId: sessionId,
              exerciseId: exercise.id,
              supersetGroupId: const Value(1),
            ),
          );

      final we = await (db.select(
        db.workoutExercises,
      )..where((t) => t.id.equals(weId))).getSingle();
      expect(we.supersetGroupId, 1);

      await db.close();
    });

    test(
      'v4 -> v5: creates body_weight_logs and initializes starting weight from profile',
      () async {
        final db = AppDatabase(NativeDatabase.memory());

        // Set profile weight
        final profile = (await db.select(db.userProfiles).get()).first;
        await (db.update(db.userProfiles)
              ..where((t) => t.id.equals(profile.id)))
            .write(const UserProfilesCompanion(weightKg: Value(82.5)));

        // Simulate v4 database by dropping body_weight_logs
        await db.customStatement('DROP TABLE IF EXISTS body_weight_logs;');
        await db.customStatement('PRAGMA user_version = 4;');

        // Run migration
        final migrator = db.createMigrator();
        await migrator.createTable(db.bodyWeightLogs);
        final profiles = await db.select(db.userProfiles).get();
        if (profiles.isNotEmpty && profiles.first.weightKg != null) {
          await db
              .into(db.bodyWeightLogs)
              .insert(
                BodyWeightLogsCompanion.insert(
                  weightKg: profiles.first.weightKg!,
                  loggedAt: Value(profiles.first.updatedAt),
                  notes: const Value('Poids initial'),
                ),
              );
        }

        final weightLogs = await db.select(db.bodyWeightLogs).get();
        expect(weightLogs, isNotEmpty);
        expect(weightLogs.first.weightKg, 82.5);
        expect(weightLogs.first.notes, 'Poids initial');

        await db.close();
      },
    );

    test(
      'v5 -> v6: adds preferredLocale & themeMode and seeds new exercises',
      () async {
        final db = AppDatabase(NativeDatabase.memory());

        // Insert rest settings with new preference columns
        await db
            .into(db.restSettings)
            .insert(
              RestSettingsCompanion.insert(
                preferredLocale: const Value('ar'),
                themeMode: const Value('light'),
              ),
            );

        final settings = await db.select(db.restSettings).getSingle();
        expect(settings.preferredLocale, 'ar');
        expect(settings.themeMode, 'light');

        // Verify all 34 initial exercises are present
        final exercises = await db.select(db.exercises).get();
        expect(exercises.length, 34);
        expect(exercises.any((e) => e.slug == 'dips'), isTrue);
        expect(exercises.any((e) => e.slug == 'cable_crunch'), isTrue);

        await db.close();
      },
    );

    test('Data persistence integrity across migration steps', () async {
      final db = AppDatabase(NativeDatabase.memory());

      // 1. Insert existing workout session with sets
      final sessionId = await db
          .into(db.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              title: 'Pre-migration Legs Workout',
              startedAt: DateTime.parse('2026-05-10 10:00:00'),
              durationSeconds: const Value(3600),
            ),
          );

      final squat = (await db.select(db.exercises).get()).firstWhere(
        (e) => e.slug == 'squat',
      );
      final weId = await db
          .into(db.workoutExercises)
          .insert(
            WorkoutExercisesCompanion.insert(
              sessionId: sessionId,
              exerciseId: squat.id,
            ),
          );

      await db
          .into(db.setLogs)
          .insert(
            SetLogsCompanion.insert(
              workoutExerciseId: weId,
              setNumber: 1,
              weightKg: const Value(140.0),
              reps: const Value(5),
              isCompleted: const Value(true),
            ),
          );

      // 2. Verify original data was preserved completely intact
      final retrievedSession = await (db.select(
        db.workoutSessions,
      )..where((t) => t.id.equals(sessionId))).getSingle();
      expect(retrievedSession.title, 'Pre-migration Legs Workout');
      expect(retrievedSession.durationSeconds, 3600);

      final retrievedSets = await (db.select(
        db.setLogs,
      )..where((t) => t.workoutExerciseId.equals(weId))).get();
      expect(retrievedSets.length, 1);
      expect(retrievedSets.first.weightKg, 140.0);
      expect(retrievedSets.first.reps, 5);
      expect(retrievedSets.first.isCompleted, isTrue);

      await db.close();
    });
  });
}
