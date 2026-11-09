import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Modal bottom sheet allowing strength athletes to calibrate Rate of Perceived Exertion (RPE)
/// and Repetitions In Reserve (RIR) based on scientific auto-regulation scales.
class RpePickerDialog extends StatelessWidget {
  final double? currentRpe;
  final ValueChanged<double?> onSelected;

  const RpePickerDialog({super.key, this.currentRpe, required this.onSelected});

  static Future<void> show(
    BuildContext context, {
    double? currentRpe,
    required ValueChanged<double?> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: RpePickerDialog(
            currentRpe: currentRpe,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }

  static const List<({double rpe, double rir, String labelFr, String labelEn})>
  rpeScales = [
    (
      rpe: 10.0,
      rir: 0.0,
      labelFr: 'Échec musculaire absolu',
      labelEn: 'Absolute failure, no reps left',
    ),
    (
      rpe: 9.5,
      rir: 0.5,
      labelFr: 'Peut-être 1 rep non garantie',
      labelEn: 'Maybe 1 rep left',
    ),
    (
      rpe: 9.0,
      rir: 1.0,
      labelFr: '1 rep restante en réserve',
      labelEn: '1 rep left in reserve',
    ),
    (
      rpe: 8.5,
      rir: 1.5,
      labelFr: '1 à 2 reps en réserve',
      labelEn: '1-2 reps left in reserve',
    ),
    (
      rpe: 8.0,
      rir: 2.0,
      labelFr: '2 reps en réserve (Zone optimale)',
      labelEn: '2 reps left (Hypertrophy sweetspot)',
    ),
    (
      rpe: 7.5,
      rir: 2.5,
      labelFr: '2 à 3 reps en réserve',
      labelEn: '2-3 reps left in reserve',
    ),
    (
      rpe: 7.0,
      rir: 3.0,
      labelFr: '3 reps en réserve (Charge vive)',
      labelEn: '3 reps left (Solid speed)',
    ),
    (
      rpe: 6.5,
      rir: 3.5,
      labelFr: '3 à 4 reps en réserve',
      labelEn: '3-4 reps left in reserve',
    ),
    (
      rpe: 6.0,
      rir: 4.0,
      labelFr: '4+ reps (Échauffement / Vitesse)',
      labelEn: '4+ reps (Warm-up / Speed)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFrench = Localizations.localeOf(context).languageCode == 'fr';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.ofBorder(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.rateOfPerceivedExertion,
                          style: AppTypography.ofTitleLarge(
                            context,
                          ).copyWith(fontSize: 17),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.rpeSubtitle,
                          style: AppTypography.ofCaption(context),
                        ),
                      ],
                    ),
                  ),
                  if (currentRpe != null)
                    TextButton.icon(
                      icon: const Icon(
                        Icons.clear_rounded,
                        size: 16,
                        color: AppColors.failure,
                      ),
                      label: Text(
                        l10n.clearRpe,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.failure,
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onSelected(null);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // RPE Grid List
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: rpeScales.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final item = rpeScales[index];
                    final isSelected = currentRpe == item.rpe;
                    final color = _getColorForRpe(item.rpe);

                    return InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onSelected(isSelected ? null : item.rpe);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withAlpha(35)
                              : AppColors.ofSurface(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? color
                                : AppColors.ofBorder(context),
                            width: isSelected ? 1.6 : 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? color : color.withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '@${item.rpe % 1 == 0 ? item.rpe.toInt() : item.rpe}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? Colors.white : color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.rir.toInt() == item.rir ? item.rir.toInt() : item.rir} RIR',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ofTextPrimary(context),
                                    ),
                                  ),
                                  Text(
                                    isFrench ? item.labelFr : item.labelEn,
                                    style: AppTypography.ofCaption(context),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: color,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForRpe(double rpe) {
    if (rpe >= 9.5) return AppColors.failure; // Red
    if (rpe >= 8.5) return const Color(0xFFF97316); // Orange
    if (rpe >= 7.5) return const Color(0xFFEAB308); // Gold/Amber
    if (rpe >= 7.0) return const Color(0xFF10B981); // Emerald
    return const Color(0xFF06B6D4); // Cyan
  }
}
