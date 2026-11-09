import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/database/app_database.dart';
import 'core/l10n/generated/app_localizations.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/notifications/rest_notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/exercises/data/repositories/exercise_repository_impl.dart';
import 'features/exercises/domain/repositories/exercise_repository.dart';
import 'features/exercises/presentation/cubit/exercise_list_cubit.dart';
import 'features/history/domain/services/workout_export_service.dart';
import 'features/history/domain/services/workout_import_service.dart';
import 'features/home/presentation/screens/main_navigation_screen.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/workout/data/repositories/rest_settings_repository_impl.dart';
import 'features/workout/data/repositories/template_repository_impl.dart';
import 'features/workout/data/repositories/workout_repository_impl.dart';
import 'features/workout/domain/repositories/rest_settings_repository.dart';
import 'features/workout/domain/repositories/template_repository.dart';
import 'features/workout/domain/repositories/workout_repository.dart';
import 'features/workout/presentation/bloc/workout_session_bloc.dart';
import 'features/workout/presentation/bloc/workout_session_event.dart';
import 'features/workout/presentation/cubit/rest_timer_cubit.dart';
import 'features/workout/presentation/cubit/routines_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (fail-safe for offline tests)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization: $e');
  }

  // Instantiate singleton Drift Database (100% offline-first SQLite)
  final database = AppDatabase();

  // Initialize clean architecture repositories
  final exerciseRepository = ExerciseRepositoryImpl(database.exerciseDao);
  final workoutRepository = WorkoutRepositoryImpl(database.workoutDao);
  final templateRepository = TemplateRepositoryImpl(database.templateDao);
  final profileRepository = ProfileRepositoryImpl(database.profileDao);
  final restSettingsRepository = RestSettingsRepositoryImpl(
    database.settingsDao,
  );
  final exportService = WorkoutExportService(database);
  final importService = WorkoutImportService(database);

  // OS-level alert when rest ends (works with the screen locked).
  final restNotifications = LocalRestNotificationService();
  await restNotifications.init();

  runApp(
    StrongApp(
      exerciseRepository: exerciseRepository,
      workoutRepository: workoutRepository,
      templateRepository: templateRepository,
      profileRepository: profileRepository,
      restSettingsRepository: restSettingsRepository,
      restNotifications: restNotifications,
      exportService: exportService,
      importService: importService,
    ),
  );
}

class StrongApp extends StatelessWidget {
  final ExerciseRepository exerciseRepository;
  final WorkoutRepository workoutRepository;
  final TemplateRepository templateRepository;
  final ProfileRepository profileRepository;
  final RestSettingsRepository restSettingsRepository;
  final RestNotificationService restNotifications;
  final WorkoutExportService? exportService;
  final WorkoutImportService? importService;

  const StrongApp({
    super.key,
    required this.exerciseRepository,
    required this.workoutRepository,
    required this.templateRepository,
    required this.profileRepository,
    required this.restSettingsRepository,
    this.restNotifications = const NoopRestNotificationService(),
    this.exportService,
    this.importService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExerciseRepository>.value(value: exerciseRepository),
        RepositoryProvider<WorkoutRepository>.value(value: workoutRepository),
        RepositoryProvider<TemplateRepository>.value(value: templateRepository),
        RepositoryProvider<ProfileRepository>.value(value: profileRepository),
        RepositoryProvider<RestSettingsRepository>.value(
          value: restSettingsRepository,
        ),
        if (exportService != null)
          RepositoryProvider<WorkoutExportService>.value(value: exportService!),
        if (importService != null)
          RepositoryProvider<WorkoutImportService>.value(value: importService!),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) =>
                ThemeCubit(settingsRepository: restSettingsRepository),
          ),
          BlocProvider<LocaleCubit>(
            create: (_) =>
                LocaleCubit(settingsRepository: restSettingsRepository),
          ),
          BlocProvider<WorkoutSessionBloc>(
            create: (ctx) =>
                WorkoutSessionBloc(workoutRepository)
                  ..add(const ResumeActiveSessionRequested()),
          ),
          BlocProvider<RoutinesCubit>(
            create: (ctx) => RoutinesCubit(templateRepository),
          ),
          BlocProvider<ProfileCubit>(
            create: (ctx) => ProfileCubit(profileRepository),
          ),
          BlocProvider<ExerciseListCubit>(
            create: (ctx) => ExerciseListCubit(exerciseRepository),
          ),
          BlocProvider<RestTimerCubit>(
            create: (ctx) => RestTimerCubit(
              settings: restSettingsRepository,
              notifications: restNotifications,
            ),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LocaleCubit, Locale>(
              builder: (context, currentLocale) {
                return MaterialApp(
                  title: 'Strong Track',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  locale: currentLocale,
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  home: MainNavigationScreen(
                    currentLocale: currentLocale,
                    onLocaleChanged: (newLocale) =>
                        context.read<LocaleCubit>().setLocale(newLocale),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
