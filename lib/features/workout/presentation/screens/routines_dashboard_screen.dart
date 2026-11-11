import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../history/presentation/screens/workout_history_screen.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/widgets/athlete_onboarding_dialog.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../bloc/workout_session_state.dart';
import '../cubit/routines_cubit.dart';
import '../cubit/routines_state.dart';
import '../widgets/ai_routine_generator_dialog.dart';
import '../widgets/create_routine_dialog.dart';
import '../widgets/program_ai_analysis_dialog.dart';
import 'workout_session_screen.dart';

/// Routines and Workout Start Dashboard with responsive tablet & desktop scaling.
class RoutinesDashboardScreen extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const RoutinesDashboardScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<RoutinesDashboardScreen> createState() =>
      _RoutinesDashboardScreenState();
}

class _RoutinesDashboardScreenState extends State<RoutinesDashboardScreen> {
  static int? _chosenProgramTemplateId;
  static bool _hasPromptedOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeOnboarding();
    });
  }

  void _checkFirstTimeOnboarding() {
    if (_hasPromptedOnboarding) return;
    _hasPromptedOnboarding = true;

    final profileState = context.read<ProfileCubit>().state;
    final totalWorkouts = profileState.lifetimeStats?.totalWorkouts ?? 0;

    // If new athlete without logged workouts or chosen program, prompt onboarding with skip option
    if (totalWorkouts == 0 && _chosenProgramTemplateId == null) {
      _openOnboardingDialog();
    }
  }

  Future<void> _openOnboardingDialog() async {
    final chosen = await AthleteOnboardingDialog.show(
      context,
      onRoutineStarted: () => _navigateToActiveWorkout(context),
      onLocaleChanged: widget.onLocaleChanged,
    );
    if (chosen != null && mounted) {
      setState(() {
        _chosenProgramTemplateId = chosen.template.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icons/app_logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.navWorkout,
                style: AppTypography.ofTitleLarge(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Workout History Shortcut
          IconButton(
            tooltip: l10n.workoutHistory,
            icon: const Icon(Icons.history_rounded),
            color: AppColors.ofTextPrimary(context),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WorkoutHistoryScreen()),
              );
            },
          ),
          // 1-Tap Theme Mode Switch (Sun / Moon)
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? l10n.themeLight : l10n.themeDark,
                icon: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: AppColors.ofTextPrimary(context),
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          // Language Switch Dropdown
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: AppColors.ofTextPrimary(context)),
            color: AppColors.ofSurfaceElevated(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (code) => widget.onLocaleChanged(Locale(code)),
            itemBuilder: (ctx) => [
              _buildPopupItem(
                context,
                'ar',
                'العربية',
                widget.currentLocale.languageCode == 'ar',
              ),
              _buildPopupItem(
                context,
                'en',
                'English',
                widget.currentLocale.languageCode == 'en',
              ),
              _buildPopupItem(
                context,
                'fr',
                'Français',
                widget.currentLocale.languageCode == 'fr',
              ),
            ],
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 780,
        child: BlocBuilder<RoutinesCubit, RoutinesState>(
          builder: (context, routinesState) {
            TemplateDetail? userProgram;
            if (_chosenProgramTemplateId != null &&
                routinesState.templates.isNotEmpty) {
              final matches = routinesState.templates.where(
                (t) => t.template.id == _chosenProgramTemplateId,
              );
              if (matches.isNotEmpty) {
                userProgram = matches.first;
              }
            }

            final otherTemplates = routinesState.templates.where((t) {
              return userProgram == null ||
                  t.template.id != userProgram.template.id;
            }).toList();

            return ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 40),
              children: [
                // 1. Ongoing Session Sticky Card (if active)
                BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
                  builder: (context, state) {
                    if (!state.hasActiveSession) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 16),
                      padding: const EdgeInsetsDirectional.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.ongoingWorkout,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.detail!.session.title,
                                  style: AppTypography.titleMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  state.formattedDuration,
                                  style: AppTypography.caption.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onPressed: () {
                              _navigateToActiveWorkout(context);
                            },
                            child: Text(
                              l10n.resumeWorkout,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // 2. "Votre programme" (displayed prominently first if chosen)
                if (userProgram != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.yourProgram,
                          style: AppTypography.ofTitleLarge(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildRoutineCard(context, userProgram, isFeatured: true),
                  const SizedBox(height: 16),
                ],

                // 3. "Séance personnalisée" (Quick Start Empty Workout)
                Container(
                  padding: const EdgeInsetsDirectional.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.ofCard(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.ofBorder(context),
                      width: 0.8,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final headerRow = Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.ofPrimaryContainer(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.customWorkoutTitle,
                                  style: AppTypography.ofTitleLarge(context),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  l10n.customWorkoutSubtitle,
                                  style: AppTypography.ofCaption(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                      final startButton = ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(
                          l10n.startWorkout,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          context.read<WorkoutSessionBloc>().add(
                            const StartSessionRequested(),
                          );
                          _navigateToActiveWorkout(context);
                        },
                      );

                      // Stack cleanly full-width on compact mobile screens (<= 420dp inner card)
                      if (constraints.maxWidth < 420) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            headerRow,
                            const SizedBox(height: 14),
                            SizedBox(height: 44, child: startButton),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: headerRow),
                          const SizedBox(width: 12),
                          startButton,
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 4. "Trouver votre séance idéale" (Onboarding / Recommender Banner)
                InkWell(
                  onTap: _openOnboardingDialog,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withAlpha(120),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.findIdealWorkoutTitle,
                                style: AppTypography.titleMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.findIdealWorkoutSubtitle,
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white70,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 4b. "Historique des séances & Bilans IA"
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const WorkoutHistoryScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.ofCard(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.ofBorder(context),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            color: AppColors.secondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.viewWorkoutHistory,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${l10n.tabWorkouts} & ${l10n.tabAiReports}',
                                style: AppTypography.ofCaption(context),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.ofTextTertiary(context),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. "Séances types & modèles" Section Header
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Text(
                      l10n.readyTemplates,
                      style: AppTypography.ofTitleLarge(context),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: FilledButton.tonalIcon(
                            icon: const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            label: Text(
                              l10n.aiGenerateRoutine,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () => AiRoutineGeneratorDialog.show(
                              context,
                              currentLocale: widget.currentLocale,
                              onLocaleChanged: widget.onLocaleChanged,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_rounded),
                          tooltip: l10n.createRoutine,
                          onPressed: () => CreateRoutineDialog.show(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 6. List of Routines / Templates
                if (routinesState.status == RoutinesStatus.loading &&
                    routinesState.templates.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (otherTemplates.isEmpty && userProgram == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        l10n.emptyTemplates,
                        style: AppTypography.ofBodySecondary(context),
                      ),
                    ),
                  )
                else
                  Column(
                    children: otherTemplates.map((template) {
                      return _buildRoutineCard(context, template);
                    }).toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoutineCard(
    BuildContext context,
    TemplateDetail template, {
    bool isFeatured = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final exercisesCount = template.exercises.length;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 14),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: isFeatured
            ? AppColors.ofSurfaceElevated(context)
            : AppColors.ofSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFeatured ? AppColors.secondary : AppColors.ofBorder(context),
          width: isFeatured ? 1.5 : 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Routine Name & Exercise Count Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _resolveTemplateTitle(template.template.name, l10n),
                  style: AppTypography.ofTitleMedium(context).copyWith(
                    fontSize: 17,
                    fontWeight: isFeatured ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isFeatured)
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  margin: const EdgeInsetsDirectional.only(end: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(40),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.secondary, width: 0.8),
                  ),
                  child: Text(
                    l10n.yourProgram,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ofSurfaceElevated(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.templateExercisesCount(exercisesCount),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ofTextSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Notes / Objective
          if (template.template.notes != null)
            Text(
              _resolveTemplateDesc(
                template.template.name,
                template.template.notes!,
                l10n,
              ),
              style: AppTypography.ofBodySecondary(
                context,
              ).copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 12),

          // Exercise Preview Chips
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: template.exercises.take(5).map((item) {
              return Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ofInputBackground(context),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.ofBorder(context),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${item.exercise.localizedName(context)} (${item.templateExercise.targetSets}s)',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.ofTextPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Action: Start Routine Button & AI Program Audit Button
          LayoutBuilder(
            builder: (context, constraints) {
              final startBtn = SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center, size: 18),
                  label: Text(
                    l10n.startRoutine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFeatured
                        ? AppColors.primary
                        : AppColors.ofPrimaryContainer(context),
                    foregroundColor: isFeatured
                        ? Colors.white
                        : AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 14,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    context.read<WorkoutSessionBloc>().add(
                      StartSessionFromTemplateRequested(template),
                    );
                    _navigateToActiveWorkout(context);
                  },
                ),
              );

              final aiAuditBtn = SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  label: Text(
                    l10n.aiAnalyzeProgramButton,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.ofTextPrimary(context),
                    side: BorderSide(
                      color: AppColors.secondary.withAlpha(120),
                      width: 1,
                    ),
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10,
                    ),
                  ),
                  onPressed: () {
                    ProgramAiAnalysisDialog.show(context, template: template);
                  },
                ),
              );

              if (constraints.maxWidth < 390) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [startBtn, const SizedBox(height: 8), aiAuditBtn],
                );
              }

              return Row(
                children: [
                  Expanded(child: startBtn),
                  const SizedBox(width: 8),
                  Flexible(child: aiAuditBtn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToActiveWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutSessionScreen(
          currentLocale: widget.currentLocale,
          onLocaleChanged: widget.onLocaleChanged,
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    BuildContext context,
    String code,
    String label,
    bool isSelected,
  ) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.ofTextPrimary(context),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }

  String _resolveTemplateTitle(String originalName, AppLocalizations l10n) {
    if (originalName.contains('Full Body')) return l10n.templateFullBodyTitle;
    if (originalName.contains('Upper Body')) return l10n.templateUpperTitle;
    if (originalName.contains('Lower Body')) return l10n.templateLowerTitle;
    if (originalName.contains('Push Day')) return l10n.templatePushTitle;
    if (originalName.contains('Pull Day')) return l10n.templatePullTitle;
    return originalName;
  }

  String _resolveTemplateDesc(
    String name,
    String fallback,
    AppLocalizations l10n,
  ) {
    if (name.contains('Full Body')) return l10n.templateFullBodyDesc;
    if (name.contains('Upper Body')) return l10n.templateUpperDesc;
    if (name.contains('Lower Body')) return l10n.templateLowerDesc;
    if (name.contains('Push Day')) return l10n.templatePushDesc;
    if (name.contains('Pull Day')) return l10n.templatePullDesc;
    return fallback;
  }
}
