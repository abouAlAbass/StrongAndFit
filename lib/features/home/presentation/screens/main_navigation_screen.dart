import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../exercises/presentation/screens/exercises_screen.dart';
import '../../../history/presentation/screens/workout_history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../workout/presentation/cubit/rest_timer_cubit.dart';
import '../../../workout/presentation/screens/routines_dashboard_screen.dart';
import '../../../workout/presentation/widgets/rest_timer_floating_bar.dart';

/// Root shell with modern adaptive navigation: NavigationBar on mobile,
/// NavigationRail on wider screens/tablets/desktop.
class MainNavigationScreen extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const MainNavigationScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<RestTimerCubit>().sync();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    if (l10n != null) {
      context.read<RestTimerCubit>().updateNotificationText(
            title: l10n.restNotificationTitle,
            body: l10n.restNotificationBody,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 800;

    final screens = [
      RoutinesDashboardScreen(
        currentLocale: widget.currentLocale,
        onLocaleChanged: widget.onLocaleChanged,
      ),
      const WorkoutHistoryScreen(),
      const ExercisesScreen(),
      ProfileScreen(
        currentLocale: widget.currentLocale,
        onLocaleChanged: widget.onLocaleChanged,
      ),
    ];

    final Widget content = isWide
        ? Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: AppColors.ofSurface(context),
                  indicatorColor: AppColors.ofPrimaryContainer(context),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/icons/app_logo.png',
                        width: 38,
                        height: 38,
                      ),
                    ),
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.fitness_center_outlined),
                      selectedIcon: const Icon(Icons.fitness_center, color: AppColors.primary),
                      label: Text(l10n.navWorkout),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.history_outlined),
                      selectedIcon: const Icon(Icons.history, color: AppColors.primary),
                      label: Text(l10n.navHistory),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.format_list_bulleted_outlined),
                      selectedIcon: const Icon(Icons.format_list_bulleted, color: AppColors.primary),
                      label: Text(l10n.navExercises),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.person_outline),
                      selectedIcon: const Icon(Icons.person, color: AppColors.primary),
                      label: Text(l10n.navProfile),
                    ),
                  ],
                ),
                VerticalDivider(thickness: 1, width: 1, color: AppColors.ofBorder(context)),
                Expanded(
                  child: Column(
                    children: [
                      const RestTimerFloatingBar(),
                      Expanded(
                        child: IndexedStack(
                          index: _currentIndex,
                          children: screens,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const RestTimerFloatingBar(),
                NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  backgroundColor: AppColors.ofSurface(context),
                  indicatorColor: AppColors.ofPrimaryContainer(context),
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.fitness_center_outlined),
                      selectedIcon: const Icon(Icons.fitness_center, color: AppColors.primary),
                      label: l10n.navWorkout,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.history_outlined),
                      selectedIcon: const Icon(Icons.history, color: AppColors.primary),
                      label: l10n.navHistory,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.format_list_bulleted_outlined),
                      selectedIcon: const Icon(Icons.format_list_bulleted, color: AppColors.primary),
                      label: l10n.navExercises,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.person_outline),
                      selectedIcon: const Icon(Icons.person, color: AppColors.primary),
                      label: l10n.navProfile,
                    ),
                  ],
                ),
              ],
            ),
          );

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: content,
    );
  }
}
