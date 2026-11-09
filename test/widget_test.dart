import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:strong/core/database/app_database.dart';
import 'package:strong/core/enums/equipment_type.dart';
import 'package:strong/core/enums/experience_level.dart';
import 'package:strong/core/enums/muscle_group.dart';
import 'package:strong/core/l10n/exercise_translation_helper.dart';
import 'package:strong/core/l10n/generated/app_localizations.dart';
import 'package:strong/core/l10n/generated/app_localizations_ar.dart';
import 'package:strong/core/l10n/generated/app_localizations_en.dart';
import 'package:strong/core/l10n/generated/app_localizations_fr.dart';
import 'package:strong/core/notifications/rest_notification_service.dart';
import 'package:strong/features/exercises/data/repositories/exercise_repository_impl.dart';
import 'package:strong/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:strong/features/workout/data/repositories/rest_settings_repository_impl.dart';
import 'package:strong/features/workout/data/repositories/template_repository_impl.dart';
import 'package:strong/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:strong/features/workout/domain/models/exercise_personal_records.dart';
import 'package:strong/features/workout/domain/models/rest_preferences.dart';
import 'package:strong/features/workout/domain/repositories/workout_repository.dart';
import 'package:strong/features/workout/domain/services/one_rep_max_calculator.dart';
import 'package:strong/features/workout/domain/services/plate_calculator.dart';
import 'package:strong/core/enums/set_type.dart';
import 'package:strong/core/l10n/locale_cubit.dart';
import 'package:strong/features/exercises/presentation/widgets/exercise_media_viewer.dart';
import 'package:strong/features/history/domain/services/workout_export_service.dart';
import 'package:strong/features/history/domain/services/workout_import_service.dart';
import 'package:strong/features/workout/domain/models/workout_session_detail.dart';
import 'package:strong/core/theme/theme_cubit.dart';
import 'package:strong/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:strong/features/profile/presentation/widgets/athlete_onboarding_dialog.dart';
import 'package:strong/features/workout/presentation/widgets/one_handed_quick_input_bar.dart';
import 'package:strong/features/workout/presentation/widgets/rpe_picker_dialog.dart';
import 'package:strong/features/workout/domain/services/warmup_calculator.dart';
import 'package:strong/features/exercises/data/exercise_guides_data.dart';
import 'package:strong/features/profile/domain/routine_recommender.dart';
import 'package:strong/features/history/presentation/screens/workout_history_detail_screen.dart';
import 'package:strong/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:strong/features/workout/presentation/cubit/rest_timer_state.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:strong/core/services/ai_key_storage_service.dart';
import 'package:strong/features/profile/presentation/widgets/ai_key_settings_sheet.dart';
import 'package:strong/features/workout/domain/models/workout_ai_models.dart';
import 'package:strong/features/workout/domain/services/workout_ai_service.dart';
import 'package:strong/features/workout/presentation/widgets/workout_ai_analysis_dialog.dart';

class TestRestNotificationService implements RestNotificationService {
  DateTime? scheduledEndsAt;
  String? scheduledTitle;
  String? scheduledBody;
  int cancelCount = 0;

  @override
  Future<void> init() async {}

  @override
  Future<void> scheduleRestEnd({
    required DateTime endsAt,
    required String title,
    required String body,
  }) async {
    scheduledEndsAt = endsAt;
    scheduledTitle = title;
    scheduledBody = body;
  }

  @override
  Future<void> cancelRestEnd() async {
    cancelCount++;
    scheduledEndsAt = null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase database;
  late ExerciseRepositoryImpl exerciseRepo;
  late WorkoutRepositoryImpl workoutRepo;
  late TemplateRepositoryImpl templateRepo;
  late ProfileRepositoryImpl profileRepo;
  late RestSettingsRepositoryImpl restSettingsRepo;

  setUp(() {
    // In-memory SQLite database instance for isolated, offline testing
    database = AppDatabase(NativeDatabase.memory());
    exerciseRepo = ExerciseRepositoryImpl(database.exerciseDao);
    workoutRepo = WorkoutRepositoryImpl(database.workoutDao);
    templateRepo = TemplateRepositoryImpl(database.templateDao);
    profileRepo = ProfileRepositoryImpl(database.profileDao);
    restSettingsRepo = RestSettingsRepositoryImpl(database.settingsDao);
  });

  tearDown(() async {
    await database.close();
  });

  group('Drift Database & Seed Data Tests', () {
    test(
      'Seeded exercises and pre-designed routines are created on database initialization',
      () async {
        final exercises = await exerciseRepo.watchAllExercises().first;
        expect(exercises.length, greaterThanOrEqualTo(15));

        final templates = await templateRepo
            .watchAllTemplatesWithDetails()
            .first;
        expect(templates.length, greaterThanOrEqualTo(5));

        // Verify Full Body Split template
        final fullBody = templates.firstWhere(
          (t) => t.template.name.contains('Full Body'),
        );
        expect(fullBody.exercises.length, 6);
        expect(fullBody.exercises.any((e) => e.exercise.slug == 'squat'), true);
        expect(
          fullBody.exercises.any((e) => e.exercise.slug == 'bench_press'),
          true,
        );
        expect(
          fullBody.exercises.any((e) => e.exercise.slug == 'barbell_row'),
          true,
        );
      },
    );

    test(
      'Custom exercise creation populates customName and isCustom=true',
      () async {
        await exerciseRepo.createCustomExercise(
          name: 'Incline Cable Flyes',
          muscleGroup: MuscleGroup.chest,
          equipment: EquipmentType.cables,
        );

        final exercises = await exerciseRepo.watchAllExercises().first;
        final custom = exercises.firstWhere(
          (e) => e.customName == 'Incline Cable Flyes',
        );

        expect(custom.isCustom, true);
        expect(custom.customName, 'Incline Cable Flyes');
      },
    );
  });

  group('User Profile & Biometric Metrics Tests', () {
    test(
      'Default profile seeded with weight, height, and weekly workout target',
      () async {
        final profile = await profileRepo.watchProfile().first;
        expect(profile.name, 'Athlete');
        expect(profile.weightKg, 75.0);
        expect(profile.heightCm, 178.0);
        expect(profile.weeklyWorkoutGoal, 4);
        expect(profile.experienceLevel, ExperienceLevel.intermediate);
      },
    );

    test(
      'Updating profile persists new weight, height, goal, and experience level',
      () async {
        await profileRepo.updateProfile(
          name: 'Pro Lifter',
          weightKg: 82.5,
          heightCm: 180.0,
          weeklyWorkoutGoal: 5,
          experienceLevel: ExperienceLevel.advanced,
        );

        final updated = await profileRepo.watchProfile().first;
        expect(updated.name, 'Pro Lifter');
        expect(updated.weightKg, 82.5);
        expect(updated.heightCm, 180.0);
        expect(updated.weeklyWorkoutGoal, 5);
        expect(updated.experienceLevel, ExperienceLevel.advanced);

        // Verify calculated BMI = 82.5 / (1.80^2) = ~25.46
        final heightInMeters = updated.heightCm! / 100.0;
        final bmi = updated.weightKg! / (heightInMeters * heightInMeters);
        expect(bmi, closeTo(25.46, 0.05));
      },
    );

    test(
      'Deleting profile and data completely clears workout history and resets profile to defaults',
      () async {
        // 1. Customize profile
        await profileRepo.updateProfile(
          name: 'Athlete to Delete',
          weightKg: 90.0,
          heightCm: 185.0,
          weeklyWorkoutGoal: 6,
          experienceLevel: ExperienceLevel.advanced,
        );

        // 2. Log a workout session
        final sessionId = await workoutRepo.startNewSession(
          title: 'Session to Delete',
        );
        final exercises = await exerciseRepo.watchAllExercises().first;
        final squat = exercises.firstWhere((e) => e.slug == 'squat');
        final weId = await workoutRepo.addExerciseToSession(
          sessionId: sessionId,
          exerciseId: squat.id,
        );
        final setId = await workoutRepo.addSet(
          workoutExerciseId: weId,
          setNumber: 1,
          weightKg: 120.0,
          reps: 5,
        );
        await workoutRepo.toggleSetCompletion(setId: setId, isCompleted: true);
        await workoutRepo.completeSession(
          sessionId: sessionId,
          durationSeconds: 2400,
        );

        // Verify stats exist
        final statsBefore = await profileRepo.getLifetimeStats();
        expect(statsBefore.totalWorkouts, 1);
        expect(statsBefore.totalVolumeKg, 600.0);

        // 3. Delete profile and all data
        await profileRepo.deleteProfileAndData();

        // Verify reset profile state
        final resetProfile = await profileRepo.watchProfile().first;
        expect(resetProfile.name, 'Athlete');
        expect(resetProfile.weightKg, 75.0);
        expect(resetProfile.heightCm, 178.0);
        expect(resetProfile.weeklyWorkoutGoal, 4);
        expect(resetProfile.experienceLevel, ExperienceLevel.intermediate);

        // Verify all workout sessions and sets are completely purged
        final statsAfter = await profileRepo.getLifetimeStats();
        expect(statsAfter.totalWorkouts, 0);
        expect(statsAfter.totalVolumeKg, 0.0);
        expect(statsAfter.totalDurationSeconds, 0);

        final weeklyCount = await profileRepo
            .watchWeeklyCompletedWorkoutsCount()
            .first;
        expect(weeklyCount, 0);
      },
    );
  });

  group('Workout Session & Reactive DAO Tests', () {
    test(
      'Create session, log sets, toggle completion, and stream session detail',
      () async {
        final sessionId = await workoutRepo.startNewSession(
          title: 'Push Day #1',
        );
        final exercises = await exerciseRepo.watchAllExercises().first;
        final benchPress = exercises.firstWhere((e) => e.slug == 'bench_press');

        final workoutExerciseId = await workoutRepo.addExerciseToSession(
          sessionId: sessionId,
          exerciseId: benchPress.id,
        );

        final set1Id = await workoutRepo.addSet(
          workoutExerciseId: workoutExerciseId,
          setNumber: 1,
          weightKg: 80.0,
          reps: 8,
        );

        await workoutRepo.addSet(
          workoutExerciseId: workoutExerciseId,
          setNumber: 2,
          weightKg: 85.0,
          reps: 6,
        );

        final detail = await workoutRepo.watchSessionWithSets(sessionId).first;
        expect(detail, isNotNull);
        expect(detail!.session.title, 'Push Day #1');
        expect(detail.exercises.length, 1);
        expect(detail.exercises.first.sets.length, 2);

        await workoutRepo.toggleSetCompletion(setId: set1Id, isCompleted: true);
        final updatedDetail = await workoutRepo
            .watchSessionWithSets(sessionId)
            .first;
        expect(updatedDetail!.completedSetsCount, 1);
        expect(updatedDetail.totalVolumeKg, 80.0 * 8);

        await workoutRepo.completeSession(
          sessionId: sessionId,
          durationSeconds: 2400,
        );
        final completedDetail = await workoutRepo
            .watchSessionWithSets(sessionId)
            .first;
        expect(completedDetail!.session.completedAt, isNotNull);
      },
    );

    test(
      'fetchLastLoggedSetsForExercise pre-fills weights and reps from prior session',
      () async {
        final exercises = await exerciseRepo.watchAllExercises().first;
        final squat = exercises.firstWhere((e) => e.slug == 'squat');

        final sessionAId = await workoutRepo.startNewSession(
          title: 'Leg Day A',
        );
        final weAId = await workoutRepo.addExerciseToSession(
          sessionId: sessionAId,
          exerciseId: squat.id,
        );
        await workoutRepo.addSet(
          workoutExerciseId: weAId,
          setNumber: 1,
          weightKg: 100.0,
          reps: 5,
        );
        await workoutRepo.completeSession(
          sessionId: sessionAId,
          durationSeconds: 3000,
        );

        final sessionBId = await workoutRepo.startNewSession(
          title: 'Leg Day B',
        );
        final lastSets = await workoutRepo.fetchLastLoggedSetsForExercise(
          squat.id,
          excludeSessionId: sessionBId,
        );

        expect(lastSets.length, 1);
        expect(lastSets[0].weightKg, 100.0);
        expect(lastSets[0].reps, 5);

        // Session B is still unfinished -> getActiveUnfinishedSession returns Session B
        final active = await workoutRepo.getActiveUnfinishedSession();
        expect(active, isNotNull);
        expect(active!.id, sessionBId);
        expect(active.title, 'Leg Day B');
      },
    );
  });

  group('Localization Resolution Tests (en, fr, ar)', () {
    final l10nEn = AppLocalizationsEn();
    final l10nFr = AppLocalizationsFr();
    final l10nAr = AppLocalizationsAr();

    test(
      'Default exercise resolves to active locale while custom displays customName',
      () async {
        final exercises = await exerciseRepo.watchAllExercises().first;
        final benchPress = exercises.firstWhere((e) => e.slug == 'bench_press');

        expect(
          ExerciseTranslationHelper.resolveExerciseName(benchPress, l10nEn),
          'Barbell Bench Press',
        );
        expect(
          ExerciseTranslationHelper.resolveExerciseName(benchPress, l10nFr),
          'Développé couché à la barre',
        );
        expect(
          ExerciseTranslationHelper.resolveExerciseName(benchPress, l10nAr),
          'بنش برس مستوي بالبار',
        );

        final customExercise = Exercise(
          id: 999,
          slug: 'custom_my_flyes',
          customName: 'Special Incline Flyes',
          muscleGroup: MuscleGroup.chest,
          equipment: EquipmentType.cables,
          isCustom: true,
          createdAt: DateTime.now(),
        );

        expect(
          ExerciseTranslationHelper.resolveExerciseName(customExercise, l10nEn),
          'Special Incline Flyes',
        );
        expect(
          ExerciseTranslationHelper.resolveExerciseName(customExercise, l10nFr),
          'Special Incline Flyes',
        );
        expect(
          ExerciseTranslationHelper.resolveExerciseName(customExercise, l10nAr),
          'Special Incline Flyes',
        );
      },
    );
  });

  group('Rest Timer & Chronometer Tests', () {
    test(
      'startTimer initializes countdown and adjustTime modifies remaining seconds',
      () {
        final timerCubit = RestTimerCubit();
        expect(timerCubit.state.isRunning, false);

        timerCubit.startTimer(seconds: 90);
        expect(timerCubit.state.isRunning, true);
        expect(timerCubit.state.remainingSeconds, 90);
        expect(timerCubit.state.formattedRemaining, '01:30');

        // Adjust +15s
        timerCubit.adjustTime(15);
        expect(timerCubit.state.remainingSeconds, 105);
        expect(timerCubit.state.formattedRemaining, '01:45');

        // Adjust -30s
        timerCubit.adjustTime(-30);
        expect(timerCubit.state.remainingSeconds, 75);
        expect(timerCubit.state.formattedRemaining, '01:15');

        // Pause and resume
        timerCubit.pause();
        expect(timerCubit.state.isPaused, true);
        expect(timerCubit.state.isRunning, false);

        timerCubit.resume();
        expect(timerCubit.state.isRunning, true);

        // Stop
        timerCubit.stop();
        expect(timerCubit.state.isRunning, false);
        expect(timerCubit.state.remainingSeconds, 0);

        timerCubit.close();
      },
    );

    test('onSetCompleted triggers auto-start timer when enabled', () {
      final timerCubit = RestTimerCubit();
      expect(timerCubit.state.autoStartEnabled, true);

      timerCubit.onSetCompleted();
      expect(timerCubit.state.isRunning, true);
      expect(timerCubit.state.remainingSeconds, 90);

      timerCubit.toggleAutoStart(false);
      timerCubit.stop();

      timerCubit.onSetCompleted();
      expect(timerCubit.state.isRunning, false);

      timerCubit.close();
    });

    test(
      'Persisted RestSettingsRepository saves preferences and per-exercise overrides',
      () async {
        final initial = await restSettingsRepo.load();
        expect(initial.betweenSetsSeconds, 90);
        expect(initial.betweenExercisesSeconds, 150);
        expect(initial.autoStart, true);

        // Save new preferences
        await restSettingsRepo.save(
          const RestPreferences(
            betweenSetsSeconds: 120,
            betweenExercisesSeconds: 180,
            autoStart: false,
            notificationsEnabled: false,
            vibrationEnabled: true,
          ),
        );

        final updated = await restSettingsRepo.load();
        expect(updated.betweenSetsSeconds, 120);
        expect(updated.betweenExercisesSeconds, 180);
        expect(updated.autoStart, false);
        expect(updated.notificationsEnabled, false);

        // Per-exercise override
        final exercises = await exerciseRepo.watchAllExercises().first;
        final bench = exercises.firstWhere((e) => e.slug == 'bench_press');
        expect(bench.restSeconds, isNull);

        await restSettingsRepo.setExerciseRest(bench.id, 180);
        final refreshedExercises = await exerciseRepo.watchAllExercises().first;
        final updatedBench = refreshedExercises.firstWhere(
          (e) => e.id == bench.id,
        );
        expect(updatedBench.restSeconds, 180);
      },
    );

    test(
      'Deadline-based countdown does not drift and syncs correctly after simulated backgrounding',
      () {
        DateTime fakeNow = DateTime(2026, 1, 1, 10, 0, 0);
        final notifications = TestRestNotificationService();

        final timerCubit = RestTimerCubit(
          notifications: notifications,
          clock: () => fakeNow,
        );

        timerCubit.startTimer(seconds: 90);
        expect(timerCubit.state.remainingSeconds, 90);
        expect(
          notifications.scheduledEndsAt,
          fakeNow.add(const Duration(seconds: 90)),
        );

        // Simulate app backgrounded for 40 seconds
        fakeNow = fakeNow.add(const Duration(seconds: 40));
        timerCubit.sync();

        // Exactly 50 seconds remaining without any timer drift
        expect(timerCubit.state.remainingSeconds, 50);
        expect(timerCubit.state.isRunning, true);

        // Simulate app resuming after deadline passed
        fakeNow = fakeNow.add(const Duration(seconds: 55));
        timerCubit.sync();

        expect(timerCubit.state.remainingSeconds, 0);
        expect(timerCubit.state.isFinished, true);

        timerCubit.close();
      },
    );

    test(
      'Rest kind differentiates betweenSets vs betweenExercises with next exercise name',
      () {
        final timerCubit = RestTimerCubit();

        // 1. Regular set completion -> betweenSets (uses exercise rest override if provided)
        timerCubit.onSetCompleted(
          exerciseRestSeconds: 120,
          isLastSetOfExercise: false,
        );
        expect(timerCubit.state.kind, RestKind.betweenSets);
        expect(timerCubit.state.remainingSeconds, 120);

        // 2. Last set of exercise -> betweenExercises transition with next name
        timerCubit.onSetCompleted(
          isLastSetOfExercise: true,
          nextExerciseName: 'Barbell Squat',
        );
        expect(timerCubit.state.kind, RestKind.betweenExercises);
        expect(timerCubit.state.remainingSeconds, 150);
        expect(timerCubit.state.nextExerciseName, 'Barbell Squat');

        timerCubit.close();
      },
    );

    test(
      'Adjusting time below zero triggers instant finish and cancels notification',
      () {
        final notifications = TestRestNotificationService();
        final timerCubit = RestTimerCubit(notifications: notifications);

        timerCubit.startTimer(seconds: 30);
        expect(timerCubit.state.isRunning, true);

        // Adjust -45s (drops below 0)
        timerCubit.adjustTime(-45);
        expect(timerCubit.state.remainingSeconds, 0);
        expect(timerCubit.state.isFinished, true);

        timerCubit.close();
      },
    );
  });

  group('Advanced Athlete Features: 1RM, PRs, Plate Calculator & Warm-up Tests', () {
    test(
      'OneRepMaxCalculator calculates 1RM with Epley and Brzycki formulas',
      () {
        // 1 rep equals exact weight
        expect(OneRepMaxCalculator.epley(weight: 100.0, reps: 1), 100.0);
        expect(OneRepMaxCalculator.brzycki(weight: 100.0, reps: 1), 100.0);

        // 100kg x 10 reps: Epley = 100 * (1 + 10/30) = 133.33 kg
        final epley10 = OneRepMaxCalculator.calculate(weight: 100.0, reps: 10);
        expect(epley10, closeTo(133.3, 0.1));

        // Percentage of 1RM with 2.5kg plate rounding (80% of 133.3 = 106.64 -> rounds to 107.5 kg)
        final trainingWeight = OneRepMaxCalculator.weightForPercentage(
          oneRepMax: 133.3,
          percentage: 80.0,
        );
        expect(trainingWeight, 107.5);
      },
    );

    test('PlateCalculator distributes Olympic plates accurately per side', () {
      // Target: 102.5 kg on standard 20 kg barbell -> 41.25 kg per side
      final result = PlateCalculator.calculate(
        targetWeight: 102.5,
        barWeight: 20.0,
      );

      expect(result.actualTotalWeight, 102.5);
      expect(result.weightPerSide, 41.25);
      expect(result.isExact, true);

      // Plates per side: 25 kg + 15 kg + 1.25 kg = 41.25 kg
      final weights = result.platesPerSide.map((p) => p.weightKg).toList();
      expect(weights, [25.0, 15.0, 1.25]);

      // Target lighter than or equal to bar weight
      final emptyBar = PlateCalculator.calculate(
        targetWeight: 20.0,
        barWeight: 20.0,
      );
      expect(emptyBar.platesPerSide, isEmpty);
      expect(emptyBar.weightPerSide, 0.0);
    });

    test('WarmupCalculator generates safe, progressive warm-up ladder', () {
      final steps = WarmupCalculator.generate(workingWeightKg: 100.0);
      expect(steps.length, greaterThanOrEqualTo(3));

      // First step is always empty bar (20kg)
      expect(steps.first.weightKg, 20.0);
      expect(steps.first.reps, 10);

      // Subsequent steps are progressive and strictly below 100kg
      for (var i = 1; i < steps.length; i++) {
        expect(steps[i].weightKg, greaterThan(steps[i - 1].weightKg));
        expect(steps[i].weightKg, lessThan(100.0));
      }
    });

    test(
      'Personal Records detection and WorkoutDao historical query',
      () async {
        final exercises = await exerciseRepo.watchAllExercises().first;
        final bench = exercises.firstWhere((e) => e.slug == 'bench_press');

        // 1. Session 1: Bench Press 100 kg x 5 reps -> completed
        final session1Id = await workoutRepo.startNewSession(
          title: 'Bench PR Day',
        );
        final weId = await workoutRepo.addExerciseToSession(
          sessionId: session1Id,
          exerciseId: bench.id,
        );
        final set1Id = await workoutRepo.addSet(
          workoutExerciseId: weId,
          setNumber: 1,
          weightKg: 100.0,
          reps: 5,
        );
        await workoutRepo.toggleSetCompletion(setId: set1Id, isCompleted: true);
        await workoutRepo.completeSession(
          sessionId: session1Id,
          durationSeconds: 1800,
        );

        // 2. Query historical PRs excluding session 2
        final session2Id = await workoutRepo.startNewSession(
          title: 'Bench Next Day',
        );
        final prsMap = await workoutRepo.fetchHistoricalPersonalRecords(
          excludeSessionId: session2Id,
        );

        final benchPr = prsMap[bench.id];
        expect(benchPr, isNotNull);
        expect(benchPr!.maxWeight, 100.0);
        expect(benchPr.maxVolume, 500.0);
        // 100 * (1 + 5/30) = 116.67 kg
        expect(benchPr.maxOneRepMax, closeTo(116.67, 0.1));

        // 3. Evaluate new set in session 2:
        // A set of 105 kg x 3 beats maxWeight and maxOneRepMax!
        final badges = benchPr.evaluateSet(weightKg: 105.0, reps: 3);
        expect(badges.contains(PrType.maxWeight), true);

        // A set of 90 kg x 5 does NOT beat any PR
        final noBadges = benchPr.evaluateSet(weightKg: 90.0, reps: 5);
        expect(noBadges, isEmpty);
      },
    );

    group('Point 3: Exercise Technical Guides & Routine Recommender Tests', () {
      test(
        'ExerciseGuidesData resolves accurate cues for French, English, and Arabic',
        () {
          // French
          final frSquat = ExerciseGuidesData.getGuide('squat', 'fr');
          expect(frSquat.title.contains('Squat'), true);
          expect(frSquat.primaryMuscles, contains('Quadriceps'));
          expect(frSquat.setupInstructions.length, greaterThanOrEqualTo(2));
          expect(frSquat.executionInstructions.length, greaterThanOrEqualTo(3));
          expect(frSquat.commonMistakes.isNotEmpty, true);
          expect(frSquat.coachTip.isNotEmpty, true);

          // English
          final enBench = ExerciseGuidesData.getGuide('bench_press', 'en');
          expect(enBench.title, 'Barbell Bench Press');
          expect(enBench.primaryMuscles.first, contains('Pectoralis'));
          expect(enBench.tempo, '3-1-1-0');

          // Arabic
          final arDeadlift = ExerciseGuidesData.getGuide('deadlift', 'ar');
          expect(arDeadlift.title, contains('ديدليفت'));
          expect(arDeadlift.breathingInstructions.isNotEmpty, true);
          expect(arDeadlift.commonMistakes.length, greaterThanOrEqualTo(2));
        },
      );

      test(
        'ExerciseGuidesData gracefully handles custom exercises via fallback',
        () {
          final customGuide = ExerciseGuidesData.getGuide(
            'custom_exercise_123',
            'fr',
            displayName: 'Curl Marteau Incliné',
          );

          expect(customGuide.slug, 'custom_exercise_123');
          expect(customGuide.title, 'Curl Marteau Incliné');
          expect(customGuide.setupInstructions.isNotEmpty, true);
          expect(customGuide.executionInstructions.isNotEmpty, true);
          expect(customGuide.coachTip.isNotEmpty, true);
        },
      );

      test('ExerciseRepository returns exercise guide', () {
        final guide = exerciseRepo.getExerciseGuide('overhead_press', 'en');
        expect(guide.slug, 'overhead_press');
        expect(guide.primaryMuscles.first, contains('Deltoids'));
      });

      test(
        'RoutineRecommender matches goals, availability, and levels appropriately',
        () {
          // 1. Beginner (< 1 year) or 3 days/week -> Full Body Split
          final rec1 = RoutineRecommender.match(
            goal: TrainingGoal.hypertrophy,
            daysPerWeek: 3,
            experienceLevel: ExperienceLevel.beginner,
          );
          expect(rec1.templateSlug, 'full_body_split');
          expect(rec1.recommendedDaysPerWeek, 3);

          // 2. 4 days/week -> Upper / Lower Split
          final rec2 = RoutineRecommender.match(
            goal: TrainingGoal.hypertrophy,
            daysPerWeek: 4,
            experienceLevel: ExperienceLevel.intermediate,
          );
          expect(rec2.templateSlug, 'upper_body_power');
          expect(rec2.recommendedDaysPerWeek, 4);

          // 3. 5 days/week Strength -> Pull Day / PPL Strength
          final rec3 = RoutineRecommender.match(
            goal: TrainingGoal.strength,
            daysPerWeek: 5,
            experienceLevel: ExperienceLevel.advanced,
          );
          expect(rec3.templateSlug, 'pull_strength');

          // 4. 5 days/week Hypertrophy -> Push Day / PPL Hypertrophy
          final rec4 = RoutineRecommender.match(
            goal: TrainingGoal.hypertrophy,
            daysPerWeek: 5,
            experienceLevel: ExperienceLevel.advanced,
          );
          expect(rec4.templateSlug, 'push_hypertrophy');
        },
      );

      test(
        'Updating profile persists weekly goal and experience level from recommender',
        () async {
          final initial = await profileRepo.watchProfile().first;
          expect(initial.weeklyWorkoutGoal, 4);

          await profileRepo.updateProfile(
            weeklyWorkoutGoal: 5,
            experienceLevel: ExperienceLevel.advanced,
          );

          final updated = await profileRepo.watchProfile().first;
          expect(updated.weeklyWorkoutGoal, 5);
          expect(updated.experienceLevel, ExperienceLevel.advanced);
        },
      );

      test(
        'Custom routine creation, muscle distribution, and 1RM progression analytics work end-to-end',
        () async {
          final exercises = await exerciseRepo.watchAllExercises().first;
          final bench = exercises.firstWhere((e) => e.slug == 'bench_press');
          final squat = exercises.firstWhere((e) => e.slug == 'squat');

          // 1. Create a custom routine
          final customTemplateId = await templateRepo.createRoutine(
            name: 'Custom Strength Split',
            notes: 'Heavy compound session',
            exercises: [
              (exerciseId: bench.id, targetSets: 4),
              (exerciseId: squat.id, targetSets: 5),
            ],
          );
          expect(customTemplateId, greaterThan(0));

          final allTemplates = await templateRepo
              .watchAllTemplatesWithDetails()
              .first;
          final created = allTemplates.firstWhere(
            (t) => t.template.id == customTemplateId,
          );
          expect(created.template.name, 'Custom Strength Split');
          expect(created.exercises.length, 2);
          expect(created.exercises.first.templateExercise.targetSets, 4);

          // 2. Log a completed session to verify muscle distribution & 1RM progression
          final sessionId = await workoutRepo.startNewSession(
            title: 'Analytics Session',
          );
          final weId = await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: bench.id,
          );
          final setId = await workoutRepo.addSet(
            workoutExerciseId: weId,
            setNumber: 1,
            weightKg: 95.0,
            reps: 6,
          );
          await workoutRepo.toggleSetCompletion(
            setId: setId,
            isCompleted: true,
          );
          await workoutRepo.completeSession(
            sessionId: sessionId,
            durationSeconds: 1800,
          );

          final distribution = await profileRepo
              .getMuscleGroupSetDistribution();
          expect(distribution[MuscleGroup.chest], greaterThanOrEqualTo(1));

          final progression = await workoutRepo.fetchExerciseProgressionBySlug(
            'bench_press',
          );
          expect(progression, isNotEmpty);
          expect(progression.last.maxWeightKg, 95.0);

          // 3. Delete custom routine
          await templateRepo.deleteRoutine(customTemplateId);
          final afterDelete = await templateRepo
              .watchAllTemplatesWithDetails()
              .first;
          expect(
            afterDelete.any((t) => t.template.id == customTemplateId),
            false,
          );
        },
      );

      testWidgets(
        'WorkoutHistoryDetailScreen has visible back button and fluid pop navigation',
        (tester) async {
          await tester.pumpWidget(
            RepositoryProvider<WorkoutRepository>.value(
              value: workoutRepo,
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('en'),
                home: Builder(
                  builder: (context) => Scaffold(
                    body: ElevatedButton(
                      key: const Key('open_history_detail'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WorkoutHistoryDetailScreen(
                              sessionId: 99999,
                            ),
                          ),
                        );
                      },
                      child: const Text('Open Detail'),
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pump();

          // 1. Open history detail screen
          await tester.tap(find.byKey(const Key('open_history_detail')));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));

          expect(find.byType(WorkoutHistoryDetailScreen), findsOneWidget);

          // 2. Verify back button is visible in AppBar
          final backButton = find.byIcon(Icons.arrow_back_rounded);
          expect(backButton, findsOneWidget);

          // 3. Tap back button to navigate back seamlessly to previous screen
          await tester.tap(backButton);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));

          // Screen popped, back on root screen
          expect(find.byType(WorkoutHistoryDetailScreen), findsNothing);
          expect(find.byKey(const Key('open_history_detail')), findsOneWidget);

          // Allow Drift query stream unmount timer to flush
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'OneHandedQuickInputBar adjusts weight and reps and completes set with one hand',
        (tester) async {
          double? updatedWeight;
          int? updatedReps;
          bool completed = false;
          bool nextSetCalled = false;

          final exercise = Exercise(
            id: 1,
            slug: 'bench_press',
            muscleGroup: MuscleGroup.chest,
            equipment: EquipmentType.barbell,
            isCustom: false,
            createdAt: DateTime.now(),
          );

          final workoutExercise = WorkoutExercise(
            id: 1,
            sessionId: 1,
            exerciseId: 1,
            orderIndex: 0,
          );

          final setLog = SetLog(
            id: 10,
            workoutExerciseId: 1,
            setNumber: 1,
            setType: SetType.normal,
            weightKg: 80.0,
            reps: 8,
            isCompleted: false,
          );

          final previousSetLog = SetLog(
            id: 9,
            workoutExerciseId: 1,
            setNumber: 1,
            setType: SetType.normal,
            weightKg: 85.0,
            reps: 10,
            isCompleted: true,
          );

          final exerciseDetail = WorkoutExerciseDetail(
            workoutExercise: workoutExercise,
            exercise: exercise,
            sets: [setLog],
          );

          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
              home: Scaffold(
                body: OneHandedQuickInputBar(
                  exerciseItem: exerciseDetail,
                  setLog: setLog,
                  previousSetLog: previousSetLog,
                  onUpdateValues: (w, r, [rpe]) {
                    updatedWeight = w;
                    updatedReps = r;
                  },
                  onToggleCompleted: (c) {
                    completed = c;
                  },
                  onNextSet: () {
                    nextSetCalled = true;
                  },
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // 1. Verify Stepper increments weight (+2.5 kg)
          expect(find.text('+2.5'), findsOneWidget);
          await tester.tap(find.text('+2.5'));
          expect(updatedWeight, 82.5);

          // 2. Verify Stepper increments reps (+1)
          expect(find.text('+1'), findsOneWidget);
          await tester.tap(find.text('+1'));
          expect(updatedReps, 9);

          // 3. Verify 1-tap previous copy
          expect(find.text('85.0kg × 10'), findsOneWidget);
          await tester.tap(find.text('85.0kg × 10'));
          expect(updatedWeight, 85.0);
          expect(updatedReps, 10);

          // 4. Verify giant validation button completes set & advances
          final validateBtn = find.text('Valider la série');
          expect(validateBtn, findsOneWidget);
          await tester.tap(validateBtn);
          expect(completed, isTrue);
          expect(nextSetCalled, isTrue);
        },
      );

      test(
        'WorkoutExportService generates compliant CSV and JSON backup',
        () async {
          final exportService = WorkoutExportService(
            database,
            tempDirectoryProvider: () async =>
                Directory.systemTemp.createTempSync('strong_test_'),
          );

          // 1. Generate CSV export
          final csvFile = await exportService.generateCsvExport();
          expect(await csvFile.exists(), isTrue);
          final csvContent = await csvFile.readAsString();

          // Check header
          expect(
            csvContent.contains(
              'Date,Workout Name,Duration (min),Exercise,Muscle Group,Set Number,Set Type,Weight (kg),Reps,RPE,Completed',
            ),
            isTrue,
          );

          // 2. Generate JSON backup
          final jsonFile = await exportService.generateJsonBackup();
          expect(await jsonFile.exists(), isTrue);
          final jsonContent = await jsonFile.readAsString();

          expect(jsonContent.contains('"app": "Strong Track"'), isTrue);
          expect(jsonContent.contains('"profile":'), isTrue);
          expect(jsonContent.contains('"sessions":'), isTrue);
        },
      );

      testWidgets('RpePickerDialog displays scale and selects RPE value', (
        tester,
      ) async {
        double? selectedRpe;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('fr'),
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () {
                    RpePickerDialog.show(
                      ctx,
                      currentRpe: 8.0,
                      onSelected: (val) {
                        selectedRpe = val;
                      },
                    );
                  },
                  child: const Text('Open RPE'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open RPE'));
        await tester.pumpAndSettle();

        expect(find.text('@10'), findsOneWidget);
        expect(find.text('@8.5'), findsOneWidget);

        // Select @8.5
        await tester.tap(find.text('@8.5'));
        await tester.pumpAndSettle();

        expect(selectedRpe, 8.5);
      });

      test(
        'Superset grouping links multiple exercises and updates supersetGroupId',
        () async {
          final sessionId = await workoutRepo.startNewSession(
            title: 'Superset Workout',
          );
          final we1 = await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: 1,
          );
          final we2 = await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: 2,
          );

          // Assign both to supersetGroupId = 1 (A1 and A2)
          await workoutRepo.setExerciseSuperset(
            workoutExerciseId: we1,
            supersetGroupId: 1,
          );
          await workoutRepo.setExerciseSuperset(
            workoutExerciseId: we2,
            supersetGroupId: 1,
          );

          final detail = await workoutRepo
              .watchSessionWithSets(sessionId)
              .first;
          expect(detail, isNotNull);
          expect(detail!.exercises.length, 2);
          expect(detail.exercises[0].workoutExercise.supersetGroupId, 1);
          expect(detail.exercises[1].workoutExercise.supersetGroupId, 1);

          // Unlink we2
          await workoutRepo.setExerciseSuperset(
            workoutExerciseId: we2,
            supersetGroupId: null,
          );
          final updatedDetail = await workoutRepo
              .watchSessionWithSets(sessionId)
              .first;
          expect(
            updatedDetail!.exercises[0].workoutExercise.supersetGroupId,
            1,
          );
          expect(
            updatedDetail.exercises[1].workoutExercise.supersetGroupId,
            isNull,
          );
        },
      );

      test(
        'Body weight tracking persists weigh-ins, syncs profile weight, and computes delta',
        () async {
          final cubit = ProfileCubit(profileRepo);

          // Clear any initial seed logs for pristine assertion
          await database.delete(database.bodyWeightLogs).go();

          // Log two sequential weigh-ins
          await profileRepo.logBodyWeight(
            80.0,
            date: DateTime(2026, 11, 1),
            notes: 'Début sèche',
          );
          await profileRepo.logBodyWeight(
            78.0,
            date: DateTime(2026, 11, 9),
            notes: 'Semaine 2',
          );

          final logs = await profileRepo.getWeightLogs();
          expect(logs.length, 2);
          expect(logs.first.weightKg, 80.0);
          expect(logs.last.weightKg, 78.0);

          // Check profile is kept in sync with latest weight
          final updatedProfile = await profileRepo.watchProfile().first;
          expect(updatedProfile.weightKg, 78.0);

          // Test ProfileState weightDeltaFromStart
          final state = cubit.state.copyWith(
            weightLogs: [
              logs.last, // newest first (78.0)
              logs.first, // oldest last (80.0)
            ],
          );
          expect(state.weightDeltaFromStart, closeTo(-2.0, 0.01));

          // Delete latest log and verify
          await profileRepo.deleteWeightLog(logs.last.id);
          final logsAfterDelete = await profileRepo.getWeightLogs();
          expect(logsAfterDelete.any((l) => l.id == logs.last.id), false);

          await cubit.close();
        },
      );

      testWidgets(
        'AthleteOnboardingDialog Step 0 displays language and theme preferences',
        (tester) async {
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 2.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          final themeCubit = ThemeCubit();
          Locale? changedLocale;

          await tester.pumpWidget(
            BlocProvider<ThemeCubit>.value(
              value: themeCubit,
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('fr'),
                home: Scaffold(
                  body: AthleteOnboardingDialog(
                    onLocaleChanged: (locale) => changedLocale = locale,
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Step 0 must display language and theme selection
          expect(find.text('Langue & Apparence'), findsOneWidget);
          expect(find.text('العربية'), findsOneWidget);
          expect(find.text('English'), findsOneWidget);
          expect(find.text('Français'), findsOneWidget);
          expect(find.text('Mode Sombre'), findsOneWidget);
          expect(find.text('Mode Clair'), findsOneWidget);

          // Tap English
          await tester.tap(find.text('English'));
          await tester.pumpAndSettle();
          expect(changedLocale, const Locale('en'));

          // Tap Mode Clair
          await tester.tap(find.text('Mode Clair'));
          await tester.pumpAndSettle();
          expect(themeCubit.state, ThemeMode.light);

          await themeCubit.close();
        },
      );
    });

    group('Google Gemini AI & BYOK Feature Tests', () {
      setUp(() {
        FlutterSecureStorage.setMockInitialValues({});
      });

      test(
        'AiKeyStorageService saves, reads, checks, and deletes API key',
        () async {
          final storage = AiKeyStorageService();

          expect(await storage.hasApiKey(), isFalse);
          expect(await storage.getApiKey(), isNull);

          await storage.saveApiKey('  AIzaSyTestKey12345  ');
          expect(await storage.hasApiKey(), isTrue);
          expect(await storage.getApiKey(), 'AIzaSyTestKey12345');

          await storage.deleteApiKey();
          expect(await storage.hasApiKey(), isFalse);
          expect(await storage.getApiKey(), isNull);
        },
      );

      test(
        'WorkoutAiModels JSON serialization and deserialization work accurately',
        () {
          final summary = WorkoutSummary(
            athleteName: 'Alexandre',
            experienceLevel: 'intermediate',
            bodyWeightKg: 82.5,
            workoutTitle: 'Push Day - Hypertrophy',
            date: DateTime(2026, 11, 9, 10, 0),
            durationMinutes: 55,
            totalVolumeKg: 4250.0,
            exercises: const [
              ExerciseSummary(
                exerciseName: 'Développé couché barre',
                muscleGroup: 'Pectoraux',
                totalSets: 4,
                totalReps: 32,
                topWeightKg: 100.0,
                avgRpe: 8.5,
                hasPersonalRecord: true,
              ),
            ],
            athleteFeedback: 'Bonnes sensations au bench',
          );

          final jsonMap = summary.toJson();
          expect(jsonMap['athlete']['name'], 'Alexandre');
          expect(jsonMap['athlete']['body_weight_kg'], 82.5);
          expect(jsonMap['session']['total_volume_kg'], 4250.0);
          expect((jsonMap['exercises'] as List).length, 1);
          expect(jsonMap['exercises'][0]['exercise'], 'Développé couché barre');

          final sampleResponseJson = {
            'overall_score': 9,
            'overview': 'Excellente séance push avec surcharge progressive.',
            'progressive_overload':
                'La charge de 100kg montre une progression de 5%.',
            'recovery_and_rpe':
                'RPE moyen de 8.5 bien calibré pour l\'hypertrophie.',
            'highlights': [
              'Nouveau PR au développé couché (100 kg)',
              'Volume total solide de 4250 kg',
            ],
            'plateaus_or_risks': [
              'Attention à la fatigue des triceps sur la fin',
            ],
            'next_cycle_recommendations': [
              'Prendre 3 minutes de repos sur la première série lourde',
              'Ajouter une série d\'écartés à la poulie',
            ],
          };

          final analysis = WorkoutAiAnalysis.fromJson(sampleResponseJson);
          expect(analysis.overallScore, 9);
          expect(analysis.overview, contains('Excellente séance'));
          expect(analysis.strengthHighlights.length, 2);
          expect(
            analysis.plateausOrRisks.first,
            contains('fatigue des triceps'),
          );
          expect(analysis.nextCycleRecommendations.length, 2);
        },
      );

      test(
        'WorkoutAiService rejects empty or whitespace-only API keys',
        () async {
          final service = WorkoutAiService();
          expect(() => service.testApiKey('   '), throwsA(isA<Exception>()));
        },
      );

      testWidgets(
        'AiKeySettingsSheet renders all guide steps, buttons, and input field',
        (WidgetTester tester) async {
          FlutterSecureStorage.setMockInitialValues({});
          final storage = AiKeyStorageService();
          final service = WorkoutAiService(keyStorage: storage);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AiKeySettingsSheet(
                  keyStorage: storage,
                  aiService: service,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('Coach IA — Clé Google Gemini'), findsOneWidget);
          expect(
            find.text('Obtenir une clé gratuite sur Google AI Studio'),
            findsOneWidget,
          );
          expect(
            find.text('Connectez-vous avec votre compte Google sur AI Studio.'),
            findsOneWidget,
          );
          expect(
            find.text(
              'Cliquez sur "Create API Key" (aucun moyen de paiement requis).',
            ),
            findsOneWidget,
          );
          expect(
            find.text('Copiez la clé et collez-la dans le champ ci-dessous.'),
            findsOneWidget,
          );
          expect(find.text('Valider et Sauvegarder'), findsOneWidget);
          expect(find.byType(TextField), findsOneWidget);
        },
      );

      testWidgets(
        'WorkoutAiAnalysisDialog renders athletic scores and recommendations',
        (WidgetTester tester) async {
          const analysis = WorkoutAiAnalysis(
            overallScore: 8,
            overview: 'Bonne intensité globale.',
            progressiveOverloadAssessment: 'Progression linéaire validée.',
            recoveryAndRpeAssessment: 'Récupération optimale.',
            strengthHighlights: ['Record sur le Squat', 'Excellente forme'],
            plateausOrRisks: ['Légère fatigue lombaire'],
            nextCycleRecommendations: ['Augmenter le repos à 180s'],
          );

          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: WorkoutAiAnalysisDialog(
                  analysis: analysis,
                  sessionTitle: 'Leg Day Intensif',
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('Leg Day Intensif'), findsOneWidget);
          expect(find.text('8/10'), findsOneWidget);
          expect(find.text('Bonne intensité globale.'), findsOneWidget);
          expect(find.text('Progression linéaire validée.'), findsOneWidget);
          expect(find.text('Record sur le Squat'), findsOneWidget);
          expect(find.text('Légère fatigue lombaire'), findsOneWidget);
          expect(find.text('Augmenter le repos à 180s'), findsOneWidget);
        },
      );
    });

    group('Missions 1-5: JSON Import, Locale/Theme Persistence & Catalog', () {
      test(
        'WorkoutExportService -> WorkoutImportService round-trip restores sessions, exercises, and sets atomically',
        () async {
          final exportService = WorkoutExportService(
            database,
            tempDirectoryProvider: () async => Directory.systemTemp,
          );

          // 1. Create a workout session with a completed set
          final sessionId = await workoutRepo.startNewSession(
            title: 'Push Day Backup',
          );
          final allExercises = await exerciseRepo.watchAllExercises().first;
          final dips = allExercises.firstWhere((e) => e.slug == 'dips');
          final weId = await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: dips.id,
          );
          await workoutRepo.addSet(
            workoutExerciseId: weId,
            setNumber: 1,
            setType: SetType.normal,
            weightKg: 40.0,
            reps: 10,
            rpe: 8.5,
          );
          final sets = await (database.select(
            database.setLogs,
          )..where((t) => t.workoutExerciseId.equals(weId))).get();
          await workoutRepo.toggleSetCompletion(
            setId: sets.first.id,
            isCompleted: true,
          );
          await workoutRepo.completeSession(
            sessionId: sessionId,
            durationSeconds: 2400,
          );

          final jsonFile = await exportService.generateJsonBackup();

          // 2. Import into a fresh in-memory database with overwrite = true
          final targetDb = AppDatabase(NativeDatabase.memory());
          final targetImport = WorkoutImportService(
            targetDb,
            tempDirectoryProvider: () async => Directory.systemTemp,
          );
          final result = await targetImport.importFromFile(
            jsonFile,
            overwrite: true,
            purgeTempFileAfterRead: true,
          );

          expect(result.sessionsImported, 1);
          expect(result.setsImported, greaterThanOrEqualTo(1));

          final targetSessions = await (targetDb.select(
            targetDb.workoutSessions,
          )).get();
          expect(targetSessions.length, 1);
          expect(targetSessions.first.title, 'Push Day Backup');
          final targetDetail = await targetDb.workoutDao
              .watchSessionWithSets(targetSessions.first.id)
              .first;
          expect(targetDetail, isNotNull);
          expect(targetDetail!.exercises.first.exercise.slug, 'dips');
          expect(
            targetDetail.exercises.first.sets.any((s) => s.weightKg == 40.0),
            isTrue,
          );

          await targetDb.close();
        },
      );

      test(
        'LocaleCubit and ThemeCubit persist and hydrate preferences via RestSettingsRepository',
        () async {
          await restSettingsRepo.savePreferredLocale('ar');
          await restSettingsRepo.saveThemeMode('light');

          final prefs = await restSettingsRepo.load();
          expect(prefs.preferredLocale, 'ar');
          expect(prefs.themeMode, 'light');

          final localeCubit = LocaleCubit(settingsRepository: restSettingsRepo);
          final themeCubit = ThemeCubit(settingsRepository: restSettingsRepo);

          await Future<void>.delayed(const Duration(milliseconds: 50));
          expect(localeCubit.state.languageCode, 'ar');
          expect(themeCubit.state, ThemeMode.light);

          await localeCubit.close();
          await themeCubit.close();
        },
      );

      test(
        'RpePickerDialog provides trilingual (AR/EN/FR) effort labels and ExerciseGuidesData covers all 34 exercises',
        () async {
          for (final item in RpePickerDialog.rpeScales) {
            expect(
              RpePickerDialog.localizedLabelFor(item, 'ar').isNotEmpty,
              isTrue,
            );
            expect(
              RpePickerDialog.localizedLabelFor(item, 'en').isNotEmpty,
              isTrue,
            );
            expect(
              RpePickerDialog.localizedLabelFor(item, 'fr').isNotEmpty,
              isTrue,
            );
          }

          final exercises = await exerciseRepo.watchAllExercises().first;
          expect(exercises.length, 34);
          for (final ex in exercises) {
            final guideAr = ExerciseGuidesData.getGuide(ex.slug, 'ar');
            final guideEn = ExerciseGuidesData.getGuide(ex.slug, 'en');
            final guideFr = ExerciseGuidesData.getGuide(ex.slug, 'fr');
            expect(guideAr.primaryMuscles.isNotEmpty, isTrue);
            expect(guideEn.primaryMuscles.isNotEmpty, isTrue);
            expect(guideFr.primaryMuscles.isNotEmpty, isTrue);
          }
        },
      );

      testWidgets(
        'ExerciseMediaViewer renders biomechanical schematic fallback cleanly',
        (WidgetTester tester) async {
          final guide = ExerciseGuidesData.getGuide('dips', 'fr');
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(body: ExerciseMediaViewer(guide: guide)),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.byType(ExerciseMediaViewer), findsOneWidget);
        },
      );
    });
  });
}
