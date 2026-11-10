import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../exercises/presentation/widgets/exercise_picker_bottom_sheet.dart';
import '../../domain/models/workout_session_detail.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../bloc/workout_session_state.dart';
import '../cubit/rest_timer_cubit.dart';
import '../widgets/dialogs/workout_session_dialogs.dart';
import '../widgets/exercise_session_card.dart';
import '../widgets/one_handed_quick_input_bar.dart';
import '../widgets/rest_timer_dialog.dart';
import '../widgets/rest_timer_floating_bar.dart';
import '../widgets/superset_banner.dart';

/// Orchestration shell for active workout tracking with reactive Drift Streams,
/// Wakelock display management, one-handed thumb input, and rest timer triggers.
class WorkoutSessionScreen extends StatefulWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const WorkoutSessionScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int? _selectedSetId;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable().catchError((_) {});
  }

  @override
  void dispose() {
    WakelockPlus.disable().catchError((_) {});
    super.dispose();
  }

  ({WorkoutExerciseDetail exercise, SetLog set, SetLog? previousSet})?
  _findActiveSet(WorkoutSessionDetail detail, WorkoutSessionState state) {
    if (detail.exercises.isEmpty) return null;

    if (_selectedSetId != null) {
      for (final exerciseItem in detail.exercises) {
        final matchIndex = exerciseItem.sets.indexWhere(
          (s) => s.id == _selectedSetId,
        );
        if (matchIndex != -1) {
          final previousSets =
              state.previousExerciseSets[exerciseItem.exercise.id] ?? [];
          final previousSet = matchIndex < previousSets.length
              ? previousSets[matchIndex]
              : null;
          return (
            exercise: exerciseItem,
            set: exerciseItem.sets[matchIndex],
            previousSet: previousSet,
          );
        }
      }
    }

    for (final exerciseItem in detail.exercises) {
      for (int i = 0; i < exerciseItem.sets.length; i++) {
        final s = exerciseItem.sets[i];
        if (!s.isCompleted) {
          final previousSets =
              state.previousExerciseSets[exerciseItem.exercise.id] ?? [];
          final previousSet = i < previousSets.length ? previousSets[i] : null;
          return (exercise: exerciseItem, set: s, previousSet: previousSet);
        }
      }
    }

    final lastExercise = detail.exercises.last;
    if (lastExercise.sets.isNotEmpty) {
      final lastIndex = lastExercise.sets.length - 1;
      final previousSets =
          state.previousExerciseSets[lastExercise.exercise.id] ?? [];
      return (
        exercise: lastExercise,
        set: lastExercise.sets[lastIndex],
        previousSet: lastIndex < previousSets.length
            ? previousSets[lastIndex]
            : null,
      );
    }

    return null;
  }

  void _advanceToNextSet(WorkoutSessionDetail detail) {
    if (_selectedSetId != null) {
      // Check if current set belongs to a superset group (alternating A1 -> A2 flow)
      WorkoutExerciseDetail? currentExercise;
      SetLog? currentSet;
      for (final e in detail.exercises) {
        for (final s in e.sets) {
          if (s.id == _selectedSetId) {
            currentExercise = e;
            currentSet = s;
            break;
          }
        }
        if (currentExercise != null) break;
      }

      if (currentExercise != null &&
          currentSet != null &&
          currentExercise.workoutExercise.supersetGroupId != null) {
        final gid = currentExercise.workoutExercise.supersetGroupId!;
        final groupExercises = detail.exercises
            .where((e) => e.workoutExercise.supersetGroupId == gid)
            .toList();

        if (groupExercises.length > 1) {
          final currentIdx = groupExercises.indexOf(currentExercise);
          final nextIdx = (currentIdx + 1) % groupExercises.length;
          final targetExercise = groupExercises[nextIdx];

          final matchingSet = targetExercise.sets.firstWhere(
            (s) => s.setNumber == currentSet!.setNumber && !s.isCompleted,
            orElse: () => targetExercise.sets.firstWhere(
              (s) => !s.isCompleted,
              orElse: () => currentSet!,
            ),
          );

          if (!matchingSet.isCompleted && matchingSet.id != currentSet.id) {
            setState(() => _selectedSetId = matchingSet.id);
            return;
          }
        }
      }
    }

    bool foundCurrent = false;
    for (final exerciseItem in detail.exercises) {
      for (final s in exerciseItem.sets) {
        if (foundCurrent && !s.isCompleted) {
          setState(() => _selectedSetId = s.id);
          return;
        }
        if (s.id == _selectedSetId) {
          foundCurrent = true;
        }
      }
    }
    for (final exerciseItem in detail.exercises) {
      for (final s in exerciseItem.sets) {
        if (!s.isCompleted) {
          setState(() => _selectedSetId = s.id);
          return;
        }
      }
    }
  }

  void _triggerRest(
    BuildContext context,
    WorkoutSessionDetail detail,
    WorkoutExerciseDetail item,
    int completedSetId,
  ) {
    // If mid-superset, do not trigger a full rest so athlete moves right to partner exercise
    final gid = item.workoutExercise.supersetGroupId;
    if (gid != null) {
      final group = detail.exercises
          .where((e) => e.workoutExercise.supersetGroupId == gid)
          .toList();
      if (group.length > 1) {
        final currentIdx = group.indexOf(item);
        if (currentIdx < group.length - 1) {
          return;
        }
      }
    }

    final hasPendingSets = item.sets.any(
      (s) => s.id != completedSetId && !s.isCompleted,
    );

    String? nextName;
    if (!hasPendingSets) {
      bool unfinished(WorkoutExerciseDetail e) =>
          e.workoutExercise.id != item.workoutExercise.id &&
          (e.sets.isEmpty || e.sets.any((s) => !s.isCompleted));

      final idx = detail.exercises.indexOf(item);
      final ordered = [
        ...detail.exercises.skip(idx + 1),
        ...detail.exercises.take(idx < 0 ? 0 : idx),
      ];
      for (final e in ordered) {
        if (unfinished(e)) {
          nextName = e.exercise.localizedName(context);
          break;
        }
      }
    }

    context.read<RestTimerCubit>().onSetCompleted(
      exerciseRestSeconds: item.exercise.restSeconds,
      isLastSetOfExercise: !hasPendingSets,
      nextExerciseName: nextName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    state.hasActiveSession
                        ? state.detail!.session.title
                        : l10n.appTitle,
                    style: AppTypography.ofTitleLarge(context),
                  ),
                  if (state.hasActiveSession)
                    Text(
                      state.formattedDuration,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                ],
              );
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.timer_outlined,
                color: AppColors.secondary,
              ),
              tooltip: l10n.restTimer,
              onPressed: () => RestTimerDialog.show(context),
            ),
            SessionLanguageMenu(
              currentLocale: widget.currentLocale,
              onLocaleChanged: widget.onLocaleChanged,
            ),
            BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
              builder: (context, state) {
                if (!state.hasActiveSession) return const SizedBox.shrink();
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.ofTextPrimary(context),
                      ),
                      color: AppColors.ofSurfaceElevated(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (val) {
                        if (val == 'discard') {
                          DiscardWorkoutDialog.show(context);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem<String>(
                          value: 'discard',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: AppColors.failure,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                l10n.discard,
                                style: const TextStyle(
                                  color: AppColors.failure,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextButton(
                        onPressed: () {
                          final hasIncomplete =
                              state.detail?.exercises.any(
                                (e) => e.sets.any((s) => !s.isCompleted),
                              ) ??
                              false;

                          if (hasIncomplete) {
                            showDialog(
                              context: context,
                              builder: (dialogCtx) => AlertDialog(
                                backgroundColor: AppColors.ofCard(context),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  l10n.finishWorkoutConfirmTitle,
                                  style: AppTypography.ofTitleLarge(context),
                                ),
                                content: Text(
                                  l10n.finishWorkoutIncompleteMessage,
                                  style: AppTypography.ofBodySecondary(context),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogCtx),
                                    child: Text(l10n.continueWorkout),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.completed,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogCtx);
                                      context.read<WorkoutSessionBloc>().add(
                                        const CompleteSessionRequested(),
                                      );
                                    },
                                    child: Text(l10n.finishWorkout),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            context.read<WorkoutSessionBloc>().add(
                              const CompleteSessionRequested(),
                            );
                          }
                        },
                        child: Text(
                          l10n.finishWorkout,
                          style: const TextStyle(
                            color: AppColors.completed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<WorkoutSessionBloc, WorkoutSessionState>(
          listener: (context, state) {
            if (state.status == WorkoutSessionStatus.completed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.completed,
                  content: Text('${l10n.finishWorkout}: ${l10n.completed}!'),
                ),
              );
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }
          },
          builder: (context, state) {
            if (state.status == WorkoutSessionStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!state.hasActiveSession) {
              return const EmptyWorkoutSessionView();
            }

            final detail = state.detail!;
            final active = _findActiveSet(detail, state);
            final supersetLabels = SupersetBanner.buildLabels(detail.exercises);

            return ResponsiveContentWrapper(
              maxWidth: 820,
              child: ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 140),
                children: [
                  ActiveSessionMetricsHeader(
                    completedSetsCount: detail.completedSetsCount,
                    formattedDuration: state.formattedDuration,
                    totalVolumeKg: detail.totalVolumeKg,
                  ),
                  const SizedBox(height: 16),
                  ...detail.exercises.map((item) {
                    return ExerciseSessionCard(
                      item: item,
                      previousSets:
                          state.previousExerciseSets[item.exercise.id] ??
                          const [],
                      personalRecords: state.personalRecords[item.exercise.id],
                      supersetLabel: supersetLabels[item.workoutExercise.id],
                      activeSetId: active?.set.id,
                      onSelectSet: (setId) =>
                          setState(() => _selectedSetId = setId),
                      onSetCompletedRestTrigger: (setId) =>
                          _triggerRest(context, detail, item, setId),
                    );
                  }),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: Text(l10n.addExercise),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ExercisePickerBottomSheet.show(
                            context,
                            onExerciseSelected: (exercise) {
                              context.read<WorkoutSessionBloc>().add(
                                AddExerciseRequested(exercise.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar:
            BlocBuilder<WorkoutSessionBloc, WorkoutSessionState>(
              builder: (context, state) {
                if (!state.hasActiveSession) return const SizedBox.shrink();
                final detail = state.detail!;
                final active = _findActiveSet(detail, state);

                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (active != null)
                        ResponsiveContentWrapper(
                          maxWidth: 820,
                          child: OneHandedQuickInputBar(
                            key: ValueKey('one_hand_set_${active.set.id}'),
                            exerciseItem: active.exercise,
                            setLog: active.set,
                            previousSetLog: active.previousSet,
                            isPr:
                                (state
                                    .personalRecords[active
                                        .exercise
                                        .exercise
                                        .id]
                                    ?.evaluateSet(
                                      weightKg: active.set.weightKg ?? 0,
                                      reps: active.set.reps ?? 0,
                                    )
                                    .isNotEmpty ??
                                false),
                            onUpdateValues: (weight, reps, [rpe, setType]) {
                              context.read<WorkoutSessionBloc>().add(
                                UpdateSetRequested(
                                  setId: active.set.id,
                                  workoutExerciseId:
                                      active.set.workoutExerciseId,
                                  setNumber: active.set.setNumber,
                                  setType: setType ?? active.set.setType,
                                  weightKg: weight,
                                  reps: reps,
                                  rpe: rpe ?? active.set.rpe,
                                  isCompleted: active.set.isCompleted,
                                ),
                              );
                            },
                            onUpdateSetType: (newType) {
                              context.read<WorkoutSessionBloc>().add(
                                UpdateSetRequested(
                                  setId: active.set.id,
                                  workoutExerciseId:
                                      active.set.workoutExerciseId,
                                  setNumber: active.set.setNumber,
                                  setType: newType,
                                  weightKg: active.set.weightKg,
                                  reps: active.set.reps,
                                  rpe: active.set.rpe,
                                  isCompleted: active.set.isCompleted,
                                ),
                              );
                            },
                            onToggleCompleted: (completed) {
                              context.read<WorkoutSessionBloc>().add(
                                ToggleSetCompletionRequested(
                                  setId: active.set.id,
                                  isCompleted: completed,
                                ),
                              );
                              if (completed) {
                                _triggerRest(
                                  context,
                                  detail,
                                  active.exercise,
                                  active.set.id,
                                );
                              }
                            },
                            onNextSet: () => _advanceToNextSet(detail),
                          ),
                        ),
                      const RestTimerFloatingBar(),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
