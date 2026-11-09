import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../../../../core/services/ai_report_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/widgets/ai_key_settings_sheet.dart';
import '../../../workout/domain/models/workout_ai_models.dart';
import '../../../workout/domain/services/workout_ai_service.dart';

/// Modal sheet presenting a deep AI Coach audit of the athlete's training progression,
/// longitudinal volume trajectory, muscular balance, and plateau detection.
class HistoryAiAnalysisDialog extends StatefulWidget {
  final List<WorkoutSession> completedSessions;

  const HistoryAiAnalysisDialog({
    super.key,
    required this.completedSessions,
  });

  static Future<void> show(
    BuildContext context, {
    required List<WorkoutSession> completedSessions,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: HistoryAiAnalysisDialog(completedSessions: completedSessions),
        ),
      ),
    );
  }

  @override
  State<HistoryAiAnalysisDialog> createState() =>
      _HistoryAiAnalysisDialogState();
}

class _HistoryAiAnalysisDialogState extends State<HistoryAiAnalysisDialog> {
  final AiKeyStorageService _keyStorage = AiKeyStorageService();
  final AiReportStorageService _reportStorage = AiReportStorageService();

  bool _isLoading = false;
  String? _errorMessage;
  HistoryAiAnalysis? _analysisResult;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final saved = await _reportStorage.getLatestHistoryAnalysis();
    if (saved != null && mounted) {
      setState(() => _analysisResult = saved);
    } else {
      _runAnalysis();
    }
  }

  Future<void> _runAnalysis() async {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.read<ProfileCubit>().state.profile;
    final langCode = Localizations.localeOf(context).languageCode;

    final hasKey = await _keyStorage.hasApiKey();

    if (!hasKey) {
      if (!mounted) return;
      final configured = await AiKeySettingsSheet.show(context);
      if (configured != true) {
        if (_analysisResult == null && mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
    }

    if (widget.completedSessions.isEmpty) {
      if (!mounted) return;
      setState(() {
        _errorMessage = l10n.emptyHistory;
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final historyPayload = widget.completedSessions.take(20).map((s) {
        final durationMins = (s.durationSeconds / 60).round();
        return {
          'title': s.title,
          'date': s.startedAt.toIso8601String(),
          'duration_minutes': durationMins,
          'notes': (s.notes != null && s.notes!.isNotEmpty) ? s.notes : null,
        };
      }).toList();

      final aiService = WorkoutAiService(keyStorage: _keyStorage);
      final analysis = await aiService.analyzeTrainingHistory(
        historicalSessions: historyPayload,
        athleteName: profile?.name,
        experienceLevel: profile?.experienceLevel.name,
        bodyWeightKg: profile?.weightKg,
        languageCode: langCode,
      );

      await _reportStorage.saveHistoryAnalysis(analysis);

      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _analysisResult = analysis;
          _isLoading = false;
        });
      }
    } catch (e) {
      HapticFeedback.selectionClick();
      if (mounted) {
        final errorText = e is AiTimeoutException
            ? l10n.aiTimeoutError
            : (e is AiNetworkException ||
                    e.toString().toLowerCase().contains('socket') ||
                    e.toString().toLowerCase().contains('clientexception') ||
                    e.toString().toLowerCase().contains('failed host lookup')
                ? l10n.networkConnectionError
                : e.toString().replaceAll('Exception: ', ''));

        setState(() {
          _isLoading = false;
          _errorMessage = errorText;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsetsDirectional.only(top: 12, bottom: 8),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.ofBorder(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 6, 12, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aiHistoryAuditTitle,
                        style: AppTypography.ofTitleLarge(context),
                      ),
                      Text(
                        '${widget.completedSessions.length} séances analysées',
                        style: AppTypography.ofCaption(context),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.ofBorder(context), height: 1),

          // Body Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState(l10n)
                : (_errorMessage != null
                    ? _buildErrorState(l10n)
                    : (_analysisResult != null
                        ? _buildResultView(l10n, _analysisResult!)
                        : const SizedBox.shrink())),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              l10n.aiAnalyzingProgress,
              style: AppTypography.ofTitleMedium(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Gemini analyse votre progression, surcharge et assiduité...',
              style: AppTypography.ofCaption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.failure),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Une erreur est survenue.',
              style: AppTypography.ofBodySecondary(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              onPressed: _runAnalysis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(AppLocalizations l10n, HistoryAiAnalysis analysis) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
      children: [
        // Score Header
        Container(
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.secondary, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${analysis.progressionScore}/10',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiHistoryScoreLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      analysis.executiveSummary,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Progressive Overload Quality
        _buildSectionCard(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.primary,
          title: l10n.aiHistoryOverloadAssessment,
          content: analysis.progressiveOverloadRate,
        ),
        const SizedBox(height: 14),

        // Volume Trajectory
        _buildSectionCard(
          icon: Icons.show_chart_rounded,
          iconColor: AppColors.secondary,
          title: l10n.aiHistoryVolumeTrajectory,
          content: analysis.volumeTrajectory,
        ),
        const SizedBox(height: 14),

        // Muscular Distribution Balance
        _buildSectionCard(
          icon: Icons.balance_rounded,
          iconColor: Colors.teal,
          title: l10n.aiHistoryMuscleBalance,
          content: analysis.muscularBalance,
        ),
        const SizedBox(height: 14),

        // Plateaus & Fatigue Alerts
        if (analysis.fatigueAndPlateauAlerts.isNotEmpty) ...[
          _buildBulletCard(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.failure,
            title: l10n.aiHistoryPlateausTitle,
            items: analysis.fatigueAndPlateauAlerts,
          ),
          const SizedBox(height: 14),
        ],

        // Upcoming Cycle Milestones
        if (analysis.nextCycleMilestones.isNotEmpty) ...[
          _buildBulletCard(
            icon: Icons.flag_rounded,
            iconColor: AppColors.completed,
            title: l10n.aiHistoryMilestonesTitle,
            items: analysis.nextCycleMilestones,
          ),
          const SizedBox(height: 24),
        ],

        // Refresh Button
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Actualiser le bilan IA'),
          onPressed: _runAnalysis,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.ofBodySecondary(context)
                .copyWith(fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(top: 6, end: 8),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.ofBodySecondary(context)
                          .copyWith(fontSize: 12.5, height: 1.35),
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
