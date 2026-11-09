import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/experience_level.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../../../history/domain/services/workout_export_service.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/muscle_distribution_card.dart';
import '../widgets/weight_progression_card.dart';

/// Athlete Profile screen presenting body metrics, weekly consistency rings,
/// BMI calculations, lifetime training volume, theme toggling, and language options.
class ProfileScreen extends StatelessWidget {
  final ValueChanged<Locale> onLocaleChanged;
  final Locale currentLocale;

  const ProfileScreen({
    super.key,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile, style: AppTypography.ofTitleLarge(context)),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final profile = state.profile;
              if (profile == null) return const SizedBox.shrink();
              return TextButton.icon(
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(l10n.edit),
                onPressed: () {
                  EditProfileDialog.show(
                    context,
                    profile: profile,
                    onSave:
                        ({
                          required name,
                          required weightKg,
                          required heightCm,
                          required weeklyGoal,
                          required experienceLevel,
                        }) {
                          context.read<ProfileCubit>().updateProfileMetrics(
                            name: name,
                            weightKg: weightKg,
                            heightCm: heightCm,
                            weeklyWorkoutGoal: weeklyGoal,
                            experienceLevel: experienceLevel,
                          );
                        },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('Loading profile...'));
          }

          return ResponsiveContentWrapper(
            maxWidth: 780,
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 32),
              children: [
                // 1. Athlete Hero Card
                _buildAthleteHeroCard(context, profile),
                const SizedBox(height: 16),

                // 2. Weekly Consistency Tracker Card
                _buildWeeklyConsistencyCard(context, state),
                const SizedBox(height: 16),

                // 3. Biometrics & Lifetime Performance Metrics Grid
                _buildMetricsGrid(context, state),
                const SizedBox(height: 16),

                // 4. Body Weight Tracking & Progression Chart
                const WeightProgressionCard(),
                const SizedBox(height: 16),

                // 5. Muscle Group Volume Distribution Card
                MuscleDistributionCard(distribution: state.muscleDistribution),
                const SizedBox(height: 20),

                // 5. Settings, Theme & Language Card
                _buildSettingsCard(context),
                const SizedBox(height: 20),

                // 6. Data Backup & Export Card (CSV / JSON)
                _buildExportCard(context),
                const SizedBox(height: 20),

                // 7. Danger Zone / Delete Profile Card
                _buildDangerZoneCard(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAthleteHeroCard(BuildContext context, dynamic profile) {
    final l10n = AppLocalizations.of(context)!;
    final levelLabel = _getExperienceLevelLabel(profile.experienceLevel, l10n);

    return Container(
      padding: const EdgeInsetsDirectional.all(18),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Row(
        children: [
          // Avatar circle with athletic badge
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: Image.asset(
                'assets/icons/app_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name & Experience Level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: AppTypography.ofDisplay(
                    context,
                  ).copyWith(fontSize: 22),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ofPrimaryContainer(context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    levelLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyConsistencyCard(BuildContext context, ProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final goal = state.profile?.weeklyWorkoutGoal ?? 4;
    final completed = state.weeklyCompletedCount;
    final progress = state.weeklyProgress;

    return Container(
      padding: const EdgeInsetsDirectional.all(18),
      decoration: BoxDecoration(
        color: AppColors.ofSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.consistencyScore,
                style: AppTypography.ofTitleMedium(context),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.completed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.workoutsDoneThisWeek(completed, goal),
            style: AppTypography.ofBodySecondary(context),
          ),
          const SizedBox(height: 14),

          // Linear Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.ofInputBackground(context),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? AppColors.completed : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Daily Workout Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(goal, (index) {
              final isDone = index < completed;
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDone
                      ? AppColors.ofCompletedContainer(context)
                      : AppColors.ofSurfaceElevated(context),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? AppColors.completed
                        : AppColors.ofBorder(context),
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.fitness_center_outlined,
                  size: 16,
                  color: isDone
                      ? AppColors.completed
                      : AppColors.ofTextTertiary(context),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, ProfileState state) {
    final l10n = AppLocalizations.of(context)!;
    final profile = state.profile!;
    final bmi = state.bmi;
    final lifetimeStats = state.lifetimeStats;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
        final aspectRatio = constraints.maxWidth > 500 ? 1.25 : 1.45;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: aspectRatio,
          children: [
            // 1. Weight
            _buildMetricTile(
              context: context,
              label: l10n.weightKg,
              value: profile.weightKg != null
                  ? '${profile.weightKg!.toStringAsFixed(1)} kg'
                  : '—',
              icon: Icons.monitor_weight_outlined,
              accentColor: AppColors.primary,
            ),

            // 2. Height
            _buildMetricTile(
              context: context,
              label: l10n.heightCm,
              value: profile.heightCm != null
                  ? '${profile.heightCm!.toStringAsFixed(0)} cm'
                  : '—',
              icon: Icons.straighten_outlined,
              accentColor: AppColors.secondary,
            ),

            // 3. BMI
            _buildMetricTile(
              context: context,
              label: l10n.bmiLabel,
              value: bmi != null ? bmi.toStringAsFixed(1) : '—',
              subtitle: bmi != null ? _getBmiClassification(bmi) : null,
              icon: Icons.health_and_safety_outlined,
              accentColor: AppColors.warmup,
            ),

            // 4. Total Volume Lifted
            _buildMetricTile(
              context: context,
              label: l10n.totalVolumeLifted,
              value: lifetimeStats != null
                  ? '${lifetimeStats.totalVolumeKg.toStringAsFixed(0)} kg'
                  : '0 kg',
              icon: Icons.fitness_center,
              accentColor: AppColors.completed,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile({
    required BuildContext context,
    required String label,
    required String value,
    String? subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.ofCaption(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 18, color: accentColor),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.ofMetricLarge(
                  context,
                ).copyWith(fontSize: 20),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentThemeMode = context.watch<ThemeCubit>().state;
    final isDark = currentThemeMode == ThemeMode.dark;

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.appSettings, style: AppTypography.ofTitleMedium(context)),
          const SizedBox(height: 14),

          // Theme Selector (Dark / Light / System)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isDark
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(l10n.themeMode, style: AppTypography.ofBody(context)),
                ],
              ),
              DropdownButton<ThemeMode>(
                value: currentThemeMode,
                dropdownColor: AppColors.ofSurfaceElevated(context),
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.themeDark),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.themeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.themeSystem),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    context.read<ThemeCubit>().setThemeMode(mode);
                  }
                },
              ),
            ],
          ),
          const Divider(height: 20),

          // Language Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.language,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.languageSelection,
                    style: AppTypography.ofBody(context),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: currentLocale.languageCode,
                dropdownColor: AppColors.ofSurfaceElevated(context),
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English (EN)')),
                  DropdownMenuItem(value: 'fr', child: Text('Français (FR)')),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية (AR - RTL)'),
                  ),
                ],
                onChanged: (code) {
                  if (code != null) {
                    onLocaleChanged(Locale(code));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getExperienceLevelLabel(
    ExperienceLevel level,
    AppLocalizations l10n,
  ) {
    switch (level) {
      case ExperienceLevel.beginner:
        return l10n.beginner;
      case ExperienceLevel.intermediate:
        return l10n.intermediate;
      case ExperienceLevel.advanced:
        return l10n.advanced;
    }
  }

  String _getBmiClassification(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Healthy / Athletic';
    if (bmi < 30.0) return 'Overweight';
    return 'High Mass';
  }

  Widget _buildExportCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    WorkoutExportService? exportService;
    try {
      exportService = context.read<WorkoutExportService>();
    } catch (_) {}

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ofBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.download_rounded,
                color: AppColors.secondary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.exportSectionTitle,
                style: AppTypography.ofTitleMedium(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // CSV Export Option (Excel / Strong / Hevy)
          InkWell(
            onTap: () async {
              if (exportService == null) return;
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.exportInProgress),
                    duration: const Duration(seconds: 1),
                  ),
                );
                await exportService.shareCsv();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Export error: $e')));
                }
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                color: AppColors.ofSurface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.ofBorder(context),
                  width: 0.6,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.table_chart_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.exportCsvTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.exportCsvSubtitle,
                          style: AppTypography.ofCaption(context),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.ios_share_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // JSON Backup Option
          InkWell(
            onTap: () async {
              if (exportService == null) return;
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.exportInProgress),
                    duration: const Duration(seconds: 1),
                  ),
                );
                await exportService.shareJson();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Backup error: $e')));
                }
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsetsDirectional.all(12),
              decoration: BoxDecoration(
                color: AppColors.ofSurface(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.ofBorder(context),
                  width: 0.6,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.data_object_rounded,
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
                          l10n.exportJsonTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.exportJsonSubtitle,
                          style: AppTypography.ofCaption(context),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.backup_outlined,
                    size: 20,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: AppColors.ofCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.failure.withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.failure,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.dangerZone,
                style: AppTypography.ofTitleMedium(context).copyWith(
                  color: AppColors.failure,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.deleteProfileDesc, style: AppTypography.ofCaption(context)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.delete_forever_rounded, size: 18),
              label: Text(l10n.deleteProfile),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.failure,
                side: const BorderSide(color: AppColors.failure),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _confirmDeleteProfile(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProfile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.ofCard(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.failure),
            const SizedBox(width: 8),
            Text(
              l10n.deleteProfileConfirmTitle,
              style: AppTypography.ofTitleLarge(context),
            ),
          ],
        ),
        content: Text(
          l10n.deleteProfileConfirmMessage,
          style: AppTypography.ofBodySecondary(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.failure,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await context.read<ProfileCubit>().deleteProfileAndData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.failure,
                    content: Text(l10n.profileDeletedSuccess),
                  ),
                );
              }
            },
            child: Text(l10n.deletePermanently),
          ),
        ],
      ),
    );
  }
}
