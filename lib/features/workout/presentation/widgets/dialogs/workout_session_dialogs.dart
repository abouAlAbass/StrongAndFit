import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../../core/l10n/generated/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../exercises/presentation/widgets/exercise_guide_sheet.dart';
import '../../../domain/models/workout_session_detail.dart';
import '../../bloc/workout_session_bloc.dart';
import '../../bloc/workout_session_event.dart';
import '../plate_calculator_dialog.dart';
import '../warmup_sets_dialog.dart';

/// Confirmation dialog for discarding an active workout session.
class DiscardWorkoutDialog extends StatelessWidget {
  const DiscardWorkoutDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<WorkoutSessionBloc>(),
        child: const DiscardWorkoutDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.ofCard(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.discardDialogTitle,
        style: AppTypography.ofTitleLarge(context),
      ),
      content: Text(
        l10n.discardDialogMessage,
        style: AppTypography.ofBodySecondary(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.failure),
          onPressed: () {
            final bloc = context.read<WorkoutSessionBloc>();
            final rootNav = Navigator.of(context);
            Navigator.pop(context);
            bloc.add(const DiscardSessionRequested());
            if (rootNav.canPop()) {
              rootNav.pop();
            }
          },
          child: Text(l10n.discard),
        ),
      ],
    );
  }
}

/// Modal bottom sheet displaying contextual actions for an exercise during a session
/// (technique guide, plate calculator, warmup sets generator, superset link/unlink, delete).
class ExerciseSessionOptionsSheet {
  ExerciseSessionOptionsSheet._();

  static Future<void> show(
    BuildContext context, {
    required WorkoutExerciseDetail item,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final lastWeight = item.sets.isNotEmpty && item.sets.last.weightKg != null
        ? item.sets.last.weightKg!
        : 60.0;

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.ofSurfaceElevated(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.menu_book_rounded,
                color: AppColors.secondary,
              ),
              title: Text(
                l10n.exerciseGuide,
                style: AppTypography.ofBody(context),
              ),
              subtitle: Text(
                l10n.techniqueGuide,
                style: AppTypography.ofCaption(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ExerciseGuideSheet.show(
                  context,
                  slug: item.exercise.slug,
                  exerciseName: item.exercise.localizedName(context),
                );
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                l10n.plateCalculator,
                style: AppTypography.ofBody(context),
              ),
              subtitle: Text(
                '${l10n.barWeight}: 20 kg',
                style: AppTypography.ofCaption(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                PlateCalculatorDialog.show(context, initialWeight: lastWeight);
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.fireplace_rounded,
                color: AppColors.warmup,
              ),
              title: Text(
                l10n.warmupCalculator,
                style: AppTypography.ofBody(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                WarmupSetsDialog.show(
                  context,
                  initialWorkingWeight: lastWeight,
                  onAddWarmupSets: (steps) {
                    context.read<WorkoutSessionBloc>().add(
                      InsertWarmupSetsRequested(
                        workoutExerciseId: item.workoutExercise.id,
                        steps: steps
                            .map((s) => (weightKg: s.weightKg, reps: s.reps))
                            .toList(),
                      ),
                    );
                  },
                );
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            if (item.workoutExercise.supersetGroupId != null)
              ListTile(
                leading: const Icon(
                  Icons.link_off_rounded,
                  color: Color(0xFF8B5CF6),
                ),
                title: Text(
                  l10n.unlinkSuperset,
                  style: AppTypography.ofBody(context),
                ),
                subtitle: Text(
                  l10n.supersetUnlinked,
                  style: AppTypography.ofCaption(context),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<WorkoutSessionBloc>().add(
                    SetExerciseSupersetRequested(
                      workoutExerciseId: item.workoutExercise.id,
                      supersetGroupId: null,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.supersetUnlinked),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )
            else
              ListTile(
                leading: const Icon(
                  Icons.link_rounded,
                  color: Color(0xFF8B5CF6),
                ),
                title: Text(
                  l10n.createSuperset,
                  style: AppTypography.ofBody(context),
                ),
                subtitle: Text(
                  l10n.linkWithNext,
                  style: AppTypography.ofCaption(context),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _linkExerciseInSuperset(context, item);
                },
              ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.failure,
              ),
              title: Text(
                l10n.delete,
                style: const TextStyle(color: AppColors.failure),
              ),
              onTap: () {
                Navigator.pop(ctx);
                showDialog(
                  context: context,
                  builder: (dialogCtx) => AlertDialog(
                    backgroundColor: AppColors.ofCard(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      l10n.deleteExerciseConfirmTitle,
                      style: AppTypography.ofTitleLarge(context),
                    ),
                    content: Text(
                      l10n.deleteExerciseConfirmMessage,
                      style: AppTypography.ofBodySecondary(context),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogCtx),
                        child: Text(l10n.cancel),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.failure,
                        ),
                        onPressed: () {
                          Navigator.pop(dialogCtx);
                          context.read<WorkoutSessionBloc>().add(
                            DeleteExerciseRequested(item.workoutExercise.id),
                          );
                        },
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _linkExerciseInSuperset(
    BuildContext context,
    WorkoutExerciseDetail item,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<WorkoutSessionBloc>().state;
    final detail = state.detail;
    if (detail == null) return;

    final currentIndex = detail.exercises.indexWhere(
      (e) => e.workoutExercise.id == item.workoutExercise.id,
    );
    if (currentIndex == -1) return;

    int maxGroupId = 0;
    for (final e in detail.exercises) {
      final gid = e.workoutExercise.supersetGroupId;
      if (gid != null && gid > maxGroupId) {
        maxGroupId = gid;
      }
    }
    final targetGroupId = maxGroupId + 1;

    context.read<WorkoutSessionBloc>().add(
      SetExerciseSupersetRequested(
        workoutExerciseId: item.workoutExercise.id,
        supersetGroupId: targetGroupId,
      ),
    );

    if (currentIndex + 1 < detail.exercises.length) {
      final nextExercise = detail.exercises[currentIndex + 1];
      context.read<WorkoutSessionBloc>().add(
        SetExerciseSupersetRequested(
          workoutExerciseId: nextExercise.workoutExercise.id,
          supersetGroupId: targetGroupId,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.supersetLinked),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Language switcher menu button used in the session AppBar.
class SessionLanguageMenu extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const SessionLanguageMenu({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: AppColors.ofTextPrimary(context)),
      color: AppColors.ofSurfaceElevated(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (code) => onLocaleChanged(Locale(code)),
      itemBuilder: (ctx) => [
        _buildPopupItem(
          context,
          'ar',
          'العربية',
          currentLocale.languageCode == 'ar',
        ),
        _buildPopupItem(
          context,
          'en',
          'English',
          currentLocale.languageCode == 'en',
        ),
        _buildPopupItem(
          context,
          'fr',
          'Français',
          currentLocale.languageCode == 'fr',
        ),
      ],
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
}
