import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../../../core/enums/experience_level.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../workout/presentation/bloc/workout_session_bloc.dart';
import '../../../workout/presentation/bloc/workout_session_event.dart';
import '../../../workout/presentation/cubit/routines_cubit.dart';
import '../../domain/routine_recommender.dart';
import '../cubit/profile_cubit.dart';

/// Interactive, 3-step onboarding wizard matching an athlete's goals,
/// availability, and experience level with science-based pre-designed routines.
class AthleteOnboardingDialog extends StatefulWidget {
  final VoidCallback? onRoutineStarted;

  const AthleteOnboardingDialog({
    super.key,
    this.onRoutineStarted,
  });

  static Future<void> show(BuildContext context, {VoidCallback? onRoutineStarted}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: AthleteOnboardingDialog(onRoutineStarted: onRoutineStarted),
        ),
      ),
    );
  }

  @override
  State<AthleteOnboardingDialog> createState() => _AthleteOnboardingDialogState();
}

class _AthleteOnboardingDialogState extends State<AthleteOnboardingDialog> {
  int _currentStep = 0; // 0: Goal, 1: Days, 2: Level, 3: Result

  TrainingGoal _selectedGoal = TrainingGoal.hypertrophy;
  int _selectedDays = 4;
  ExperienceLevel _selectedLevel = ExperienceLevel.intermediate;

  RoutineRecommendation? _recommendation;

  void _calculateRecommendation() {
    setState(() {
      _recommendation = RoutineRecommender.match(
        goal: _selectedGoal,
        daysPerWeek: _selectedDays,
        experienceLevel: _selectedLevel,
      );
      _currentStep = 3;
    });
  }

  void _applyToProfile() {
    context.read<ProfileCubit>().updateProfileMetrics(
          weeklyWorkoutGoal: _selectedDays,
          experienceLevel: _selectedLevel,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 0) {
          setState(() => _currentStep--);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.86,
        decoration: BoxDecoration(
          color: AppColors.ofSurfaceElevated(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsetsDirectional.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.ofBorder(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header: Progress Indicator & Close
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.ofTextSecondary(context)),
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      onPressed: () => setState(() => _currentStep--),
                    ),
                  Expanded(child: _buildProgressStepper(context, l10n)),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.ofTextSecondary(context)),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.ofBorder(context), height: 1),

            // Step Body
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _buildStepContent(context, l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStepper(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        for (int i = 0; i < 3; i++) ...[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _currentStep > i
                  ? AppColors.secondary
                  : (_currentStep == i ? AppColors.primary : AppColors.ofSurface(context)),
              shape: BoxShape.circle,
              border: Border.all(
                color: _currentStep >= i ? AppColors.primary : AppColors.ofBorder(context),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: _currentStep > i
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _currentStep == i ? Colors.white : AppColors.ofTextTertiary(context),
                    ),
                  ),
          ),
          if (i < 2)
            Expanded(
              child: Container(
                height: 2,
                color: _currentStep > i ? AppColors.secondary : AppColors.ofBorder(context),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildStepContent(BuildContext context, AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildGoalStep(context, l10n);
      case 1:
        return _buildDaysStep(context, l10n);
      case 2:
        return _buildLevelStep(context, l10n);
      case 3:
      default:
        return _buildResultStep(context, l10n);
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 1: TRAINING GOAL
  // ---------------------------------------------------------------------------
  Widget _buildGoalStep(BuildContext context, AppLocalizations l10n) {
    return ListView(
      key: const ValueKey('step_0'),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
      children: [
        Text(l10n.stepTrainingGoal, style: AppTypography.ofTitleLarge(context)),
        const SizedBox(height: 4),
        Text(l10n.onboardingSubtitle, style: AppTypography.ofCaption(context)),
        const SizedBox(height: 20),
        _buildChoiceCard(
          context: context,
          title: l10n.goalHypertrophy,
          description: l10n.goalHypertrophyDesc,
          icon: Icons.fitness_center_rounded,
          isSelected: _selectedGoal == TrainingGoal.hypertrophy,
          onTap: () => setState(() => _selectedGoal = TrainingGoal.hypertrophy),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.goalStrength,
          description: l10n.goalStrengthDesc,
          icon: Icons.bolt_rounded,
          isSelected: _selectedGoal == TrainingGoal.strength,
          onTap: () => setState(() => _selectedGoal = TrainingGoal.strength),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.goalFitness,
          description: l10n.goalFitnessDesc,
          icon: Icons.favorite_rounded,
          isSelected: _selectedGoal == TrainingGoal.fitness,
          onTap: () => setState(() => _selectedGoal = TrainingGoal.fitness),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentStep = 1),
            child: Text(l10n.next),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: DAYS PER WEEK
  // ---------------------------------------------------------------------------
  Widget _buildDaysStep(BuildContext context, AppLocalizations l10n) {
    return ListView(
      key: const ValueKey('step_1'),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
      children: [
        Text(l10n.stepWeeklyAvailability, style: AppTypography.ofTitleLarge(context)),
        const SizedBox(height: 4),
        Text(
          l10n.daysPerWeek(_selectedDays),
          style: AppTypography.ofCaption(context).copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        _buildChoiceCard(
          context: context,
          title: l10n.daysPerWeek(3),
          description: 'Full-body frequency 3x per week. Optimal for fast recovery and baseline strength.',
          icon: Icons.calendar_today_rounded,
          isSelected: _selectedDays == 3,
          onTap: () => setState(() => _selectedDays = 3),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.daysPerWeek(4),
          description: 'Upper / Lower 4-day split. The scientific gold standard for balanced volume.',
          icon: Icons.calendar_view_week_rounded,
          isSelected: _selectedDays == 4,
          onTap: () => setState(() => _selectedDays = 4),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.daysPerWeek(5),
          description: 'Push / Pull / Legs 5-day cycle. Maximum specialization and hypertrophy stimulus.',
          icon: Icons.date_range_rounded,
          isSelected: _selectedDays == 5,
          onTap: () => setState(() => _selectedDays = 5),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: Text(l10n.back),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 2),
                child: Text(l10n.next),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: EXPERIENCE LEVEL
  // ---------------------------------------------------------------------------
  Widget _buildLevelStep(BuildContext context, AppLocalizations l10n) {
    return ListView(
      key: const ValueKey('step_2'),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
      children: [
        Text(l10n.stepExperienceLevel, style: AppTypography.ofTitleLarge(context)),
        const SizedBox(height: 4),
        Text(l10n.onboardingSubtitle, style: AppTypography.ofCaption(context)),
        const SizedBox(height: 20),
        _buildChoiceCard(
          context: context,
          title: l10n.levelBeginner,
          description: l10n.levelBeginnerDesc,
          icon: Icons.school_rounded,
          isSelected: _selectedLevel == ExperienceLevel.beginner,
          onTap: () => setState(() => _selectedLevel = ExperienceLevel.beginner),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.levelIntermediate,
          description: l10n.levelIntermediateDesc,
          icon: Icons.trending_up_rounded,
          isSelected: _selectedLevel == ExperienceLevel.intermediate,
          onTap: () => setState(() => _selectedLevel = ExperienceLevel.intermediate),
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          context: context,
          title: l10n.levelAdvanced,
          description: l10n.levelAdvancedDesc,
          icon: Icons.military_tech_rounded,
          isSelected: _selectedLevel == ExperienceLevel.advanced,
          onTap: () => setState(() => _selectedLevel = ExperienceLevel.advanced),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 1),
                child: Text(l10n.back),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _calculateRecommendation,
                child: Text(l10n.findIdealProgram),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 4: RECOMMENDATION RESULT
  // ---------------------------------------------------------------------------
  Widget _buildResultStep(BuildContext context, AppLocalizations l10n) {
    final rec = _recommendation;
    if (rec == null) return const SizedBox.shrink();

    // Find the corresponding pre-designed template from RoutinesCubit
    // Find the corresponding pre-designed template from RoutinesCubit
    final templates = context.watch<RoutinesCubit>().state.templates;
    TemplateDetail? matchedTemplate;
    final keyword = rec.templateSlug == 'full_body_split'
        ? 'Full Body'
        : (rec.templateSlug == 'upper_body_power'
            ? 'Upper Body'
            : (rec.templateSlug == 'pull_strength'
                ? 'Pull Day'
                : (rec.templateSlug == 'push_hypertrophy' ? 'Push Day' : 'Full Body')));

    for (final t in templates) {
      if (t.template.name.toLowerCase().contains(keyword.toLowerCase())) {
        matchedTemplate = t;
        break;
      }
    }
    // Fallback if search falls back to first template
    matchedTemplate ??= templates.isNotEmpty ? templates.first : null;

    final goalName = rec.goal == TrainingGoal.hypertrophy
        ? l10n.goalHypertrophy
        : (rec.goal == TrainingGoal.strength ? l10n.goalStrength : l10n.goalFitness);

    return ListView(
      key: const ValueKey('step_3'),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 36),
      children: [
        // Trophy / Match Header
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.prGold, const Color(0xFFD97706)],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.prGold.withAlpha(80),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            l10n.recommendedRoutineTitle,
            style: AppTypography.ofTitleLarge(context),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Recommended Routine Card
        Container(
          padding: const EdgeInsetsDirectional.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary, width: 1.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.daysPerWeek(rec.recommendedDaysPerWeek),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, color: AppColors.prGold, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                matchedTemplate != null ? matchedTemplate.template.name : rec.routineName,
                style: AppTypography.ofTitleLarge(context).copyWith(fontSize: 19, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.routineMatchedReason(rec.recommendedDaysPerWeek, goalName),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Scientific Rationale Box
        Container(
          padding: const EdgeInsetsDirectional.all(14),
          decoration: BoxDecoration(
            color: AppColors.ofSurface(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.science_outlined, color: AppColors.secondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  rec.rationale,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.ofTextSecondary(context),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Start routine button (if matched)
        if (matchedTemplate != null) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text(l10n.startRecommendedRoutine),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _applyToProfile();
                context.read<WorkoutSessionBloc>().add(
                      StartSessionFromTemplateRequested(matchedTemplate!),
                    );
                Navigator.of(context).pop();
                widget.onRoutineStarted?.call();
              },
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Apply and save button
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
            label: Text(l10n.applyAndSave),
            onPressed: () {
              _applyToProfile();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.onboardingDone),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF132238) : AppColors.ofPrimaryContainer(context))
              : AppColors.ofSurface(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.ofBorder(context),
            width: isSelected ? 1.6 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.ofSurfaceElevated(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.ofTextSecondary(context),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.primary)
                          : AppColors.ofTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? (isDark ? Colors.white70 : AppColors.ofTextSecondary(context))
                          : AppColors.ofTextSecondary(context),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : AppColors.ofTextTertiary(context),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
