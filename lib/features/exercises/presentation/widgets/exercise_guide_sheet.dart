import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/daos/workout_dao.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../workout/domain/repositories/workout_repository.dart';
import '../../data/exercise_guides_data.dart';
import '../../domain/models/exercise_guide.dart';

/// Responsive, modern modal sheet presenting biomechanical execution guidelines,
/// anatomical targeting, breathing mechanics, and injury-prevention coaching cues.
class ExerciseGuideSheet extends StatelessWidget {
  final ExerciseGuide guide;

  const ExerciseGuideSheet({
    super.key,
    required this.guide,
  });

  /// Displays the guide bottom sheet responsively with tablet/desktop centering.
  static Future<void> show(
    BuildContext context, {
    required String slug,
    required String exerciseName,
  }) {
    final locale = Localizations.localeOf(context);
    final guide = ExerciseGuidesData.getGuide(
      slug,
      locale.languageCode,
      displayName: exerciseName,
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: ExerciseGuideSheet(guide: guide),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsetsDirectional.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header: Exercise Title & Close Button
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.title,
                        style: AppTypography.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        l10n.techniqueGuide,
                        style: AppTypography.caption.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 36),
              children: [
                // 1. Rep-Range & Tempo Badges
                _buildMetricsBanner(context, l10n),
                const SizedBox(height: 20),

                // 1b. Historical 1RM Progression Chart (if logged sessions exist)
                _buildProgressionSection(context, l10n),

                // 2. Targeted Anatomy (Primary & Secondary Muscles)
                _buildSectionHeader(
                  title: l10n.targetMuscles,
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: 10),
                _buildMusclesSection(context, l10n),
                const SizedBox(height: 20),

                // 3. Setup & Posture
                _buildSectionHeader(
                  title: l10n.setupInstructions,
                  icon: Icons.accessibility_new_rounded,
                  iconColor: AppColors.secondary,
                ),
                const SizedBox(height: 10),
                _buildStepList(guide.setupInstructions, stepColor: AppColors.secondary),
                const SizedBox(height: 20),

                // 4. Execution & Movement Path
                _buildSectionHeader(
                  title: l10n.executionInstructions,
                  icon: Icons.play_circle_outline_rounded,
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: 10),
                _buildStepList(guide.executionInstructions, stepColor: AppColors.primary),
                const SizedBox(height: 20),

                // 5. Breathing Protocol
                _buildBreathingCard(context, l10n),
                const SizedBox(height: 16),

                // 6. Common Mistakes Warning Card
                _buildCommonMistakesCard(context, l10n),
                const SizedBox(height: 16),

                // 7. Coach Tip Callout
                _buildCoachTipCard(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsBanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            label: l10n.hypertrophyRange,
            value: guide.hypertrophyRepRange,
            icon: Icons.bolt_rounded,
            color: AppColors.primary,
          ),
          Container(width: 1, height: 38, color: AppColors.border),
          _buildMetricItem(
            label: l10n.strengthRange,
            value: guide.strengthRepRange,
            icon: Icons.fitness_center_rounded,
            color: AppColors.prGold,
          ),
          Container(width: 1, height: 38, color: AppColors.border),
          _buildMetricItem(
            label: l10n.tempo,
            value: guide.tempo,
            icon: Icons.timer_outlined,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMusclesSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l10n.primaryMuscles,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: guide.primaryMuscles.map((m) {
                    return Container(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary.withAlpha(80)),
                      ),
                      child: Text(
                        m,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (guide.secondaryMuscles.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF132E27),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.secondaryMuscles,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: guide.secondaryMuscles.map((m) {
                      return Container(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          m,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepList(List<String> steps, {required Color stepColor}) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final stepText = entry.value;

        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: stepColor.withAlpha(40),
                  shape: BoxShape.circle,
                  border: Border.all(color: stepColor, width: 1.2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: stepColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 2),
                  child: Text(
                    stepText,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBreathingCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2327),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withAlpha(90), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.air_rounded, color: AppColors.secondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.breathingInstructions,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guide.breathingInstructions,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonMistakesCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B1917),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withAlpha(120), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.commonMistakes,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...guide.commonMistakes.map(
            (mistake) => Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: const TextStyle(color: AppColors.error, fontSize: 16)),
                  Expanded(
                    child: Text(
                      mistake,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachTipCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(6),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.coachTip,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guide.coachTip,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressionSection(BuildContext context, AppLocalizations l10n) {
    WorkoutRepository? workoutRepo;
    try {
      workoutRepo = context.read<WorkoutRepository>();
    } catch (_) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<ExerciseProgressionPoint>>(
      future: workoutRepo.fetchExerciseProgressionBySlug(guide.slug),
      builder: (context, snapshot) {
        final points = snapshot.data ?? [];
        if (points.isEmpty) return const SizedBox.shrink();

        final latest = points.last;
        final max1Rm = points
            .map((p) => p.estimatedOneRepMax)
            .reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 20),
          child: Container(
            padding: const EdgeInsetsDirectional.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.show_chart_rounded,
                          color: AppColors.completed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.progressionHistory,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${l10n.estimatedOneRepMax}: ${max1Rm.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.prGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 72,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _ProgressionChartPainter(points: points),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${points.length} ${l10n.completed.toLowerCase()} • ${latest.maxWeightKg.toStringAsFixed(1)} kg',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProgressionChartPainter extends CustomPainter {
  final List<ExerciseProgressionPoint> points;

  _ProgressionChartPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final values = points.map((p) => p.estimatedOneRepMax).toList();
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal) <= 0 ? 1.0 : (maxVal - minVal);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? size.width / 2
          : (i / (points.length - 1)) * (size.width - 16) + 8;
      final normalizedY = (points[i].estimatedOneRepMax - minVal) / range;
      final y = size.height - 10 - (normalizedY * (size.height - 20));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    if (points.length > 1) {
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressionChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
