import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/workout_ai_models.dart';

/// Modal dialog displaying structured AI insights from Google Gemini.
class WorkoutAiAnalysisDialog extends StatelessWidget {
  final WorkoutAiAnalysis analysis;
  final String sessionTitle;

  const WorkoutAiAnalysisDialog({
    super.key,
    required this.analysis,
    required this.sessionTitle,
  });

  static Future<void> show(
    BuildContext context, {
    required WorkoutAiAnalysis analysis,
    required String sessionTitle,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: WorkoutAiAnalysisDialog(
            analysis: analysis,
            sessionTitle: sessionTitle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.ofSurfaceElevated(context),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF387BFF), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analyse Préparateur Physique',
                          style: AppTypography.ofTitleLarge(
                            context,
                          ).copyWith(fontSize: 18),
                        ),
                        Text(
                          sessionTitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.ofTextSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.prGold,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${analysis.overallScore}/10',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Overview Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.ofBorder(context).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  analysis.overview,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.ofTextPrimary(context),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Surcharge progressive
              _buildSectionCard(
                context,
                title: 'Surcharge Progressive & Intensité',
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.primary,
                content: analysis.progressiveOverloadAssessment,
              ),
              const SizedBox(height: 12),

              // Fatigue & RPE
              _buildSectionCard(
                context,
                title: 'Récupération & Fatigue (RPE/RIR)',
                icon: Icons.battery_charging_full_rounded,
                iconColor: const Color(0xFF00C7BE),
                content: analysis.recoveryAndRpeAssessment,
              ),
              const SizedBox(height: 12),

              // Points forts
              if (analysis.strengthHighlights.isNotEmpty) ...[
                _buildListCard(
                  context,
                  title: 'Points Forts & Accomplissements',
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColors.completed,
                  items: analysis.strengthHighlights,
                ),
                const SizedBox(height: 12),
              ],

              // Alertes / Plateaux
              if (analysis.plateausOrRisks.isNotEmpty) ...[
                _buildListCard(
                  context,
                  title: 'Points de Vigilance & Risques',
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.warmup,
                  items: analysis.plateausOrRisks,
                ),
                const SizedBox(height: 12),
              ],

              // Recommandations prochain cycle
              if (analysis.nextCycleRecommendations.isNotEmpty) ...[
                _buildListCard(
                  context,
                  title: 'Recommandations pour le prochain cycle',
                  icon: Icons.lightbulb_outline_rounded,
                  iconColor: const Color(0xFFBF5AF2),
                  items: analysis.nextCycleRecommendations,
                ),
                const SizedBox(height: 16),
              ],

              // Close button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Fermer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ofBorder(context).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ofBorder(context).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.ofTextSecondary(context),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ofBorder(context).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ofBorder(context).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.ofTextSecondary(context),
                        height: 1.3,
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
}
