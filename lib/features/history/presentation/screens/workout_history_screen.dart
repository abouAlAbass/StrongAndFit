import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../../../../core/services/ai_report_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../profile/presentation/widgets/ai_key_settings_sheet.dart';
import '../../../workout/domain/models/workout_ai_models.dart';
import '../../../workout/domain/repositories/workout_repository.dart';
import '../widgets/history_ai_analysis_dialog.dart';
import 'workout_history_detail_screen.dart';

/// Screen listing logged past workout sessions and AI progression coaching reports.
class WorkoutHistoryScreen extends StatefulWidget {
  final int initialTabIndex;

  const WorkoutHistoryScreen({super.key, this.initialTabIndex = 0});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AiKeyStorageService _keyStorage = AiKeyStorageService();
  final AiReportStorageService _reportStorage = AiReportStorageService();

  HistoryAiAnalysis? _cachedHistoryAnalysis;
  ProgramAiAnalysis? _cachedProgramAnalysis;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _tabController.index == 1) {
        _loadCachedReports();
      }
    });
    _loadCachedReports();
  }

  Future<void> _loadCachedReports() async {
    final hist = await _reportStorage.getLatestHistoryAnalysis();
    final prog = await _reportStorage.getLatestProgramAnalysis();
    if (mounted) {
      setState(() {
        _cachedHistoryAnalysis = hist;
        _cachedProgramAnalysis = prog;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _triggerHistoryAiAnalysis(List<WorkoutSession> sessions) async {
    final hasKey = await _keyStorage.hasApiKey();
    if (!hasKey) {
      if (!mounted) return;
      final configured = await AiKeySettingsSheet.show(context);
      if (configured != true) return;
    }

    if (!mounted) return;
    await HistoryAiAnalysisDialog.show(context, completedSessions: sessions);
    _loadCachedReports();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repo = context.read<WorkoutRepository>();
    final canPop = Navigator.of(context).canPop();

    return StreamBuilder<List<WorkoutSession>>(
      stream: repo.watchRecentSessions(),
      builder: (context, snapshot) {
        final sessions = snapshot.data ?? [];
        final completed = sessions.where((s) => s.completedAt != null).toList();

        return Scaffold(
          appBar: AppBar(
            leading: canPop
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
            title: Text(
              l10n.workoutHistory,
              style: AppTypography.ofTitleLarge(context),
            ),
            actions: [
              if (completed.isNotEmpty)
                IconButton(
                  tooltip: l10n.aiAnalyzeHistoryButton,
                  icon: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.secondary,
                  ),
                  onPressed: () => _triggerHistoryAiAnalysis(completed),
                ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.ofTextSecondary(context),
              tabs: [
                Tab(
                  icon: const Icon(Icons.fitness_center, size: 20),
                  text: l10n.tabWorkouts,
                ),
                Tab(
                  icon: const Icon(Icons.psychology_rounded, size: 20),
                  text: l10n.tabAiReports,
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Workouts List
              _buildWorkoutsTab(context, l10n, snapshot, completed),

              // Tab 2: AI Coaching Reports
              _buildAiReportsTab(context, l10n, completed),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutsTab(
    BuildContext context,
    AppLocalizations l10n,
    AsyncSnapshot<List<WorkoutSession>> snapshot,
    List<WorkoutSession> completed,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (completed.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_toggle_off,
                size: 64,
                color: AppColors.ofTextTertiary(context),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.emptyHistory,
                style: AppTypography.ofBodySecondary(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    );

    return ResponsiveContentWrapper(
      maxWidth: 780,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 32),
        itemCount: completed.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            // AI Progression Banner at the top of history list
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _triggerHistoryAiAnalysis(completed),
              child: Container(
                margin: const EdgeInsetsDirectional.only(bottom: 6),
                padding: const EdgeInsetsDirectional.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.secondary.withAlpha(120),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
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
                            l10n.aiAnalyzeHistoryButton,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${completed.length} séances • Bilan de surcharge et volume',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ],
                ),
              ),
            );
          }

          final session = completed[index - 1];
          final durationMins = (session.durationSeconds / 60).round();

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      WorkoutHistoryDetailScreen(sessionId: session.id),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                color: AppColors.ofCard(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.ofBorder(context),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.ofCompletedContainer(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.done_all,
                      color: AppColors.completed,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: AppTypography.ofTitleMedium(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(session.startedAt),
                          style: AppTypography.ofCaption(context),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$durationMins min',
                        style: AppTypography.ofMetricMedium(context),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.completed,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.completed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.ofTextTertiary(context),
                    size: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiReportsTab(
    BuildContext context,
    AppLocalizations l10n,
    List<WorkoutSession> completed,
  ) {
    if (_cachedHistoryAnalysis == null && _cachedProgramAnalysis == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsetsDirectional.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  size: 54,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.tabAiReports,
                style: AppTypography.ofTitleLarge(context),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.noAiReportsYet,
                style: AppTypography.ofBodySecondary(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: Text(l10n.aiAnalyzeHistoryButton),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _triggerHistoryAiAnalysis(completed),
              ),
            ],
          ),
        ),
      );
    }

    return ResponsiveContentWrapper(
      maxWidth: 780,
      child: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 32),
        children: [
          // 1. History Progression Report Card
          if (_cachedHistoryAnalysis != null) ...[
            Text(
              l10n.aiHistoryAuditTitle,
              style: AppTypography.ofTitleLarge(context),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                color: AppColors.ofCard(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.secondary.withAlpha(150),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_cachedHistoryAnalysis!.progressionScore}/10',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.aiHistoryScoreLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 20),
                        tooltip: l10n.aiRefreshReport,
                        onPressed: () => _triggerHistoryAiAnalysis(completed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _cachedHistoryAnalysis!.executiveSummary,
                    style: AppTypography.ofBodySecondary(
                      context,
                    ).copyWith(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '⚡ ${_cachedHistoryAnalysis!.progressiveOverloadRate}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '📈 ${_cachedHistoryAnalysis!.volumeTrajectory}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 2. Program Audit Report Card
          if (_cachedProgramAnalysis != null) ...[
            Text(
              l10n.aiProgramAuditTitle,
              style: AppTypography.ofTitleLarge(context),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                color: AppColors.ofCard(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withAlpha(150),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_cachedProgramAnalysis!.programMatchScore}/10',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.aiProgramScoreLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _cachedProgramAnalysis!.summary,
                    style: AppTypography.ofBodySecondary(
                      context,
                    ).copyWith(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _cachedProgramAnalysis!.volumeAssessment,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.completed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Quick trigger button
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.aiAnalyzeHistoryButton),
              onPressed: () => _triggerHistoryAiAnalysis(completed),
            ),
          ),
        ],
      ),
    );
  }
}
