import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/enums/set_type.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/exercise_personal_records.dart';
import '../../domain/services/one_rep_max_calculator.dart';
import 'plate_calculator_dialog.dart';

/// Interactive row representing an individual set within a workout exercise.
///
/// Features for pro athletes:
/// - Set type switching (Normal, Warm-up 'W', Drop set 'D', Failure 'F')
/// - Estimated 1RM metric preview (Epley formula)
/// - Integrated Plate Calculator shortcut on weight
/// - Golden glowing 🏆 PR badge when personal record is beaten
/// - Ghost hint for previous session performance
class SetRowWidget extends StatefulWidget {
  final SetLog setLog;
  final SetLog? previousSetLog;
  final ExercisePersonalRecords? personalRecords;
  final ValueChanged<bool> onToggleCompleted;
  final void Function(double? weight, int? reps, double? rpe, SetType setType)
      onUpdateValues;
  final VoidCallback onDelete;

  const SetRowWidget({
    super.key,
    required this.setLog,
    this.previousSetLog,
    this.personalRecords,
    required this.onToggleCompleted,
    required this.onUpdateValues,
    required this.onDelete,
  });

  @override
  State<SetRowWidget> createState() => _SetRowWidgetState();
}

class _SetRowWidgetState extends State<SetRowWidget> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.setLog.weightKg != null
          ? widget.setLog.weightKg!.toStringAsFixed(
              widget.setLog.weightKg! % 1 == 0 ? 0 : 1,
            )
          : '',
    );
    _repsController = TextEditingController(
      text: widget.setLog.reps != null ? widget.setLog.reps.toString() : '',
    );
  }

  @override
  void didUpdateWidget(covariant SetRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.setLog.weightKg != widget.setLog.weightKg &&
        !_weightController.selection.isValid) {
      _weightController.text = widget.setLog.weightKg != null
          ? widget.setLog.weightKg!.toStringAsFixed(
              widget.setLog.weightKg! % 1 == 0 ? 0 : 1,
            )
          : '';
    }
    if (oldWidget.setLog.reps != widget.setLog.reps &&
        !_repsController.selection.isValid) {
      _repsController.text =
          widget.setLog.reps != null ? widget.setLog.reps.toString() : '';
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _onFieldsChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 280), _commitFields);
  }

  void _commitFields() {
    final weight = double.tryParse(_weightController.text.trim());
    final reps = int.tryParse(_repsController.text.trim());
    widget.onUpdateValues(
      weight,
      reps,
      widget.setLog.rpe,
      widget.setLog.setType,
    );
  }

  void _changeSetType(SetType newType) {
    final weight = double.tryParse(_weightController.text.trim());
    final reps = int.tryParse(_repsController.text.trim());
    widget.onUpdateValues(
      weight,
      reps,
      widget.setLog.rpe,
      newType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCompleted = widget.setLog.isCompleted;
    final weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final reps = int.tryParse(_repsController.text.trim()) ?? 0;

    // Check PR status
    final prBadges = widget.personalRecords?.evaluateSet(
          weightKg: weight,
          reps: reps,
        ) ??
        const [];
    final isPr = prBadges.isNotEmpty;

    // Predicted 1RM
    final estimated1RM = (weight > 0 && reps > 0)
        ? OneRepMaxCalculator.calculate(weight: weight, reps: reps)
        : null;

    // Previous performance string (e.g., "80 kg x 8")
    final previousHint = widget.previousSetLog != null
        ? '${widget.previousSetLog!.weightKg ?? '-'} kg × ${widget.previousSetLog!.reps ?? '-'}'
        : '—';

    return Dismissible(
      key: ValueKey('set_${widget.setLog.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 16),
        color: AppColors.failure,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsetsDirectional.only(bottom: 6),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isCompleted
              ? (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.completedContainer.withValues(alpha: 0.4)
                  : AppColors.lightCompletedContainer)
              : AppColors.ofSurface(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCompleted
                ? (isPr ? const Color(0xFFFFD700) : AppColors.completed.withValues(alpha: 0.35))
                : AppColors.ofBorder(context),
            width: isPr && isCompleted ? 1.4 : 0.8,
          ),
          boxShadow: isPr && isCompleted
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                // 1. Set Number / Type Selector Badge
                _buildSetTypeBadge(context),
                const SizedBox(width: 8),

                // 2. Previous performance hint
                Expanded(
                  flex: 3,
                  child: Text(
                    previousHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ofTextSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Weight Input Field + Plate Calculator Shortcut
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.ofInputBackground(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.ofBorder(context),
                        width: 0.9,
                      ),
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        TextField(
                          controller: _weightController,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          style: AppTypography.ofMetricMedium(context).copyWith(
                            color: AppColors.ofTextPrimary(context),
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTypography.ofMetricMedium(context).copyWith(
                              color: AppColors.ofTextPlaceholder(context),
                              fontWeight: FontWeight.w600,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                          ),
                          onChanged: (_) => _onFieldsChanged(),
                        ),
                        // Quick Plate Calc Icon on Long Press / Tap
                        PositionedDirectional(
                          end: 2,
                          child: InkWell(
                            onTap: () {
                              PlateCalculatorDialog.show(
                                context,
                                initialWeight: weight,
                                onWeightApplied: (applied) {
                                  _weightController.text = applied.toStringAsFixed(
                                    applied % 1 == 0 ? 0 : 1,
                                  );
                                  _debounceTimer?.cancel();
                                  _commitFields();
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.calculate_outlined,
                                size: 14,
                                color: AppColors.ofTextTertiary(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 4. Reps Input Field
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.ofInputBackground(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.ofBorder(context),
                        width: 0.9,
                      ),
                    ),
                    child: TextField(
                      controller: _repsController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: AppTypography.ofMetricMedium(context).copyWith(
                        color: AppColors.ofTextPrimary(context),
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: AppTypography.ofMetricMedium(context).copyWith(
                          color: AppColors.ofTextPlaceholder(context),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                      ),
                      onChanged: (_) => _onFieldsChanged(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // 5. Completion Checkmark Button
                InkWell(
                  onTap: () {
                    if (_debounceTimer?.isActive ?? false) {
                      _debounceTimer?.cancel();
                      _commitFields();
                    }
                    final targetCompleted = !isCompleted;
                    if (targetCompleted && isPr) {
                      HapticFeedback.heavyImpact();
                    } else {
                      HapticFeedback.lightImpact();
                    }
                    widget.onToggleCompleted(targetCompleted);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? (isPr ? const Color(0xFFD4AF37) : AppColors.completed)
                          : AppColors.ofInputBackground(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCompleted
                            ? (isPr ? const Color(0xFFFFD700) : AppColors.completed)
                            : AppColors.ofBorder(context),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: isCompleted ? Colors.white : AppColors.ofTextTertiary(context),
                    ),
                  ),
                ),
              ],
            ),

            // Pro Metrics Row: PR Badge + Estimated 1RM
            if ((estimated1RM != null || isPr) && isCompleted)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 4, start: 40, end: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isPr)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 10)),
                            const SizedBox(width: 3),
                            Text(
                              l10n.personalRecord,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (estimated1RM != null)
                      Text(
                        '${l10n.estimatedOneRepMax}: ${estimated1RM.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetTypeBadge(BuildContext context) {
    Color badgeColor = AppColors.ofTextSecondary(context);
    String badgeLabel = widget.setLog.setNumber.toString();

    switch (widget.setLog.setType) {
      case SetType.warmup:
        badgeColor = AppColors.warmup;
        badgeLabel = 'W';
        break;
      case SetType.dropset:
        badgeColor = AppColors.dropset;
        badgeLabel = 'D';
        break;
      case SetType.failure:
        badgeColor = AppColors.failure;
        badgeLabel = 'F';
        break;
      case SetType.normal:
        badgeColor = widget.setLog.isCompleted
            ? AppColors.completed
            : AppColors.ofTextSecondary(context);
        badgeLabel = widget.setLog.setNumber.toString();
        break;
    }

    return PopupMenuButton<SetType>(
      tooltip: 'Set Type',
      color: AppColors.ofSurfaceElevated(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: _changeSetType,
      itemBuilder: (ctx) => [
        _buildPopupItem(context, SetType.normal, 'Normal', AppColors.primary),
        _buildPopupItem(context, SetType.warmup, 'Warm-up (W)', AppColors.warmup),
        _buildPopupItem(context, SetType.dropset, 'Drop Set (D)', AppColors.dropset),
        _buildPopupItem(context, SetType.failure, 'Failure (F)', AppColors.failure),
      ],
      child: Container(
        width: 32,
        height: 28,
        decoration: BoxDecoration(
          color: widget.setLog.setType != SetType.normal
              ? badgeColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          badgeLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: badgeColor,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<SetType> _buildPopupItem(
    BuildContext context,
    SetType type,
    String label,
    Color color,
  ) {
    final isSelected = widget.setLog.setType == type;
    return PopupMenuItem<SetType>(
      value: type,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? color : AppColors.ofTextPrimary(context),
              ),
            ),
          ),
          if (isSelected) Icon(Icons.check, size: 16, color: color),
        ],
      ),
    );
  }
}
