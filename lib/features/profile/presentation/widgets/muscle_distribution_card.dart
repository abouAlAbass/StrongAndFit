import 'package:flutter/material.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Card displaying horizontal progress bars for completed sets per muscle group.
class MuscleDistributionCard extends StatelessWidget {
  final Map<MuscleGroup, int> distribution;

  const MuscleDistributionCard({
    super.key,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalSets = distribution.values.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsetsDirectional.all(18),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.muscleDistribution,
                style: AppTypography.ofTitleMedium(context),
              ),
              Text(
                '$totalSets ${l10n.sets.toLowerCase()}',
                style: AppTypography.ofCaption(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...MuscleGroup.values.map((group) {
            final count = distribution[group] ?? 0;
            final ratio = totalSets > 0 ? (count / totalSets).clamp(0.0, 1.0) : 0.0;
            final percentage = (ratio * 100).round();

            return Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        group.localizedName(context),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ofTextPrimary(context),
                        ),
                      ),
                      Text(
                        '$count ${l10n.sets.toLowerCase()} ($percentage%)',
                        style: AppTypography.ofCaption(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: AppColors.ofInputBackground(context),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _colorForGroup(group),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _colorForGroup(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest:
        return AppColors.primary;
      case MuscleGroup.back:
        return AppColors.secondary;
      case MuscleGroup.legs:
        return AppColors.completed;
      case MuscleGroup.shoulders:
        return AppColors.warmup;
      case MuscleGroup.arms:
        return AppColors.dropset;
      case MuscleGroup.core:
        return AppColors.prGold;
    }
  }
}
