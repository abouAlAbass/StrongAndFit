import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:strong/core/database/app_database.dart';
import 'package:strong/core/l10n/generated/app_localizations.dart';
import 'package:strong/core/l10n/locale_cubit.dart';
import 'package:strong/core/notifications/rest_notification_service.dart';
import 'package:strong/core/services/ai_report_storage_service.dart';
import 'package:strong/core/theme/theme_cubit.dart';
import 'package:strong/features/exercises/data/repositories/exercise_repository_impl.dart';
import 'package:strong/features/exercises/domain/repositories/exercise_repository.dart';
import 'package:strong/features/exercises/presentation/cubit/exercise_list_cubit.dart';
import 'package:strong/features/exercises/presentation/screens/exercise_display_showcase_screen.dart';
import 'package:strong/features/history/domain/services/workout_export_service.dart';
import 'package:strong/features/history/domain/services/workout_import_service.dart';
import 'package:strong/features/history/presentation/screens/workout_history_screen.dart';
import 'package:strong/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:strong/features/profile/domain/repositories/profile_repository.dart';
import 'package:strong/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:strong/features/profile/presentation/screens/profile_screen.dart';
import 'package:strong/features/profile/presentation/widgets/athlete_onboarding_dialog.dart';
import 'package:strong/features/workout/data/repositories/rest_settings_repository_impl.dart';
import 'package:strong/features/workout/data/repositories/template_repository_impl.dart';
import 'package:strong/features/workout/data/repositories/workout_repository_impl.dart';
import 'package:strong/features/workout/domain/models/workout_ai_models.dart';
import 'package:strong/features/workout/domain/repositories/rest_settings_repository.dart';
import 'package:strong/features/workout/domain/repositories/template_repository.dart';
import 'package:strong/features/workout/domain/repositories/workout_repository.dart';
import 'package:strong/features/workout/domain/services/one_rep_max_calculator.dart';
import 'package:strong/features/workout/domain/services/plate_calculator.dart';
import 'package:strong/features/workout/domain/services/warmup_calculator.dart';
import 'package:strong/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:strong/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:strong/features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'package:strong/features/workout/presentation/cubit/routines_cubit.dart';
import 'package:strong/features/workout/presentation/screens/routines_dashboard_screen.dart';
import 'package:strong/features/workout/presentation/screens/workout_session_screen.dart';
import 'package:strong/features/workout/presentation/widgets/one_handed_quick_input_bar.dart';
import 'package:strong/features/workout/presentation/widgets/rpe_picker_dialog.dart';

class MockScenarioRestNotificationService implements RestNotificationService {
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
  final List<BlocBase<dynamic>> activeBlocs = [];

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase(NativeDatabase.memory());
    exerciseRepo = ExerciseRepositoryImpl(database.exerciseDao);
    workoutRepo = WorkoutRepositoryImpl(database.workoutDao);
    templateRepo = TemplateRepositoryImpl(database.templateDao);
    profileRepo = ProfileRepositoryImpl(database.profileDao);
    restSettingsRepo = RestSettingsRepositoryImpl(database.settingsDao);
    activeBlocs.clear();
  });

  tearDown(() async {
    for (final bloc in activeBlocs) {
      if (!bloc.isClosed) {
        await bloc.close().timeout(
          const Duration(seconds: 2),
          onTimeout: () {},
        );
      }
    }
    activeBlocs.clear();
    await database.close().timeout(
      const Duration(seconds: 2),
      onTimeout: () {},
    );
  });

  Widget buildScenarioTestHarness({
    required Widget child,
    Locale locale = const Locale('fr'),
    ThemeMode themeMode = ThemeMode.dark,
    ProfileCubit? profileCubit,
    RoutinesCubit? routinesCubit,
    WorkoutSessionBloc? workoutBloc,
    RestTimerCubit? restTimerCubit,
  }) {
    final pCubit = profileCubit ?? ProfileCubit(profileRepo);
    final rCubit = routinesCubit ?? RoutinesCubit(templateRepo);
    final wBloc = workoutBloc ?? WorkoutSessionBloc(workoutRepo);
    final tCubit =
        restTimerCubit ??
        RestTimerCubit(
          settings: restSettingsRepo,
          notifications: MockScenarioRestNotificationService(),
        );
    final themeCubit = ThemeCubit(settingsRepository: restSettingsRepo);
    final localeCubit = LocaleCubit(settingsRepository: restSettingsRepo);
    final exerciseListCubit = ExerciseListCubit(exerciseRepo);

    activeBlocs.addAll([
      pCubit,
      rCubit,
      wBloc,
      tCubit,
      themeCubit,
      localeCubit,
      exerciseListCubit,
    ]);

    final exportService = WorkoutExportService(
      database,
      tempDirectoryProvider: () async => Directory.systemTemp,
    );
    final importService = WorkoutImportService(
      database,
      tempDirectoryProvider: () async => Directory.systemTemp,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExerciseRepository>.value(value: exerciseRepo),
        RepositoryProvider<WorkoutRepository>.value(value: workoutRepo),
        RepositoryProvider<TemplateRepository>.value(value: templateRepo),
        RepositoryProvider<ProfileRepository>.value(value: profileRepo),
        RepositoryProvider<RestSettingsRepository>.value(
          value: restSettingsRepo,
        ),
        RepositoryProvider<WorkoutExportService>.value(value: exportService),
        RepositoryProvider<WorkoutImportService>.value(value: importService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: themeCubit),
          BlocProvider<LocaleCubit>.value(value: localeCubit),
          BlocProvider<ProfileCubit>.value(value: pCubit),
          BlocProvider<RoutinesCubit>.value(value: rCubit),
          BlocProvider<WorkoutSessionBloc>.value(value: wBloc),
          BlocProvider<RestTimerCubit>.value(value: tCubit),
          BlocProvider<ExerciseListCubit>.value(value: exerciseListCubit),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: themeMode,
          home: child,
        ),
      ),
    );
  }

  group('UI/UX User Scenario Test Suite', () {
    testWidgets(
      'Scenario 1: Full Athlete Onboarding Journey with RTL Arabic & Biometric Persistence',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final profileCubit = ProfileCubit(profileRepo);

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: const Scaffold(body: AthleteOnboardingDialog()),
            locale: const Locale('ar'),
            profileCubit: profileCubit,
          ),
        );
        await tester.pumpAndSettle();

        // Step 0: Language & Preferences verification
        expect(find.text('العربية'), findsOneWidget);
        expect(find.text('English'), findsOneWidget);
        expect(find.text('Français'), findsOneWidget);
        expect(find.text('اللغة والمظهر'), findsOneWidget);

        // Advance to Step 1: Goal Selection
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Step 1: Goals
        expect(find.text('الخطوة 1: هدفك الرئيسي'), findsOneWidget);
        await tester.tap(find.text('بناء العضلات (التضخيم)'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Step 2: Frequency
        expect(find.text('الخطوة 2: عدد الأيام أسبوعياً'), findsOneWidget);
        // Tap 4-days card unambiguously via its unique description
        await tester.tap(find.textContaining('تقسيم علوي / سفلي 4 أيام'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Step 3: Experience Level & Biometrics steppers
        expect(find.text('الخطوة 3: مستوى الخبرة'), findsOneWidget);
        expect(find.text('الوزن والطول'), findsOneWidget);

        final addIcons = find.byIcon(Icons.add);
        expect(addIcons, findsNWidgets(2));
        await tester.tap(addIcons.at(0)); // Weight +0.5
        await tester.tap(addIcons.at(1)); // Height +1
        await tester.pumpAndSettle();

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Step 4: Program Recommendation
        expect(find.text('برنامجك التدريبي المقترح'), findsOneWidget);
        expect(find.byIcon(Icons.star_rounded), findsWidgets);

        // Tap OutlinedButton ("تطبيق وحفظ" / Apply and Save)
        await tester.tap(find.byType(OutlinedButton));
        await tester.pumpAndSettle();

        // Verify SQLite database persistence with strict timeout bounds
        final profile = await tester.runAsync(() async {
          return await profileRepo
              .watchProfile()
              .take(1)
              .first
              .timeout(const Duration(seconds: 3));
        });
        expect(profile, isNotNull);
        expect(profile!.weeklyWorkoutGoal, 4);

        final weightLogs = await tester.runAsync(() async {
          return await profileRepo
              .watchWeightLogs()
              .take(1)
              .first
              .timeout(const Duration(seconds: 3));
        });
        expect(weightLogs, isNotNull);
        expect(weightLogs!.length, greaterThanOrEqualTo(1));

        // Clean unmount
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Scenario 2: Routine Discovery & AI Generator with Localized Chips',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: RoutinesDashboardScreen(
              currentLocale: const Locale('fr'),
              onLocaleChanged: (_) {},
            ),
            locale: const Locale('fr'),
          ),
        );
        await tester.pumpAndSettle();

        // Dismiss auto-prompted onboarding dialog if visible
        final skipBtn = find.text('Passer');
        if (skipBtn.evaluate().isNotEmpty) {
          await tester.tap(skipBtn);
          await tester.pumpAndSettle();
        }

        // 1. Check dashboard header & templates
        expect(find.text('Entraînement'), findsOneWidget);
        expect(find.text('Séances types & modèles'), findsOneWidget);
        expect(find.text('Générer par IA'), findsOneWidget);

        // 2. Open AI Routine Generator
        await tester.tap(find.text('Générer par IA'));
        await tester.pumpAndSettle();

        // 3. Verify AI Routine Generator dialog components with exact chip labels
        expect(find.text('Générateur de Routine IA'), findsOneWidget);
        expect(
          find.text('Conception automatique & insertion SQLite'),
          findsOneWidget,
        );
        expect(find.text('Structure / Focus ciblé'), findsOneWidget);
        expect(find.text('Push (Pecs / Épaules / Triceps)'), findsOneWidget);
        expect(find.text('Pull (Dos / Biceps)'), findsOneWidget);
        expect(find.text('⏱ 45 min'), findsOneWidget);

        // Select Focus: Pull & Duration: 45 min
        await tester.tap(find.text('Pull (Dos / Biceps)'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('⏱ 45 min'));
        await tester.pumpAndSettle();

        // Enter free prompt note
        await tester.enterText(
          find.byType(TextField),
          'Accent grand dorsal et avant-bras',
        );
        await tester.pumpAndSettle();

        expect(find.text('Concevoir le programme avec Gemini'), findsOneWidget);

        // Close dialog
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();

        // Clean unmount
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Scenario 3: Live Workout Execution, One-Handed Quick Input, RPE & Rest Chronometer',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // 1. Seed active session inside real async zone BEFORE instantiating Cubits/Widgets
        await tester.runAsync(() async {
          final sessionId = await workoutRepo.startNewSession(
            title: 'Upper Hypertrophy Session',
          );
          final exercises = await exerciseRepo
              .watchAllExercises()
              .take(1)
              .first
              .timeout(const Duration(seconds: 3));
          final bench = exercises.firstWhere((e) => e.slug == 'bench_press');
          final weId = await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: bench.id,
          );
          await workoutRepo.addSet(
            workoutExerciseId: weId,
            setNumber: 1,
            weightKg: 80.0,
            reps: 8,
          );
          await workoutRepo.addSet(
            workoutExerciseId: weId,
            setNumber: 2,
            weightKg: 80.0,
            reps: 8,
          );
        });

        final mockNotifications = MockScenarioRestNotificationService();
        final restTimerCubit = RestTimerCubit(
          settings: restSettingsRepo,
          notifications: mockNotifications,
        );
        final workoutBloc = WorkoutSessionBloc(workoutRepo)
          ..add(const ResumeActiveSessionRequested());

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: WorkoutSessionScreen(
              currentLocale: const Locale('fr'),
              onLocaleChanged: (_) {},
            ),
            locale: const Locale('fr'),
            workoutBloc: workoutBloc,
            restTimerCubit: restTimerCubit,
          ),
        );
        // Pump frames incrementally to let BLoC streams load without hanging on timers
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Verify session header and exercise card
        expect(find.text('Upper Hypertrophy Session'), findsWidgets);
        expect(find.text('Développé couché à la barre'), findsWidgets);

        // 2. Test One-Handed Quick Input Bar
        expect(find.byType(OneHandedQuickInputBar), findsOneWidget);
        expect(find.text('+5'), findsWidgets);
        expect(find.text('+2.5'), findsWidgets);
        expect(find.text('+1'), findsWidgets);

        // 3. Test RPE effort picker modal
        await tester.tap(find.text('RPE').first);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.byType(RpePickerDialog), findsOneWidget);
        expect(find.text('Effort perçu (RPE / RIR)'), findsOneWidget);
        expect(find.text('@8'), findsOneWidget);

        // Select RPE 8.0 (2 RIR)
        await tester.tap(find.text('@8'));
        await tester.pump(const Duration(milliseconds: 300));

        // 4. Test Set Completion Checkmark & Rest Chronometer Auto-start
        final checkIcons = find.byIcon(Icons.check_rounded);
        expect(checkIcons, findsWidgets);
        await tester.tap(checkIcons.first);
        await tester.pump(const Duration(milliseconds: 300));

        // Verify notification scheduled for rest end
        expect(mockNotifications.scheduledEndsAt, isNotNull);

        // 5. Adjust rest timer by +30 seconds
        restTimerCubit.adjustTime(30);
        await tester.pump(const Duration(milliseconds: 100));
        expect(restTimerCubit.state.remainingSeconds, greaterThan(60));

        // Stop timers and initiate BLoC close BEFORE pumping so FakeAsync flushes cleanly
        restTimerCubit.stop();
        final closeFuture = Future.wait([
          restTimerCubit.close(),
          workoutBloc.close(),
        ]);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 200));
        await tester.runAsync(
          () => closeFuture.timeout(
            const Duration(seconds: 2),
            onTimeout: () => [],
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    testWidgets(
      'Scenario 4: History Exploration, AI Coaching Reports & Biomechanical Calculators',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // 1. Seed completed workout session & AI report safely in runAsync with timeouts
        await tester.runAsync(() async {
          final sessionId = await workoutRepo.startNewSession(
            title: 'Full Body Push PR',
          );
          final exercises = await exerciseRepo
              .watchAllExercises()
              .take(1)
              .first
              .timeout(const Duration(seconds: 3));
          final squat = exercises.firstWhere((e) => e.slug == 'squat');
          await workoutRepo.addExerciseToSession(
            sessionId: sessionId,
            exerciseId: squat.id,
          );
          await workoutRepo.completeSession(
            sessionId: sessionId,
            durationSeconds: 2400,
          );

          final aiReportStorage = AiReportStorageService();
          const testProgressionReport = HistoryAiAnalysis(
            executiveSummary:
                'Excellente progression du volume global sur les quadriceps.',
            progressionScore: 9,
            progressiveOverloadRate:
                'Surcharge progressive régulière (+2.5 kg).',
            volumeTrajectory: 'Trajectoire en augmentation constante.',
            muscularBalance:
                'Distribution équilibrée entre agonistes/antagonistes.',
            fatigueAndPlateauAlerts: ['Attention au repos inter-séances.'],
            nextCycleMilestones: ['Viser 140 kg sur 5 répétitions.'],
          );
          await aiReportStorage.saveHistoryAnalysis(testProgressionReport);
        });

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: const WorkoutHistoryScreen(),
            locale: const Locale('fr'),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // 2. Tab 1: Sessions
        expect(find.text('Historique des séances'), findsOneWidget);
        expect(find.text('Séances'), findsOneWidget);
        expect(find.text('Bilans Coach IA'), findsOneWidget);
        expect(find.text('Full Body Push PR'), findsOneWidget);

        // 3. Tab 2: Bilans Coach IA
        await tester.tap(find.text('Bilans Coach IA'));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('9/10'), findsOneWidget);
        expect(find.text('Score de régularité & surcharge'), findsOneWidget);
        expect(
          find.text(
            'Excellente progression du volume global sur les quadriceps.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('⚡ Surcharge progressive régulière (+2.5 kg).'),
          findsOneWidget,
        );

        // 4. Test Biomechanical Calculators: 1RM, Plates, and Warmup
        final oneRm = OneRepMaxCalculator.calculate(weight: 100.0, reps: 5);
        expect(oneRm.round(), 117);

        final plates = PlateCalculator.calculate(
          targetWeight: 102.5,
          barWeight: 20.0,
        );
        expect(plates.isExact, true);
        expect(plates.platesPerSide.any((p) => p.weightKg == 25.0), true);

        final warmupSteps = WarmupCalculator.generate(workingWeightKg: 100.0);
        expect(warmupSteps.length, greaterThanOrEqualTo(3));
        expect(warmupSteps.first.weightKg, 20.0);

        // Clean unmount
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Scenario 5: Profile Management, Weight Progression & Responsive Settings UI',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // 1. Seed initial weight progress BEFORE mounting widget tree
        await tester.runAsync(() async {
          await profileRepo.updateProfile(weightKg: 83.0, heightCm: 180.0);
          await profileRepo.logBodyWeight(83.0, notes: 'Pesée à jeun du matin');
          final updatedLogs = await profileRepo
              .watchWeightLogs()
              .take(1)
              .first
              .timeout(const Duration(seconds: 3));
          expect(updatedLogs.any((l) => l.weightKg == 83.0), true);
        });

        final profileCubit = ProfileCubit(profileRepo);

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: ProfileScreen(
              currentLocale: const Locale('fr'),
              onLocaleChanged: (_) {},
            ),
            locale: const Locale('fr'),
            profileCubit: profileCubit,
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // 2. Verify profile screen elements & biometric metrics (0 overflow)
        expect(find.text('Profil Athlète'), findsOneWidget);
        expect(find.textContaining('83.0 kg'), findsWidgets);

        await tester.scrollUntilVisible(
          find.text('Paramètres & Langue'),
          300.0,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Paramètres & Langue'), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text('Sauvegarde & Export de données'),
          300.0,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Sauvegarde & Export de données'), findsOneWidget);

        // Clean unmount
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    test(
      'Scenario 5b: Complete JSON Export & Atomic Import Round-Trip',
      () async {
        await profileRepo.logBodyWeight(84.5, notes: 'Cycle Force');
        final exportService = WorkoutExportService(
          database,
          tempDirectoryProvider: () async => Directory.systemTemp,
        );
        final backupFile = await exportService.generateJsonBackup().timeout(
          const Duration(seconds: 3),
        );
        expect(backupFile.existsSync(), true);

        final targetDb = AppDatabase(NativeDatabase.memory());
        final targetImport = WorkoutImportService(
          targetDb,
          tempDirectoryProvider: () async => Directory.systemTemp,
        );
        final importResult = await targetImport
            .importFromFile(
              backupFile,
              overwrite: true,
              purgeTempFileAfterRead: true,
            )
            .timeout(const Duration(seconds: 3));

        expect(importResult.profileUpdated, isTrue);
        await targetDb.close();
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    testWidgets(
      'Scenario 6: Arabic RTL Mobile Phone (360x800) Dashboard & Start Workout Layout Audit',
      (WidgetTester tester) async {
        // Realistic compact smartphone screen (360 x 800 logical dp)
        tester.view.physicalSize = const Size(720, 1600);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final workoutBloc = WorkoutSessionBloc(workoutRepo);
        final restTimerCubit = RestTimerCubit(
          settings: restSettingsRepo,
          notifications: MockScenarioRestNotificationService(),
        );

        await tester.pumpWidget(
          buildScenarioTestHarness(
            child: RoutinesDashboardScreen(
              currentLocale: const Locale('ar'),
              onLocaleChanged: (_) {},
            ),
            locale: const Locale('ar'),
            workoutBloc: workoutBloc,
            restTimerCubit: restTimerCubit,
          ),
        );
        await tester.pumpAndSettle();

        // Dismiss auto-prompted onboarding dialog if visible
        final skipBtn = find.text('تخطي');
        if (skipBtn.evaluate().isNotEmpty) {
          await tester.tap(skipBtn);
          await tester.pumpAndSettle();
        }

        // Scroll down through entire dashboard in Arabic to detect any RenderFlex overflow
        await tester.scrollUntilVisible(
          find.text('نماذج الجلسات الجاهزة'),
          250.0,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();

        // Start a workout from a routine template in Arabic!
        final startRoutineBtns = find.text('بدء هذا الروتين');
        if (startRoutineBtns.evaluate().isNotEmpty) {
          await tester.ensureVisible(startRoutineBtns.first);
          await tester.pumpAndSettle();
          await tester.tap(startRoutineBtns.first);
        } else {
          final startFreeBtns = find.byType(ElevatedButton);
          await tester.tap(startFreeBtns.first);
        }

        // Let navigation & WorkoutSessionScreen build
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 300));

        // Verify WorkoutSessionScreen rendered cleanly with RTL direction
        expect(find.byType(WorkoutSessionScreen), findsOneWidget);
        expect(
          Directionality.of(tester.element(find.byType(WorkoutSessionScreen))),
          TextDirection.rtl,
        );

        // Clean unmount
        restTimerCubit.stop();
        final closeFuture = Future.wait([
          restTimerCubit.close(),
          workoutBloc.close(),
        ]);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 200));
        await tester.runAsync(
          () => closeFuture.timeout(
            const Duration(seconds: 2),
            onTimeout: () => [],
          ),
        );
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );

    testWidgets(
      'Scenario 7: ExerciseDisplayShowcaseScreen A/B/C Methods & Interactive Slider (360x800)',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(720, 1600);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ExerciseDisplayShowcaseScreen(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 250));

        // Verify header & 3 exercises chips
        expect(find.text('Labo Visuel Exercices'), findsOneWidget);
        expect(find.text('Développé couché'), findsOneWidget);
        expect(find.text('Rowing buste penché'), findsOneWidget);
        expect(find.text('Écarté à la poulie'), findsOneWidget);

        // Verify Method A phase badge starts at PHASE 1
        expect(find.text('PHASE 1 : DÉPART'), findsOneWidget);

        // Advance FakeAsync by 1250ms to verify Timer switches to PHASE 2
        await tester.pump(const Duration(milliseconds: 1250));
        expect(find.text('PHASE 2 : CONTRACTION'), findsOneWidget);

        // Switch exercise to Rowing buste penché
        await tester.tap(find.text('Rowing buste penché'));
        await tester.pump(const Duration(milliseconds: 200));

        // Switch to Method B tab only and verify CustomPainter silhouette & legend
        await tester.tap(find.text('B · Anatomie'));
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text('MÉTHODE B'), findsOneWidget);
        expect(find.textContaining('Grand dorsal, Trapèzes'), findsOneWidget);

        // Switch to Method C tab and verify Biomechanical Cues & Slider
        await tester.tap(find.text('C · Hybride'));
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text('MÉTHODE C'), findsOneWidget);
        expect(find.text('SETUP'), findsOneWidget);
        expect(find.text('TRAJECTOIRE'), findsOneWidget);
        expect(find.text('RESPIRATION & TEMPO'), findsOneWidget);

        // Slide manual trajectory inspector to ~100%
        final slider = find.byType(Slider);
        expect(slider, findsOneWidget);
        await tester.ensureVisible(slider);
        await tester.pump(const Duration(milliseconds: 100));
        await tester.drag(slider, const Offset(300, 0));
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text('Pic de contraction'), findsOneWidget);

        // Clean unmount so AnimationController & Timer dispose cleanly
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
      },
      timeout: const Timeout(Duration(seconds: 15)),
    );
  });
}
