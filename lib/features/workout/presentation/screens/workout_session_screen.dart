import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../exercises/presentation/widgets/exercise_guide_sheet.dart';
import '../../../exercises/presentation/widgets/exercise_picker_bottom_sheet.dart';
import '../../domain/models/workout_session_detail.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../bloc/workout_session_state.dart';
import '../cubit/rest_timer_cubit.dart';
import '../../../../core/enums/set_type.dart';
import '../widgets/exercise_rest_chip.dart';
import '../widgets/plate_calculator_dialog.dart';
import '../widgets/one_handed_quick_input_bar.dart';
import '../widgets/rest_timer_dialog.dart';
import '../widgets/rest_timer_floating_bar.dart';
import '../widgets/set_row_widget.dart';
import '../widgets/warmup_sets_dialog.dart';

/// Main screen showcasing active workout tracking with reactive Drift Streams,
/// dynamic locale switching, adaptive dark/light theming, and responsive layouts.
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
    // Keep device display awake during active workout session (T02)
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Restore normal system sleep timeout when exiting session
    WakelockPlus.disable();
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

    // Default to first uncompleted set
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

    // Fallback: last set
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

  Map<int, String> _buildSupersetLabels(List<WorkoutExerciseDetail> exercises) {
    final groupToLetter = <int, String>{};
    final groupCounts = <int, int>{};
    final result = <int, String>{};

    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    int letterIndex = 0;

    for (final item in exercises) {
      final gid = item.workoutExercise.supersetGroupId;
      if (gid != null) {
        if (!groupToLetter.containsKey(gid)) {
          groupToLetter[gid] = letters[letterIndex % letters.length];
          letterIndex++;
        }
        final letter = groupToLetter[gid]!;
        final count = (groupCounts[gid] ?? 0) + 1;
        groupCounts[gid] = count;
        result[item.workoutExercise.id] = '$letter$count';
      }
    }
    return result;
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
            // Rest Timer Chronograph Button
            IconButton(
              icon: const Icon(
                Icons.timer_outlined,
                color: AppColors.secondary,
              ),
              tooltip: l10n.restTimer,
              onPressed: () => RestTimerDialog.show(context),
            ),

            // Language Switcher Menu
            _buildLanguageMenu(context),

            // Discard Menu & Finish Workout Button
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
                          _confirmDiscard(context);
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
                          context.read<WorkoutSessionBloc>().add(
                            const CompleteSessionRequested(),
                          );
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
              return _buildEmptyOrStartSessionView(context);
            }

            final detail = state.detail!;
            return ResponsiveContentWrapper(
              maxWidth: 820,
              child: _buildActiveSessionView(context, detail, state),
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
                      // 1. One-Handed Quick Input Bar in Reachable Thumb Zone
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
                            onUpdateValues: (weight, reps, [rpe]) {
                              context.read<WorkoutSessionBloc>().add(
                                UpdateSetRequested(
                                  setId: active.set.id,
                                  workoutExerciseId:
                                      active.set.workoutExerciseId,
                                  setNumber: active.set.setNumber,
                                  setType: active.set.setType,
                                  weightKg: weight,
                                  reps: reps,
                                  rpe: rpe ?? active.set.rpe,
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

                      // 2. Rest Timer Floating Bar
                      const RestTimerFloatingBar(),

                      // 3. Add Exercise Button
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ResponsiveContentWrapper(
                          maxWidth: 820,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add, size: 20),
                              label: Text(l10n.addExercise),
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
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildEmptyOrStartSessionView(BuildContext context) {
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

  Widget _buildActiveSessionView(
    BuildContext context,
    WorkoutSessionDetail detail,
    WorkoutSessionState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final active = _findActiveSet(detail, state);

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 80),
      children: [
        // Top Metrics Summary Card
        Container(
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
                value: '${detail.completedSetsCount}',
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.ofBorder(context),
              ),
              _buildMetricColumn(
                context: context,
                label: l10n.duration,
                value: state.formattedDuration,
              ),
              Container(
                width: 1,
                height: 32,
                color: AppColors.ofBorder(context),
              ),
              _buildMetricColumn(
                context: context,
                label: l10n.weightKg,
                value: detail.totalVolumeKg.toStringAsFixed(0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // List of Exercise Cards
        ...() {
          final supersetLabels = _buildSupersetLabels(detail.exercises);
          return detail.exercises.map((item) {
            final previousSets =
                state.previousExerciseSets[item.exercise.id] ?? [];
            final supersetLabel = supersetLabels[item.workoutExercise.id];

            return Container(
              margin: const EdgeInsetsDirectional.only(bottom: 16),
              padding: const EdgeInsetsDirectional.all(14),
              decoration: BoxDecoration(
                color: AppColors.ofCard(context),
                borderRadius: BorderRadius.circular(16),
                border: supersetLabel != null
                    ? Border(
                        left: const BorderSide(
                          color: Color(0xFF8B5CF6),
                          width: 4.0,
                        ),
                        top: BorderSide(
                          color: AppColors.ofBorder(context),
                          width: 0.8,
                        ),
                        right: BorderSide(
                          color: AppColors.ofBorder(context),
                          width: 0.8,
                        ),
                        bottom: BorderSide(
                          color: AppColors.ofBorder(context),
                          width: 0.8,
                        ),
                      )
                    : Border.all(
                        color: AppColors.ofBorder(context),
                        width: 0.8,
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Superset Group Badge
                  if (supersetLabel != null)
                    Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 8),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.link_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n.supersetLabel} $supersetLabel',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Exercise Header: Name + Badges + Delete Option
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
                        onPressed: () => _showExerciseOptions(context, item),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Table Headers (SET, PREVIOUS, KG, REPS, CHECK)
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                    ),
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
                      personalRecords: state.personalRecords[item.exercise.id],
                      isSelected:
                          (active != null && active.set.id == setLog.id),
                      onSelect: () {
                        setState(() => _selectedSetId = setLog.id);
                      },
                      onToggleCompleted: (completed) {
                        context.read<WorkoutSessionBloc>().add(
                          ToggleSetCompletionRequested(
                            setId: setLog.id,
                            isCompleted: completed,
                          ),
                        );
                        if (completed) {
                          _triggerRest(context, detail, item, setLog.id);

                          // Check and celebrate PR
                          final prs = state.personalRecords[item.exercise.id];
                          final prBadges = prs?.evaluateSet(
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
                                    const Text(
                                      '🏆',
                                      style: TextStyle(fontSize: 20),
                                    ),
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
          }).toList();
        }(),
      ],
    );
  }

  void _triggerRest(
    BuildContext context,
    WorkoutSessionDetail detail,
    WorkoutExerciseDetail item,
    int completedSetId,
  ) {
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

  Widget _buildLanguageMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: AppColors.ofTextPrimary(context)),
      color: AppColors.ofSurfaceElevated(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (code) {
        widget.onLocaleChanged(Locale(code));
      },
      itemBuilder: (ctx) => [
        _buildPopupItem(
          context,
          'ar',
          'العربية',
          widget.currentLocale.languageCode == 'ar',
        ),
        _buildPopupItem(
          context,
          'en',
          'English',
          widget.currentLocale.languageCode == 'en',
        ),
        _buildPopupItem(
          context,
          'fr',
          'Français',
          widget.currentLocale.languageCode == 'fr',
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(
    BuildContext context,
    String code,
    String label,
    bool isSelected,
  ) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.ofTextPrimary(context),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }

  void _showExerciseOptions(BuildContext context, WorkoutExerciseDetail item) {
    final l10n = AppLocalizations.of(context)!;
    final lastWeight = item.sets.isNotEmpty && item.sets.last.weightKg != null
        ? item.sets.last.weightKg!
        : 60.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.ofSurfaceElevated(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.menu_book_rounded,
                color: AppColors.secondary,
              ),
              title: Text(
                l10n.exerciseGuide,
                style: AppTypography.ofBody(context),
              ),
              subtitle: Text(
                l10n.techniqueGuide,
                style: AppTypography.ofCaption(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                ExerciseGuideSheet.show(
                  context,
                  slug: item.exercise.slug,
                  exerciseName: item.exercise.localizedName(context),
                );
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                l10n.plateCalculator,
                style: AppTypography.ofBody(context),
              ),
              subtitle: Text(
                '${l10n.barWeight}: 20 kg',
                style: AppTypography.ofCaption(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                PlateCalculatorDialog.show(context, initialWeight: lastWeight);
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.fireplace_rounded,
                color: AppColors.warmup,
              ),
              title: Text(
                l10n.warmupCalculator,
                style: AppTypography.ofBody(context),
              ),
              onTap: () {
                Navigator.pop(ctx);
                WarmupSetsDialog.show(
                  context,
                  initialWorkingWeight: lastWeight,
                  onAddWarmupSets: (steps) {
                    for (final step in steps) {
                      context.read<WorkoutSessionBloc>().add(
                        AddSetRequested(
                          item.workoutExercise.id,
                          setType: SetType.warmup,
                          weightKg: step.weightKg,
                          reps: step.reps,
                        ),
                      );
                    }
                  },
                );
              },
            ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            if (item.workoutExercise.supersetGroupId != null)
              ListTile(
                leading: const Icon(
                  Icons.link_off_rounded,
                  color: Color(0xFF8B5CF6),
                ),
                title: Text(
                  l10n.unlinkSuperset,
                  style: AppTypography.ofBody(context),
                ),
                subtitle: Text(
                  l10n.supersetUnlinked,
                  style: AppTypography.ofCaption(context),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<WorkoutSessionBloc>().add(
                    SetExerciseSupersetRequested(
                      workoutExerciseId: item.workoutExercise.id,
                      supersetGroupId: null,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.supersetUnlinked),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              )
            else
              ListTile(
                leading: const Icon(
                  Icons.link_rounded,
                  color: Color(0xFF8B5CF6),
                ),
                title: Text(
                  l10n.createSuperset,
                  style: AppTypography.ofBody(context),
                ),
                subtitle: Text(
                  l10n.linkWithNext,
                  style: AppTypography.ofCaption(context),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _linkExerciseInSuperset(context, item);
                },
              ),
            Divider(height: 1, color: AppColors.ofDivider(context)),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.failure,
              ),
              title: Text(
                l10n.delete,
                style: const TextStyle(color: AppColors.failure),
              ),
              onTap: () {
                Navigator.pop(ctx);
                context.read<WorkoutSessionBloc>().add(
                  DeleteExerciseRequested(item.workoutExercise.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _linkExerciseInSuperset(
    BuildContext context,
    WorkoutExerciseDetail item,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<WorkoutSessionBloc>().state;
    final detail = state.detail;
    if (detail == null) return;

    final currentIndex = detail.exercises.indexWhere(
      (e) => e.workoutExercise.id == item.workoutExercise.id,
    );
    if (currentIndex == -1) return;

    int maxGroupId = 0;
    for (final e in detail.exercises) {
      final gid = e.workoutExercise.supersetGroupId;
      if (gid != null && gid > maxGroupId) {
        maxGroupId = gid;
      }
    }
    final targetGroupId = maxGroupId + 1;

    context.read<WorkoutSessionBloc>().add(
      SetExerciseSupersetRequested(
        workoutExerciseId: item.workoutExercise.id,
        supersetGroupId: targetGroupId,
      ),
    );

    // If there is a next exercise in the session, link it as well!
    if (currentIndex + 1 < detail.exercises.length) {
      final nextExercise = detail.exercises[currentIndex + 1];
      context.read<WorkoutSessionBloc>().add(
        SetExerciseSupersetRequested(
          workoutExerciseId: nextExercise.workoutExercise.id,
          supersetGroupId: targetGroupId,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.supersetLinked),
        backgroundColor: const Color(0xFF7C3AED),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDiscard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.ofCard(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.discardDialogTitle,
          style: AppTypography.ofTitleLarge(context),
        ),
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
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<WorkoutSessionBloc>().add(
                const DiscardSessionRequested(),
              );
              if (context.mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
  }
}
