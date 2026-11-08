import 'package:flutter/material.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/services/plate_calculator.dart';

/// Interactive modal sheet visualizing Olympic barbell plate loading.
class PlateCalculatorDialog extends StatefulWidget {
  final double initialWeight;
  final ValueChanged<double>? onWeightApplied;

  const PlateCalculatorDialog({
    super.key,
    required this.initialWeight,
    this.onWeightApplied,
  });

  static Future<void> show(
    BuildContext context, {
    required double initialWeight,
    ValueChanged<double>? onWeightApplied,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.ofCard(context),
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => PlateCalculatorDialog(
        initialWeight: initialWeight,
        onWeightApplied: onWeightApplied,
      ),
    );
  }

  @override
  State<PlateCalculatorDialog> createState() => _PlateCalculatorDialogState();
}

class _PlateCalculatorDialogState extends State<PlateCalculatorDialog> {
  late double _targetWeight;
  double _barWeight = 20.0;

  @override
  void initState() {
    super.initState();
    _targetWeight = widget.initialWeight > 0 ? widget.initialWeight : 60.0;
  }

  void _adjustWeight(double delta) {
    setState(() {
      _targetWeight = (_targetWeight + delta).clamp(_barWeight, 500.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = PlateCalculator.calculate(
      targetWeight: _targetWeight,
      barWeight: _barWeight,
    );

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
              color: AppColors.ofBorder(context),
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
                  const Icon(Icons.fitness_center_rounded, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.plateCalculator,
                    style: AppTypography.ofTitleLarge(context),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: AppColors.ofTextSecondary(context)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Weight Display & Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.ofSurface(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.weight.toUpperCase(),
                      style: AppTypography.ofCaption(context).copyWith(letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${result.actualTotalWeight.toStringAsFixed(1)} kg',
                      style: AppTypography.ofMetricLarge(context).copyWith(fontSize: 28),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _StepButton(
                      label: '-5',
                      onTap: () => _adjustWeight(-5),
                    ),
                    const SizedBox(width: 6),
                    _StepButton(
                      label: '-2.5',
                      onTap: () => _adjustWeight(-2.5),
                    ),
                    const SizedBox(width: 6),
                    _StepButton(
                      label: '+2.5',
                      onTap: () => _adjustWeight(2.5),
                    ),
                    const SizedBox(width: 6),
                    _StepButton(
                      label: '+5',
                      onTap: () => _adjustWeight(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Barbell Weight Selection
          Row(
            children: [
              Text(
                '${l10n.barWeight}:',
                style: AppTypography.ofBodySecondary(context),
              ),
              const SizedBox(width: 12),
              ...[20.0, 15.0, 10.0].map((bar) {
                final isSelected = _barWeight == bar;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text('${bar.toInt()} kg'),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.ofPrimaryContainer(context),
                    backgroundColor: AppColors.ofSurface(context),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.ofBorder(context),
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.ofTextPrimary(context),
                    ),
                    onSelected: (_) => setState(() => _barWeight = bar),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Visual Barbell Sleeve Drawing
          _BarbellSleeveVisual(
            plates: result.platesPerSide,
            weightPerSide: result.weightPerSide,
          ),
          const SizedBox(height: 20),

          // Plates Count Grid Breakdown
          _PlateBreakdownList(plates: result.platesPerSide),
          const SizedBox(height: 24),

          // Action Apply Button
          if (widget.onWeightApplied != null)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_rounded, size: 20),
                label: Text('Apply ${result.actualTotalWeight.toStringAsFixed(1)} kg to Set'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  widget.onWeightApplied!(result.actualTotalWeight);
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
          color: AppColors.ofSurfaceElevated(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.ofTextPrimary(context),
          ),
        ),
      ),
    );
  }
}

/// Visual schematic of an Olympic barbell sleeve loaded with plates.
class _BarbellSleeveVisual extends StatelessWidget {
  final List<PlateSpec> plates;
  final double weightPerSide;

  const _BarbellSleeveVisual({
    required this.plates,
    required this.weightPerSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
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
                '${(AppLocalizations.of(context)?.perSide ?? "PER SIDE").toUpperCase()}: ${weightPerSide.toStringAsFixed(2)} kg',
                style: AppTypography.ofCaption(context).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: AppColors.secondary,
                ),
              ),
              Text(
                '${plates.length} plates',
                style: AppTypography.ofCaption(context),
              ),
            ],
          ),
          const Spacer(),
          // Barbell Graphic
          SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Steel Bar shaft & Collar
                Row(
                  children: [
                    // Inner Bar shaft
                    Container(
                      width: 30,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                      ),
                    ),
                    // Collar Ring
                    Container(
                      width: 14,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black45, width: 1),
                      ),
                    ),
                    // Outer Sleeve
                    Expanded(
                      child: Container(
                        height: 20,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                // Loaded Plates on sleeve
                PositionedDirectional(
                  start: 46,
                  child: Row(
                    children: plates.map((plate) {
                      final heightRatio = (plate.weightKg / 25.0).clamp(0.4, 1.0);
                      final plateHeight = 68.0 * heightRatio;
                      final plateWidth = plate.weightKg >= 15.0 ? 16.0 : (plate.weightKg >= 5 ? 12.0 : 8.0);

                      return Container(
                        width: plateWidth,
                        height: plateHeight,
                        margin: const EdgeInsetsDirectional.only(end: 3),
                        decoration: BoxDecoration(
                          color: plate.color,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.black38, width: 0.8),
                          boxShadow: [
                            BoxShadow(
                              color: plate.color.withValues(alpha: 0.35),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            plate.weightKg >= 10 ? plate.label : '',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: plate.weightKg == 5.0 ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlateBreakdownList extends StatelessWidget {
  final List<PlateSpec> plates;

  const _PlateBreakdownList({required this.plates});

  @override
  Widget build(BuildContext context) {
    if (plates.isEmpty) {
      return Center(
        child: Text(
          'Load bar only (no plates needed)',
          style: AppTypography.ofBodySecondary(context),
        ),
      );
    }

    // Aggregate plate counts
    final counts = <double, int>{};
    final specs = <double, PlateSpec>{};
    for (final p in plates) {
      counts[p.weightKg] = (counts[p.weightKg] ?? 0) + 1;
      specs[p.weightKg] = p;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: counts.entries.map((e) {
        final spec = specs[e.key]!;
        final count = e.value;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.ofSurface(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: spec.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${count}x ${spec.weightKg} kg',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ofTextPrimary(context),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
