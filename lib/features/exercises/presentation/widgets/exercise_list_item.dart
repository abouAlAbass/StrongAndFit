import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'exercise_guide_sheet.dart';

/// Reusable exercise list item displaying localized titles, category badges, and RTL layout.
class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        margin: const EdgeInsetsDirectional.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Row(
          children: [
            // Left/Start Accent Indicator for muscle group
            Container(
              width: 4,
              height: 42,
              decoration: BoxDecoration(
                color: exercise.isCustom ? AppColors.secondary : AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),

            // Exercise Title and Tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.localizedName(context),
                    style: AppTypography.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Muscle Group Tag
                      _buildTag(
                        label: exercise.localizedMuscleGroup(context),
                        color: AppColors.primaryContainer,
                        textColor: AppColors.primary,
                      ),
                      const SizedBox(width: 6),

                      // Equipment Tag
                      _buildTag(
                        label: exercise.localizedEquipment(context),
                        color: AppColors.surfaceElevated,
                        textColor: AppColors.textSecondary,
                      ),

                      if (exercise.isCustom) ...[
                        const SizedBox(width: 6),
                        _buildTag(
                          label: l10n.customExercise,
                          color: const Color(0xFF2E2413),
                          textColor: AppColors.warmup,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.textSecondary),
              tooltip: l10n.exerciseGuide,
              onPressed: () {
                ExerciseGuideSheet.show(
                  context,
                  slug: exercise.slug,
                  exerciseName: exercise.localizedName(context),
                );
              },
            ),
            if (trailing != null)
              trailing!
            else
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
