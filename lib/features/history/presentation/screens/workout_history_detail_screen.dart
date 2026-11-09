import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:strong/core/enums/set_type.dart';
import 'package:strong/core/l10n/exercise_translation_helper.dart';
import 'package:strong/core/l10n/generated/app_localizations.dart';
import 'package:strong/core/services/ai_key_storage_service.dart';
import 'package:strong/core/theme/app_colors.dart';
import 'package:strong/core/theme/app_typography.dart';
import 'package:strong/core/widgets/responsive_content_wrapper.dart';
import 'package:strong/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:strong/features/profile/presentation/widgets/ai_key_settings_sheet.dart';
import 'package:strong/features/workout/domain/models/workout_ai_models.dart';
import 'package:strong/features/workout/domain/models/workout_session_detail.dart';
import 'package:strong/features/workout/domain/repositories/workout_repository.dart';
import 'package:strong/features/workout/domain/services/one_rep_max_calculator.dart';
import 'package:strong/features/workout/domain/services/workout_ai_service.dart';
import 'package:strong/features/workout/presentation/cubit/routines_cubit.dart';
import 'package:strong/features/workout/presentation/widgets/workout_ai_analysis_dialog.dart';

/// Detailed summary screen for a completed historical workout session.
class WorkoutHistoryDetailScreen extends StatelessWidget {
  final int sessionId;

  const WorkoutHistoryDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repo = context.read<WorkoutRepository>();

    return StreamBuilder<WorkoutSessionDetail?>(
      stream: repo.watchSessionWithSets(sessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(l10n.sessionDetails),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final detail = snapshot.data;
        if (detail == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(l10n.sessionDetails),
            ),
            body: Center(
              child: Text(
                l10n.emptyHistory,
                style: AppTypography.ofBodySecondary(context),
              ),
            ),
          );
        }

        final dateFormat = DateFormat.yMMMEd(
          Localizations.localeOf(context).toString(),
        );
        final durationMins = (detail.session.durationSeconds / 60).round();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              detail.session.title,
              style: AppTypography.ofTitleLarge(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                ),
                tooltip: 'Analyser avec le Coach IA',
                onPressed: () => _analyzeWithAi(context, detail),
              ),
              IconButton(
                icon: const Icon(
                  Icons.bookmark_add_outlined,
                  color: AppColors.primary,
                ),
                tooltip: l10n.saveAsRoutine,
                onPressed: () => _saveAsRoutine(context, detail),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.failure,
                ),
                tooltip: l10n.delete,
                onPressed: () => _confirmDelete(context, detail.session.id),
              ),
            ],
          ),
          body: ResponsiveContentWrapper(
            maxWidth: 780,
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 32),
              children: [
                // Date & Summary Banner
                Container(
                  padding: const EdgeInsetsDirectional.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.ofSurface(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.ofBorder(context),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            dateFormat.format(detail.session.startedAt),
                            style: AppTypography.ofCaption(context).copyWith(
                              color: AppColors.ofTextPrimary(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryMetric(
                            context: context,
                            label: l10n.duration,
                            value: '$durationMins min',
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: AppColors.ofBorder(context),
                          ),
                          _buildSummaryMetric(
                            context: context,
                            label: l10n.sets,
                            value: '${detail.completedSetsCount}',
                          ),
                          Container(
                            width: 1,
                            height: 32,
                            color: AppColors.ofBorder(context),
                          ),
                          _buildSummaryMetric(
                            context: context,
                            label: l10n.weightKg,
                            value:
                                '${detail.totalVolumeKg.toStringAsFixed(0)} kg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // AI Coach Analysis Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                    label: const Text(
                      'Analyser avec le Coach IA Gemini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: () => _analyzeWithAi(context, detail),
                  ),
                ),
                const SizedBox(height: 12),

                // Save as Routine Action Button
                if (detail.exercises.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                      label: Text(l10n.saveAsRoutine),
                      onPressed: () => _saveAsRoutine(context, detail),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Exercise Cards
                ...detail.exercises.map(
                  (item) => _buildExerciseCard(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryMetric({
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

  Widget _buildExerciseCard(BuildContext context, WorkoutExerciseDetail item) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 14),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.exercise.localizedName(context),
            style: AppTypography.ofTitleMedium(context).copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.exercise.localizedMuscleGroup(context)} • ${item.exercise.localizedEquipment(context)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.ofBorder(context), height: 1),
          const SizedBox(height: 8),
          ...item.sets.map((s) {
            final weight = s.weightKg ?? 0;
            final reps = s.reps ?? 0;
            final oneRm = (weight > 0 && reps > 0)
                ? OneRepMaxCalculator.calculate(weight: weight, reps: reps)
                : null;

            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.ofSurfaceElevated(context),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _setBadgeLabel(s.setType, s.setNumber),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ofTextSecondary(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)} kg × $reps ${l10n.reps.toLowerCase()}',
                      style: AppTypography.ofBody(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (oneRm != null)
                    Text(
                      '${l10n.estimatedOneRepMax}: ${oneRm.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
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

  String _setBadgeLabel(SetType type, int number) {
    switch (type) {
      case SetType.warmup:
        return 'W';
      case SetType.dropset:
        return 'D';
      case SetType.failure:
        return 'F';
      case SetType.normal:
        return '$number';
    }
  }

  Future<void> _saveAsRoutine(
    BuildContext context,
    WorkoutSessionDetail detail,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final exercises = detail.exercises
        .map(
          (e) => (
            exerciseId: e.exercise.id,
            targetSets: e.sets.isNotEmpty ? e.sets.length : 3,
          ),
        )
        .toList();

    await context.read<RoutinesCubit>().createRoutine(
      name: detail.session.title,
      notes: detail.session.notes,
      exercises: exercises,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.routineSaved),
          backgroundColor: AppColors.completed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmDelete(BuildContext context, int sessionId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.ofCard(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.delete, style: AppTypography.ofTitleLarge(context)),
        content: Text(
          l10n.discardDialogMessage,
          style: AppTypography.ofBodySecondary(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.failure),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await context.read<WorkoutRepository>().discardSession(sessionId);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeWithAi(
    BuildContext context,
    WorkoutSessionDetail detail,
  ) async {
    final keyStorage = AiKeyStorageService();
    final hasKey = await keyStorage.hasApiKey();

    if (!context.mounted) return;

    if (!hasKey) {
      final configured = await AiKeySettingsSheet.show(
        context,
        keyStorage: keyStorage,
      );
      if (configured != true || !context.mounted) return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppColors.ofCard(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Analyse par le Coach IA en cours...',
                    style: AppTypography.ofBody(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final profile = context.read<ProfileCubit>().state.profile;

      final exerciseSummaries = detail.exercises.map((item) {
        final sets = item.sets;
        final totalSets = sets.length;
        final totalReps = sets.fold<int>(0, (sum, s) => sum + (s.reps ?? 0));
        final topWeight = sets.fold<double>(
          0.0,
          (max, s) => (s.weightKg ?? 0.0) > max ? (s.weightKg ?? 0.0) : max,
        );
        final rpeSets = sets.where((s) => s.rpe != null && s.rpe! > 0);
        final avgRpe = rpeSets.isNotEmpty
            ? rpeSets.fold<double>(0.0, (sum, s) => sum + s.rpe!) /
                  rpeSets.length
            : null;

        return ExerciseSummary(
          exerciseName: item.exercise.localizedName(context),
          muscleGroup: item.exercise.localizedMuscleGroup(context),
          totalSets: totalSets,
          totalReps: totalReps,
          topWeightKg: topWeight,
          avgRpe: avgRpe,
        );
      }).toList();

      final summary = WorkoutSummary(
        athleteName: profile?.name ?? 'Athlète',
        experienceLevel: profile?.experienceLevel.name,
        bodyWeightKg: profile?.weightKg,
        workoutTitle: detail.session.title,
        date: detail.session.startedAt,
        durationMinutes: (detail.session.durationSeconds / 60).round(),
        totalVolumeKg: detail.totalVolumeKg,
        exercises: exerciseSummaries,
        athleteFeedback: detail.session.notes,
      );

      final aiService = WorkoutAiService(keyStorage: keyStorage);
      final analysis = await aiService.analyzeWorkoutData(summary);

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss loader
        WorkoutAiAnalysisDialog.show(
          context,
          analysis: analysis,
          sessionTitle: detail.session.title,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur Coach IA : ${e.toString().replaceAll("Exception: ", "")}',
            ),
            backgroundColor: AppColors.failure,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
