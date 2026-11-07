import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/rest_timer_cubit.dart';
import '../cubit/rest_timer_state.dart';
import 'rest_progress_ring.dart';
import 'rest_timer_dialog.dart';

/// Floating, high-visibility "Dynamic Island" style rest bar.
///
/// Persists above the bottom navigation across all tabs, shows a live ring,
/// the remaining time, the rest kind (sets vs exercises) and the next exercise,
/// with one-tap -15s / +15s / skip.
class RestTimerFloatingBar extends StatelessWidget {
  const RestTimerFloatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RestTimerCubit, RestTimerState>(
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.bottomCenter,
          child: !state.isActive
              ? const SizedBox(width: double.infinity)
              : _Bar(state: state, l10n: l10n),
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  final RestTimerState state;
  final AppLocalizations l10n;

  const _Bar({required this.state, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestTimerCubit>();
    final colors = RestTimerVisuals.gradientFor(state);
    final accent = colors.first;
    final isFinished = state.isFinished;

    final subtitle = isFinished
        ? l10n.tapToStartNextSet
        : (state.nextExerciseName != null
            ? l10n.nextExercise(state.nextExerciseName!)
            : (RestTimerVisuals.kindLabel(state, l10n) ?? l10n.tapToAdjust));

    return Center(
      child: ConstrainedBox(
        // Keeps the pill elegant on tablets / desktop windows.
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isFinished
                  ? const [Color(0xFF123320), Color(0xFF0F2A1B)]
                  : const [Color(0xFF1C2333), Color(0xFF12151F)],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withValues(alpha: 0.7), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => RestTimerDialog.show(context),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 6, 8),
                child: Row(
                  children: [
                    RestProgressRing(
                      progress: state.progress,
                      size: 40,
                      strokeWidth: 4,
                      colors: colors,
                      child: Icon(
                        isFinished
                            ? Icons.check_rounded
                            : (state.isPaused ? Icons.pause_rounded : Icons.timer_outlined),
                        size: 18,
                        color: isFinished ? AppColors.completed : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isFinished
                                ? l10n.readyToLift
                                : '${RestTimerVisuals.statusLabel(state, l10n)} · ${state.formattedRemaining}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 15,
                              color: isFinished ? AppColors.completed : Colors.white,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11.5,
                              color: isFinished ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isFinished) ...[
                      _QuickButton(label: '-15', onTap: () => cubit.adjustTime(-15)),
                      const SizedBox(width: 6),
                      _QuickButton(label: '+15', onTap: () => cubit.adjustTime(15)),
                    ],
                    IconButton(
                      tooltip: l10n.skip,
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      icon: Icon(
                        isFinished ? Icons.check_circle_rounded : Icons.close_rounded,
                        color: isFinished ? AppColors.completed : AppColors.textTertiary,
                        size: 22,
                      ),
                      onPressed: cubit.stop,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 44, minHeight: 36),
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 0.6),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
