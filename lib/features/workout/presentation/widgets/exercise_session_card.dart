import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../exercises/presentation/widgets/exercise_guide_sheet.dart';
import '../../domain/models/exercise_personal_records.dart';
import '../../domain/models/workout_session_detail.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import 'dialogs/workout_session_dialogs.dart';
import 'exercise_rest_chip.dart';
import 'set_row_widget.dart';
import 'superset_banner.dart';

/// Isolated, testable card component representing a single exercise block
/// inside an active workout session (header, superset badge, set rows, and add-set action).
class ExerciseSessionCard extends StatelessWidget {
  final WorkoutExerciseDetail item;
  final List<SetLog> previousSets;
  final ExercisePersonalRecords? personalRecords;
  final String? supersetLabel;
  final int? activeSetId;
  final ValueChanged<int> onSelectSet;
  final ValueChanged<int> onSetCompletedRestTrigger;

  const ExerciseSessionCard({
    super.key,
    required this.item,
    required this.previousSets,
    required this.personalRecords,
    this.supersetLabel,
    this.activeSetId,
    required this.onSelectSet,
    required this.onSetCompletedRestTrigger,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: supersetLabel != null
            ? BorderDirectional(
                start: const BorderSide(color: Color(0xFF8B5CF6), width: 4.0),
                top: BorderSide(color: AppColors.ofBorder(context), width: 0.8),
                end: BorderSide(color: AppColors.ofBorder(context), width: 0.8),
                bottom: BorderSide(
                  color: AppColors.ofBorder(context),
                  width: 0.8,
                ),
              )
            : Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Superset Group Badge
          if (supersetLabel != null)
            SupersetBanner(supersetLabel: supersetLabel!),

          // Exercise Header: Name + Badges + Options Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.exercise.localizedName(context),
                      style: AppTypography.ofTitleLarge(context),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item.exercise.localizedMuscleGroup(context),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            color: AppColors.ofTextTertiary(context),
                          ),
                        ),
                        Text(
                          item.exercise.localizedEquipment(context),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.ofTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ExerciseRestChip(exercise: item.exercise),
              IconButton(
                icon: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                tooltip: l10n.exerciseGuide,
                onPressed: () => ExerciseGuideSheet.show(
                  context,
                  slug: item.exercise.slug,
                  exerciseName: item.exercise.localizedName(context),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.ofTextTertiary(context),
                  size: 20,
                ),
                onPressed: () =>
                    ExerciseSessionOptionsSheet.show(context, item: item),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Table Headers (SET, PREVIOUS, KG, REPS, CHECK)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    l10n.set.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.ofCaption(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.previous.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.ofCaption(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.weight.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.ofCaption(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.reps.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.ofCaption(context),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 38,
                  child: Icon(
                    Icons.done_all,
                    size: 16,
                    color: AppColors.ofTextTertiary(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Set Rows
          ...item.sets.asMap().entries.map((entry) {
            final index = entry.key;
            final setLog = entry.value;
            final previousSet = index < previousSets.length
                ? previousSets[index]
                : null;

            return SetRowWidget(
              key: ValueKey('set_${setLog.id}'),
              setLog: setLog,
              previousSetLog: previousSet,
              personalRecords: personalRecords,
              isSelected: activeSetId == setLog.id,
              onSelect: () => onSelectSet(setLog.id),
              onToggleCompleted: (completed) {
                context.read<WorkoutSessionBloc>().add(
                  ToggleSetCompletionRequested(
                    setId: setLog.id,
                    isCompleted: completed,
                  ),
                );
                if (completed) {
                  onSetCompletedRestTrigger(setLog.id);

                  final prBadges = personalRecords?.evaluateSet(
                    weightKg: setLog.weightKg ?? 0,
                    reps: setLog.reps ?? 0,
                  );
                  if (prBadges != null && prBadges.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFFD4AF37),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Row(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${l10n.newPrAchieved} ${item.exercise.localizedName(context)} (${setLog.weightKg} kg × ${setLog.reps})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              onUpdateValues: (weight, reps, rpe, setType) {
                context.read<WorkoutSessionBloc>().add(
                  UpdateSetRequested(
                    setId: setLog.id,
                    workoutExerciseId: setLog.workoutExerciseId,
                    setNumber: setLog.setNumber,
                    setType: setType,
                    weightKg: weight,
                    reps: reps,
                    rpe: rpe,
                    isCompleted: setLog.isCompleted,
                  ),
                );
              },
              onDelete: () {
                context.read<WorkoutSessionBloc>().add(
                  DeleteSetRequested(setLog.id),
                );
              },
            );
          }),
          const SizedBox(height: 8),

          // Add Set Button
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 16),
              label: Text('+ ${l10n.set}'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                context.read<WorkoutSessionBloc>().add(
                  AddSetRequested(item.workoutExercise.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Top summary bar displaying live Sets, Duration, and Total Volume for the active session.
class ActiveSessionMetricsHeader extends StatelessWidget {
  final int completedSetsCount;
  final String formattedDuration;
  final double totalVolumeKg;

  const ActiveSessionMetricsHeader({
    super.key,
    required this.completedSetsCount,
    required this.formattedDuration,
    required this.totalVolumeKg,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricColumn(
            context: context,
            label: l10n.sets,
            value: '$completedSetsCount',
          ),
          Container(width: 1, height: 32, color: AppColors.ofBorder(context)),
          _buildMetricColumn(
            context: context,
            label: l10n.duration,
            value: formattedDuration,
          ),
          Container(width: 1, height: 32, color: AppColors.ofBorder(context)),
          _buildMetricColumn(
            context: context,
            label: l10n.weightKg,
            value: totalVolumeKg.toStringAsFixed(0),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(value, style: AppTypography.ofMetricLarge(context)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.ofCaption(context)),
      ],
    );
  }
}

/// Empty state view when no workout session is currently active.
class EmptyWorkoutSessionView extends StatelessWidget {
  const EmptyWorkoutSessionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/icons/app_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.appTitle,
              style: AppTypography.ofDisplay(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.emptyHistory,
              style: AppTypography.ofBodySecondary(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: Text(l10n.startWorkout),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              onPressed: () {
                context.read<WorkoutSessionBloc>().add(
                  const StartSessionRequested(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
