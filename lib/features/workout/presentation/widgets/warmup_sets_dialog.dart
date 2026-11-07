import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/services/warmup_calculator.dart';

/// Modal dialog helping athletes safely warm up to their target working weight.
class WarmupSetsDialog extends StatefulWidget {
  final double initialWorkingWeight;
  final ValueChanged<List<WarmupStep>> onAddWarmupSets;

  const WarmupSetsDialog({
    super.key,
    required this.initialWorkingWeight,
    required this.onAddWarmupSets,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialWorkingWeight,
    required ValueChanged<List<WarmupStep>> onAddWarmupSets,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.card,
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => WarmupSetsDialog(
        initialWorkingWeight: initialWorkingWeight,
        onAddWarmupSets: onAddWarmupSets,
      ),
    );
  }

  @override
  State<WarmupSetsDialog> createState() => _WarmupSetsDialogState();
}

class _WarmupSetsDialogState extends State<WarmupSetsDialog> {
  late double _workingWeight;

  @override
  void initState() {
    super.initState();
    _workingWeight = widget.initialWorkingWeight > 20.0 ? widget.initialWorkingWeight : 80.0;
  }

  void _adjust(double delta) {
    setState(() {
      _workingWeight = (_workingWeight + delta).clamp(25.0, 500.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = WarmupCalculator.generate(workingWeightKg: _workingWeight);

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grab Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.fireplace_rounded, color: AppColors.warmup),
                  const SizedBox(width: 8),
                  Text('Warm-up Calculator', style: AppTypography.titleLarge),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Working Weight Target Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TARGET WORK SET', style: AppTypography.caption),
                    const SizedBox(height: 2),
                    Text(
                      '${_workingWeight.toStringAsFixed(1)} kg',
                      style: AppTypography.metricLarge.copyWith(fontSize: 26),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _StepButton(label: '-5', onTap: () => _adjust(-5)),
                    const SizedBox(width: 6),
                    _StepButton(label: '+5', onTap: () => _adjust(5)),
                    const SizedBox(width: 6),
                    _StepButton(label: '+10', onTap: () => _adjust(10)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Warmup Steps List
          ...steps.map((step) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.warmup.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'W${step.stepNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warmup,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${step.weightKg} kg × ${step.reps} reps',
                          style: AppTypography.metricMedium.copyWith(fontSize: 15),
                        ),
                        Text(
                          step.label,
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${step.percentage}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // Add to exercise button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_task_rounded, size: 20),
              label: Text('Add ${steps.length} Warmup Sets to Exercise'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warmup,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                widget.onAddWarmupSets(steps);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _StepButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
