import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/rest_timer_cubit.dart';
import '../cubit/rest_timer_state.dart';
import 'rest_progress_ring.dart';

/// Shared visual language for rest states (used by the dialog and floating bar).
class RestTimerVisuals {
  RestTimerVisuals._();

  static List<Color> gradientFor(RestTimerState s) {
    if (s.isFinished) return const [AppColors.completed, AppColors.secondary];
    if (s.isPaused) return const [AppColors.warmup, Color(0xFFFFD60A)];
    if (s.kind == RestKind.betweenExercises) {
      return const [AppColors.dropset, AppColors.primary];
    }
    return const [AppColors.primary, AppColors.secondary];
  }

  static String statusLabel(RestTimerState s, AppLocalizations l10n) {
    if (s.isFinished) return l10n.readyToLift;
    if (s.isPaused) return l10n.timerPaused;
    if (s.isRunning) return l10n.resting;
    return l10n.timerReady;
  }

  static String? kindLabel(RestTimerState s, AppLocalizations l10n) {
    switch (s.kind) {
      case RestKind.betweenSets:
        return l10n.restBetweenSets;
      case RestKind.betweenExercises:
        return l10n.restBetweenExercises;
      case RestKind.manual:
        return null;
    }
  }

  static String shortDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final r = seconds % 60;
    return r == 0 ? '${m}m' : '$m:${r.toString().padLeft(2, '0')}';
  }
}

/// Full interactive chronograph sheet: live dial, micro-controls, presets and
/// persisted rest preferences (between sets / between exercises).
class RestTimerDialog extends StatelessWidget {
  const RestTimerDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.ofCard(context),
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<RestTimerCubit>(),
        child: const RestTimerDialog(),
      ),
    );
  }

  static const _presets = [30, 60, 90, 120, 180, 240];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final media = MediaQuery.of(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: media.size.height * 0.92),
      child: BlocBuilder<RestTimerCubit, RestTimerState>(
        builder: (context, state) {
          final cubit = context.read<RestTimerCubit>();
          final colors = RestTimerVisuals.gradientFor(state);
          final kindLabel = RestTimerVisuals.kindLabel(state, l10n);

          return SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _GrabHandle(),
                const SizedBox(height: 12),

                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.restTimer,
                        style: AppTypography.ofTitleLarge(context),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonTooltip,
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.ofTextSecondary(context),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                if (state.isActive && kindLabel != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _KindPill(
                      label: kindLabel,
                      color: colors.first,
                      icon: state.kind == RestKind.betweenExercises
                          ? Icons.swap_horiz_rounded
                          : Icons.repeat_rounded,
                    ),
                  ),
                const SizedBox(height: 16),

                // Dial — scales with available width for phones, tablets & desktop.
                LayoutBuilder(
                  builder: (context, c) {
                    final size = (c.maxWidth * 0.62).clamp(180.0, 260.0);
                    return RestProgressRing(
                      progress: state.isActive ? state.progress : 1.0,
                      size: size,
                      strokeWidth: size * 0.055,
                      colors: colors,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              state.isActive
                                  ? state.formattedRemaining
                                  : RestTimerState.formatSeconds(
                                      state.defaultDuration,
                                    ),
                              key: ValueKey(state.remainingSeconds),
                              style: AppTypography.ofMetricLarge(context)
                                  .copyWith(
                                    fontSize: size * 0.2,
                                    letterSpacing: -1,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            RestTimerVisuals.statusLabel(state, l10n),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              color: state.isActive
                                  ? colors.first
                                  : AppColors.ofTextSecondary(context),
                            ),
                          ),
                          if (state.nextExerciseName != null &&
                              state.isActive) ...[
                            const SizedBox(height: 6),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: size * 0.7),
                              child: Text(
                                l10n.nextExercise(state.nextExerciseName!),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.ofCaption(context)
                                    .copyWith(
                                      color: AppColors.ofTextSecondary(context),
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Controls: -15s | Play/Pause | +15s | Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundTextButton(
                      label: '-15s',
                      enabled: state.isRunning || state.isPaused,
                      onTap: () => cubit.adjustTime(-15),
                    ),
                    const SizedBox(width: 16),
                    _PrimaryPlayButton(
                      state: state,
                      colors: colors,
                      onPressed: () {
                        if (state.isRunning) {
                          cubit.pause();
                        } else if (state.isPaused) {
                          cubit.resume();
                        } else {
                          cubit.startTimer();
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    _RoundTextButton(
                      label: '+15s',
                      enabled: state.isRunning || state.isPaused,
                      onTap: () => cubit.adjustTime(15),
                    ),
                    const SizedBox(width: 16),
                    Tooltip(
                      message: l10n.skip,
                      child: IconButton.filledTonal(
                        icon: const Icon(Icons.skip_next_rounded, size: 22),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          backgroundColor: AppColors.ofSurfaceElevated(context),
                          foregroundColor: AppColors.ofTextSecondary(context),
                        ),
                        onPressed: () {
                          cubit.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Quick presets (start now + become the between-sets default)
                _SectionLabel(l10n.quickPresets),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _presets.map((sec) {
                    final selected = state.defaultDuration == sec;
                    return ChoiceChip(
                      label: Text(RestTimerVisuals.shortDuration(sec)),
                      selected: selected,
                      showCheckmark: false,
                      selectedColor: AppColors.ofPrimaryContainer(context),
                      backgroundColor: AppColors.ofSurface(context),
                      side: BorderSide(
                        color: selected
                            ? AppColors.primary
                            : AppColors.ofBorder(context),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? AppColors.primary
                            : AppColors.ofTextPrimary(context),
                      ),
                      onSelected: (_) {
                        cubit.setBetweenSetsDuration(sec);
                        cubit.startTimer(
                          seconds: sec,
                          kind: RestKind.betweenSets,
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Persisted defaults
                _SectionLabel(l10n.restSettings),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _DurationStepperTile(
                      icon: Icons.repeat_rounded,
                      iconColor: AppColors.primary,
                      label: l10n.restBetweenSets,
                      seconds: state.preferences.betweenSetsSeconds,
                      onChanged: cubit.setBetweenSetsDuration,
                    ),
                    Divider(height: 1, color: AppColors.ofDivider(context)),
                    _DurationStepperTile(
                      icon: Icons.swap_horiz_rounded,
                      iconColor: AppColors.dropset,
                      label: l10n.restBetweenExercises,
                      seconds: state.preferences.betweenExercisesSeconds,
                      onChanged: cubit.setBetweenExercisesDuration,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 14,
                        color: AppColors.ofTextTertiary(context),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.restGuide,
                          style: AppTypography.ofCaption(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SettingsCard(
                  children: [
                    _SwitchTile(
                      icon: Icons.bolt_rounded,
                      iconColor: AppColors.secondary,
                      label: l10n.autoStartOnSet,
                      value: state.preferences.autoStart,
                      onChanged: cubit.toggleAutoStart,
                    ),
                    Divider(height: 1, color: AppColors.ofDivider(context)),
                    _SwitchTile(
                      icon: Icons.notifications_active_outlined,
                      iconColor: AppColors.warmup,
                      label: l10n.restNotificationsSetting,
                      value: state.preferences.notificationsEnabled,
                      onChanged: cubit.toggleNotifications,
                    ),
                    Divider(height: 1, color: AppColors.ofDivider(context)),
                    _SwitchTile(
                      icon: Icons.vibration_rounded,
                      iconColor: AppColors.dropset,
                      label: l10n.restVibrationSetting,
                      value: state.preferences.vibrationEnabled,
                      onChanged: cubit.toggleVibration,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Private building blocks
// -----------------------------------------------------------------------------

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.ofBorder(context),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text.toUpperCase(),
        style: AppTypography.ofCaption(
          context,
        ).copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _KindPill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _KindPill({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 10, 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryPlayButton extends StatelessWidget {
  final RestTimerState state;
  final List<Color> colors;
  final VoidCallback onPressed;

  const _PrimaryPlayButton({
    required this.state,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final icon = state.isRunning
        ? Icons.pause_rounded
        : (state.isFinished ? Icons.replay_rounded : Icons.play_arrow_rounded);

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Ink(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: colors,
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.first.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
              child: Icon(
                icon,
                key: ValueKey(icon),
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundTextButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _RoundTextButton({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : 0.35,
      child: Material(
        color: AppColors.ofSurfaceElevated(context),
        shape: CircleBorder(
          side: BorderSide(color: AppColors.ofBorder(context)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: SizedBox.square(
            dimension: 52,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ofTextPrimary(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(children: children),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBadge(this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

class _DurationStepperTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int seconds;
  final ValueChanged<int> onChanged;

  const _DurationStepperTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.seconds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 8, 10),
      child: Row(
        children: [
          _IconBadge(icon, iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTypography.ofBody(context))),
          _StepButton(
            icon: Icons.remove_rounded,
            onTap: seconds > RestTimerCubit.minDuration
                ? () => onChanged(seconds - 15)
                : null,
          ),
          SizedBox(
            width: 64,
            child: Text(
              RestTimerState.formatSeconds(seconds),
              textAlign: TextAlign.center,
              style: AppTypography.ofMetricMedium(context),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            onTap: () => onChanged(seconds + 15),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        minimumSize: const Size(40, 40),
        backgroundColor: AppColors.ofSurfaceElevated(context),
        foregroundColor: AppColors.ofTextPrimary(context),
        disabledForegroundColor: AppColors.ofTextPlaceholder(context),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 6, 8, 6),
        child: Row(
          children: [
            _IconBadge(icon, iconColor),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTypography.ofBody(context))),
            Switch(
              value: value,
              activeTrackColor: AppColors.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
