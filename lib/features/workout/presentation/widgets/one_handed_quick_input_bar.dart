import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/workout_session_detail.dart';
import 'plate_calculator_dialog.dart';
import 'rpe_picker_dialog.dart';

/// One-Handed Fast Input Bar (Zone Ergonomique du Pouce)
///
/// Designed by mobile UX and strength coaches for frictionless workout logging:
/// - Placed in the lower 35% thumb-reachable screen zone
/// - Touch targets >= 44x44dp for sweaty, chalky hands
/// - Fast plate steppers (+1, +2.5, +5, +10 kg / -1, -2.5, -5 kg)
/// - Rep steppers (-1, +1, +2)
/// - 1-tap autofill from previous performance
/// - Giant one-thumb completion button triggering haptic feedback & auto rest timer
class OneHandedQuickInputBar extends StatefulWidget {
  final WorkoutExerciseDetail exerciseItem;
  final SetLog setLog;
  final SetLog? previousSetLog;
  final bool isPr;
  final void Function(double? weight, int? reps, [double? rpe]) onUpdateValues;
  final ValueChanged<bool> onToggleCompleted;
  final VoidCallback onNextSet;

  const OneHandedQuickInputBar({
    super.key,
    required this.exerciseItem,
    required this.setLog,
    this.previousSetLog,
    this.isPr = false,
    required this.onUpdateValues,
    required this.onToggleCompleted,
    required this.onNextSet,
  });

  @override
  State<OneHandedQuickInputBar> createState() => _OneHandedQuickInputBarState();
}

class _OneHandedQuickInputBarState extends State<OneHandedQuickInputBar> {
  bool _isExpanded = true;

  double get _currentWeight => widget.setLog.weightKg ?? 0.0;
  int get _currentReps => widget.setLog.reps ?? 0;

  void _adjustWeight(double delta) {
    HapticFeedback.selectionClick();
    final newWeight = (_currentWeight + delta).clamp(0.0, 999.0);
    // Round to 1 decimal place to prevent IEEE 754 precision issues
    final rounded = double.parse(newWeight.toStringAsFixed(1));
    widget.onUpdateValues(rounded, widget.setLog.reps, widget.setLog.rpe);
  }

  void _adjustReps(int delta) {
    HapticFeedback.selectionClick();
    final newReps = (_currentReps + delta).clamp(0, 999);
    widget.onUpdateValues(widget.setLog.weightKg, newReps, widget.setLog.rpe);
  }

  void _copyPreviousPerformance() {
    if (widget.previousSetLog == null) return;
    HapticFeedback.mediumImpact();
    widget.onUpdateValues(
      widget.previousSetLog!.weightKg,
      widget.previousSetLog!.reps,
      widget.previousSetLog!.rpe,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = widget.setLog.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 30),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: widget.isPr ? const Color(0xFFFFD700) : AppColors.primary.withAlpha(120),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Header Drag / Context Strip
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              HapticFeedback.lightImpact();
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 12, 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${l10n.set} ${widget.setLog.setNumber}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.exerciseItem.exercise.localizedName(context),
                      style: AppTypography.ofTitleMedium(context).copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Previous ghost performance pill (1-tap copy)
                  if (widget.previousSetLog != null &&
                      (widget.previousSetLog!.weightKg != null || widget.previousSetLog!.reps != null))
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 6),
                      child: ActionChip(
                        avatar: const Icon(Icons.copy_rounded, size: 13, color: AppColors.secondary),
                        label: Text(
                          '${widget.previousSetLog!.weightKg ?? 0}kg × ${widget.previousSetLog!.reps ?? 0}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: AppColors.ofSurface(context),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        onPressed: _copyPreviousPerformance,
                        tooltip: l10n.copyPrevious,
                      ),
                    ),
                  // RPE Quick Selector Chip
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: ActionChip(
                      avatar: Icon(
                        Icons.speed_rounded,
                        size: 14,
                        color: widget.setLog.rpe != null
                            ? AppColors.secondary
                            : AppColors.ofTextTertiary(context),
                      ),
                      label: Text(
                        widget.setLog.rpe != null ? '@${widget.setLog.rpe}' : 'RPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: widget.setLog.rpe != null
                              ? AppColors.secondary
                              : AppColors.ofTextSecondary(context),
                        ),
                      ),
                      backgroundColor: AppColors.ofSurface(context),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        RpePickerDialog.show(
                          context,
                          currentRpe: widget.setLog.rpe,
                          onSelected: (newRpe) {
                            widget.onUpdateValues(
                              widget.setLog.weightKg,
                              widget.setLog.reps,
                              newRpe,
                            );
                          },
                        );
                      },
                      tooltip: l10n.rateOfPerceivedExertion,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                    color: AppColors.ofTextSecondary(context),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 2. Weight and Reps Stepper Controls in Reachable Thumb Zone
                  Row(
                    children: [
                      // --- WEIGHT CONTROLLER ---
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.ofInputBackground(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.quickAdjustWeight.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ofTextSecondary(context),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      PlateCalculatorDialog.show(
                                        context,
                                        initialWeight: _currentWeight,
                                        onWeightApplied: (applied) {
                                          widget.onUpdateValues(applied, widget.setLog.reps);
                                        },
                                      );
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                      child: Icon(Icons.calculate_outlined, size: 15, color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  '${_currentWeight % 1 == 0 ? _currentWeight.toInt() : _currentWeight} kg',
                                  style: AppTypography.ofTitleLarge(context).copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Fast weight chips
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStepperButton(label: '-5', onTap: () => _adjustWeight(-5.0)),
                                  _buildStepperButton(label: '-2.5', onTap: () => _adjustWeight(-2.5)),
                                  _buildStepperButton(label: '+2.5', onTap: () => _adjustWeight(2.5), isPositive: true),
                                  _buildStepperButton(label: '+5', onTap: () => _adjustWeight(5.0), isPositive: true),
                                  _buildStepperButton(label: '+10', onTap: () => _adjustWeight(10.0), isPositive: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // --- REPS CONTROLLER ---
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.ofInputBackground(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.quickAdjustReps.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ofTextSecondary(context),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: Text(
                                  '$_currentReps reps',
                                  style: AppTypography.ofTitleLarge(context).copyWith(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Fast rep chips
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStepperButton(label: '-1', onTap: () => _adjustReps(-1)),
                                  _buildStepperButton(label: '+1', onTap: () => _adjustReps(1), isPositive: true),
                                  _buildStepperButton(label: '+2', onTap: () => _adjustReps(2), isPositive: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 3. Huge One-Thumb Validation Button ("Valider la série ✓")
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isCompleted ? Icons.check_circle_rounded : Icons.check_rounded,
                        size: 22,
                        color: Colors.white,
                      ),
                      label: Text(
                        isCompleted ? '${l10n.validateSet} ✓' : l10n.validateSet,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted
                            ? (widget.isPr ? const Color(0xFFD4AF37) : AppColors.completed)
                            : AppColors.primary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final target = !isCompleted;
                        if (target && widget.isPr) {
                          HapticFeedback.heavyImpact();
                        } else {
                          HapticFeedback.mediumImpact();
                        }
                        widget.onToggleCompleted(target);
                        if (target) {
                          widget.onNextSet();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepperButton({
    required String label,
    required VoidCallback onTap,
    bool isPositive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 6),
          constraints: const BoxConstraints(minWidth: 32),
          decoration: BoxDecoration(
            color: isPositive ? AppColors.primary.withAlpha(25) : AppColors.ofSurface(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPositive ? AppColors.primary.withAlpha(80) : AppColors.ofBorder(context),
              width: 0.8,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isPositive ? AppColors.primary : AppColors.ofTextPrimary(context),
            ),
          ),
        ),
      ),
    );
  }
}
