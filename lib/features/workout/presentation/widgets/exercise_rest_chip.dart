import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/rest_timer_cubit.dart';
import '../cubit/rest_timer_state.dart';
import 'rest_timer_dialog.dart';

/// Compact chip on each exercise card showing (and editing) its rest between
/// sets. A custom value is highlighted; otherwise the global default is shown.
class ExerciseRestChip extends StatelessWidget {
  final Exercise exercise;

  const ExerciseRestChip({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final defaultSeconds = context.select<RestTimerCubit, int>(
      (c) => c.state.preferences.betweenSetsSeconds,
    );
    final custom = exercise.restSeconds;
    final seconds = custom ?? defaultSeconds;
    final color = custom != null ? AppColors.secondary : AppColors.ofTextSecondary(context);
    final l10n = AppLocalizations.of(context)!;

    return Tooltip(
      message: l10n.exerciseRest,
      child: Material(
        color: custom != null
            ? AppColors.secondary.withValues(alpha: 0.12)
            : AppColors.ofSurfaceElevated(context),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openPicker(context, defaultSeconds),
          child: Container(
            constraints: const BoxConstraints(minHeight: 32),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  RestTimerVisuals.shortDuration(seconds),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context, int defaultSeconds) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RestTimerCubit>();
    const options = [30, 45, 60, 90, 120, 150, 180, 240, 300];

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.ofCard(context),
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.exerciseRest, style: AppTypography.ofTitleLarge(context)),
              const SizedBox(height: 4),
              Text(
                exercise.localizedName(context),
                style: AppTypography.ofBodySecondary(context),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.useDefaultRest(
                      RestTimerState.formatSeconds(defaultSeconds),
                    )),
                    selected: exercise.restSeconds == null,
                    showCheckmark: false,
                    selectedColor: AppColors.ofPrimaryContainer(context),
                    backgroundColor: AppColors.ofSurface(context),
                    side: BorderSide(color: AppColors.ofBorder(context)),
                    onSelected: (_) {
                      cubit.setExerciseRest(exercise.id, null);
                      Navigator.pop(sheetCtx);
                    },
                  ),
                  ...options.map((sec) {
                    final selected = exercise.restSeconds == sec;
                    return ChoiceChip(
                      label: Text(RestTimerVisuals.shortDuration(sec)),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                      backgroundColor: AppColors.ofSurface(context),
                      side: BorderSide(
                        color: selected ? AppColors.secondary : AppColors.ofBorder(context),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected ? AppColors.secondary : AppColors.ofTextPrimary(context),
                      ),
                      onSelected: (_) {
                        cubit.setExerciseRest(exercise.id, sec);
                        Navigator.pop(sheetCtx);
                      },
                    );
                  }),
                ],
              ),
              const SizedBox(height: 12),
              Text(l10n.restGuide, style: AppTypography.ofCaption(context)),
            ],
          ),
        );
      },
    );
  }
}
