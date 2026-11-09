import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import 'package:strong/features/workout/domain/repositories/workout_repository.dart';
import 'workout_history_detail_screen.dart';

/// Screen listing logged past workout sessions from the offline SQLite database.
class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repo = context.read<WorkoutRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workoutHistory,
          style: AppTypography.ofTitleLarge(context),
        ),
      ),
      body: StreamBuilder<List<WorkoutSession>>(
        stream: repo.watchRecentSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data ?? [];
          final completed = sessions
              .where((s) => s.completedAt != null)
              .toList();

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
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              itemCount: completed.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final session = completed[index];
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
        },
      ),
    );
  }
}
