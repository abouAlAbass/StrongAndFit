import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../profile/presentation/widgets/athlete_onboarding_dialog.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../bloc/workout_session_state.dart';
import '../cubit/routines_cubit.dart';
import '../cubit/routines_state.dart';
import '../widgets/create_routine_dialog.dart';
import 'workout_session_screen.dart';

/// Routines and Workout Start Dashboard with responsive tablet & desktop scaling.
class RoutinesDashboardScreen extends StatelessWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const RoutinesDashboardScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

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
            const SizedBox(width: 10),
            Text(l10n.navWorkout, style: AppTypography.ofTitleLarge(context)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: AppColors.ofTextPrimary(context)),
            color: AppColors.ofSurfaceElevated(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (code) => onLocaleChanged(Locale(code)),
            itemBuilder: (ctx) => [
              _buildPopupItem(context, 'en', 'English (EN)', currentLocale.languageCode == 'en'),
              _buildPopupItem(context, 'fr', 'Français (FR)', currentLocale.languageCode == 'fr'),
              _buildPopupItem(context, 'ar', 'العربية (AR - RTL)', currentLocale.languageCode == 'ar'),
            ],
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 780,
        child: ListView(
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
                    border: Border.all(color: AppColors.primary, width: 1.2),
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
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
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
                              style: AppTypography.titleMedium.copyWith(color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              state.formattedDuration,
                              style: AppTypography.caption.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () {
                          _navigateToActiveWorkout(context);
                        },
                        child: Text(l10n.resumeWorkout),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 2. Quick Start Empty Workout (Card)
            Container(
              padding: const EdgeInsetsDirectional.all(18),
              decoration: BoxDecoration(
                color: AppColors.ofCard(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.ofPrimaryContainer(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.quickStart, style: AppTypography.ofTitleLarge(context)),
                        const SizedBox(height: 2),
                        Text(l10n.quickStartSubtitle, style: AppTypography.ofCaption(context)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WorkoutSessionBloc>().add(const StartSessionRequested());
                      _navigateToActiveWorkout(context);
                    },
                    child: Text(l10n.startWorkout),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2b. Modern Program Matching Banner (Onboarding / Recommender)
            InkWell(
              onTap: () => AthleteOnboardingDialog.show(
                context,
                onRoutineStarted: () => _navigateToActiveWorkout(context),
              ),
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
                  border: Border.all(color: AppColors.primary.withAlpha(120), width: 1.2),
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
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.findIdealProgram,
                            style: AppTypography.titleMedium.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.onboardingSubtitle,
                            style: AppTypography.caption.copyWith(color: Colors.white70),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Pre-designed Routines Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(l10n.routines, style: AppTypography.ofTitleLarge(context)),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(l10n.createRoutine),
                  onPressed: () => CreateRoutineDialog.show(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. List of Pre-Designed Routines
            BlocBuilder<RoutinesCubit, RoutinesState>(
              builder: (context, state) {
                if (state.status == RoutinesStatus.loading && state.templates.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.templates.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        l10n.emptyTemplates,
                        style: AppTypography.ofBodySecondary(context),
                      ),
                    ),
                  );
                }

                return Column(
                  children: state.templates.map((template) {
                    return _buildRoutineCard(context, template);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(BuildContext context, TemplateDetail template) {
    final l10n = AppLocalizations.of(context)!;
    final exercisesCount = template.exercises.length;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 14),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
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
                  style: AppTypography.ofTitleMedium(context).copyWith(fontSize: 17),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 3),
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
              _resolveTemplateDesc(template.template.name, template.template.notes!, l10n),
              style: AppTypography.ofBodySecondary(context).copyWith(fontSize: 13),
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
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.ofInputBackground(context),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.ofBorder(context), width: 0.5),
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

          // Action: Start Routine Button
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.fitness_center, size: 18),
              label: Text(l10n.startRoutine),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ofPrimaryContainer(context),
                foregroundColor: AppColors.primary,
                elevation: 0,
              ),
              onPressed: () {
                context.read<WorkoutSessionBloc>().add(
                      StartSessionFromTemplateRequested(template),
                    );
                _navigateToActiveWorkout(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToActiveWorkout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkoutSessionScreen(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
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
              color: isSelected ? AppColors.primary : AppColors.ofTextPrimary(context),
            ),
          ),
          if (isSelected) const Icon(Icons.check, size: 18, color: AppColors.primary),
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

  String _resolveTemplateDesc(String name, String fallback, AppLocalizations l10n) {
    if (name.contains('Full Body')) return l10n.templateFullBodyDesc;
    if (name.contains('Upper Body')) return l10n.templateUpperDesc;
    if (name.contains('Lower Body')) return l10n.templateLowerDesc;
    if (name.contains('Push Day')) return l10n.templatePushDesc;
    if (name.contains('Pull Day')) return l10n.templatePullDesc;
    return fallback;
  }
}
