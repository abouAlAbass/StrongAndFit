import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// Interactive athlete body weight tracking card featuring:
/// - Reactive chronological LineChart via `fl_chart`
/// - BMI and total delta from initial weigh-in
/// - Quick modal logger with +/- 0.5kg steppers & date selection
/// - Expandable weigh-in history with deletion capabilities
class WeightProgressionCard extends StatelessWidget {
  const WeightProgressionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final logs = state.weightLogs;
        final latestLog = logs.isNotEmpty ? logs.first : null;
        final currentWeight = latestLog?.weightKg ?? state.profile?.weightKg;
        final delta = state.weightDeltaFromStart;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.ofBorder(context), width: 0.8),
          ),
          color: AppColors.ofSurfaceElevated(context),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title & Log Weight Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.75),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.show_chart_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.weightProgression,
                            style: AppTypography.ofTitleMedium(context),
                          ),
                          Text(
                            l10n.weightProgressionSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.ofTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () =>
                          _showAddWeightDialog(context, currentWeight),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        l10n.logWeight,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Metrics Row: Current Weight, Delta, BMI
                if (currentWeight != null) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${currentWeight.toStringAsFixed(1)} kg',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ofTextPrimary(context),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (delta != null) ...[
                        _buildDeltaBadge(context, delta, l10n),
                        const SizedBox(width: 8),
                      ],
                      if (state.bmi != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.ofBorder(
                              context,
                            ).withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${l10n.bmiLabel.contains('IMC') ? 'IMC' : 'BMI'} ${state.bmi!.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ofTextSecondary(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (latestLog != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l10n.lastWeighInDate(
                          DateFormat.yMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(latestLog.loggedAt),
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.ofTextTertiary(context),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],

                // Chart or Empty State
                if (logs.length >= 2) ...[
                  SizedBox(height: 180, child: _buildLineChart(context, logs)),
                  const SizedBox(height: 12),
                ] else if (logs.length == 1) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.ofBorder(context).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.singleWeighInHint(
                              logs.first.weightKg.toString(),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.ofTextSecondary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.ofBorder(context).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        l10n.noWeightHistory,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.ofTextSecondary(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                // History button if logs exist
                if (logs.isNotEmpty)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton.icon(
                      onPressed: () => _showHistorySheet(context, logs),
                      icon: const Icon(Icons.history_rounded, size: 16),
                      label: Text(
                        '${l10n.weightHistory} (${logs.length})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeltaBadge(
    BuildContext context,
    double delta,
    AppLocalizations l10n,
  ) {
    final isLoss = delta < 0;
    final isGain = delta > 0;
    final color = isLoss
        ? AppColors.completed
        : isGain
        ? const Color(0xFF3B82F6)
        : AppColors.ofTextSecondary(context);
    final icon = isLoss
        ? Icons.trending_down_rounded
        : isGain
        ? Icons.trending_up_rounded
        : Icons.remove_rounded;
    final sign = delta > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$sign${delta.toStringAsFixed(1)} kg',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(BuildContext context, List<BodyWeightLog> logs) {
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context).name == 'rtl';

    // Reverse so oldest is at index 0 (left) and newest is at last index (right)
    final chronLogs = logs.reversed.toList();
    final spots = <FlSpot>[];
    double minW = chronLogs.first.weightKg;
    double maxW = chronLogs.first.weightKg;

    for (int i = 0; i < chronLogs.length; i++) {
      final w = chronLogs[i].weightKg;
      spots.add(FlSpot(i.toDouble(), w));
      if (w < minW) minW = w;
      if (w > maxW) maxW = w;
    }

    final minY = (minW - 1.5).floorToDouble();
    final maxY = (maxW + 1.5).ceilToDouble();

    final yTitles = SideTitles(
      showTitles: true,
      reservedSize: 34,
      interval: (maxY - minY) > 6 ? 2 : 1,
      getTitlesWidget: (val, meta) {
        if (val == minY || val == maxY) return const SizedBox.shrink();
        return Text(
          val.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 10,
            color: AppColors.ofTextTertiary(context),
          ),
        );
      },
    );

    return Semantics(
      label:
          '${l10n.weightProgression}: ${chronLogs.length} ${l10n.weightHistory}, ${chronLogs.last.weightKg.toStringAsFixed(1)} kg',
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          minX: 0,
          maxX: (chronLogs.length - 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) > 6 ? 2 : 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.ofBorder(context).withValues(alpha: 0.4),
              strokeWidth: 0.8,
              dashArray: [4, 4],
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: isRtl ? yTitles : const SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: isRtl ? const SideTitles(showTitles: false) : yTitles,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  // Show label on first, last, and every other spot
                  if (idx < 0 || idx >= chronLogs.length) {
                    return const SizedBox.shrink();
                  }
                  if (chronLogs.length > 5 &&
                      idx % 2 != 0 &&
                      idx != chronLogs.length - 1) {
                    return const SizedBox.shrink();
                  }
                  final date = chronLogs[idx].loggedAt;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.Md().format(date),
                      style: TextStyle(
                        fontSize: 9,
                        color: AppColors.ofTextTertiary(context),
                        fontWeight: idx == chronLogs.length - 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final idx = spot.spotIndex;
                  final log = chronLogs[idx];
                  final dateStr = DateFormat.yMMMd().format(log.loggedAt);
                  final noteStr = log.notes != null && log.notes!.isNotEmpty
                      ? '\n${log.notes}'
                      : '';
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} kg\n$dateStr$noteStr',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.primary,
              barWidth: 3.2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final isLast = index == spots.length - 1;
                  return FlDotCirclePainter(
                    radius: isLast ? 5 : 3.5,
                    color: isLast ? Colors.white : AppColors.primary,
                    strokeWidth: isLast ? 3 : 1.5,
                    strokeColor: AppColors.primary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.30),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWeightDialog(BuildContext context, double? initialWeight) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();
    double weight = initialWeight ?? 75.0;
    final weightController = TextEditingController(
      text: weight.toStringAsFixed(1),
    );
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.ofSurfaceElevated(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Modal Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.ofBorder(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  l10n.logWeight,
                  style: AppTypography.ofTitleLarge(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Weight Input Field with Steppers
                Center(
                  child: SizedBox(
                    width: 160,
                    child: TextField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                      decoration: InputDecoration(
                        suffixText: 'kg',
                        suffixStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ofTextSecondary(context),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        final parsed = double.tryParse(
                          val.replaceAll(',', '.'),
                        );
                        if (parsed != null) weight = parsed;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Quick Increment Steppers
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepperChip('-1.0', -1.0, () {
                      weight = (weight - 1.0).clamp(20.0, 300.0);
                      weightController.text = weight.toStringAsFixed(1);
                      setModalState(() {});
                      HapticFeedback.selectionClick();
                    }),
                    const SizedBox(width: 8),
                    _buildStepperChip('-0.5', -0.5, () {
                      weight = (weight - 0.5).clamp(20.0, 300.0);
                      weightController.text = weight.toStringAsFixed(1);
                      setModalState(() {});
                      HapticFeedback.selectionClick();
                    }),
                    const SizedBox(width: 8),
                    _buildStepperChip('+0.5', 0.5, () {
                      weight = (weight + 0.5).clamp(20.0, 300.0);
                      weightController.text = weight.toStringAsFixed(1);
                      setModalState(() {});
                      HapticFeedback.selectionClick();
                    }),
                    const SizedBox(width: 8),
                    _buildStepperChip('+1.0', 1.0, () {
                      weight = (weight + 1.0).clamp(20.0, 300.0);
                      weightController.text = weight.toStringAsFixed(1);
                      setModalState(() {});
                      HapticFeedback.selectionClick();
                    }),
                  ],
                ),
                const SizedBox(height: 16),

                // Date Picker Tile
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(l10n.weighInDate),
                  subtitle: Text(
                    DateFormat.yMMMd(
                      Localizations.localeOf(context).toString(),
                    ).format(selectedDate),
                    style: TextStyle(color: AppColors.ofTextSecondary(context)),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                    child: Text(l10n.edit),
                  ),
                ),

                // Notes Field
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: l10n.weighInNotes,
                    hintText: 'ex. À jeun au réveil',
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.ofBorder(context),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    final finalWeight =
                        double.tryParse(
                          weightController.text.replaceAll(',', '.'),
                        ) ??
                        weight;
                    cubit.logBodyWeight(
                      finalWeight,
                      date: selectedDate,
                      notes: notesController.text.trim().isNotEmpty
                          ? notesController.text.trim()
                          : null,
                    );
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.weighInSaved),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepperChip(String label, double val, VoidCallback onPressed) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      visualDensity: VisualDensity.compact,
    );
  }

  void _showHistorySheet(BuildContext context, List<BodyWeightLog> logs) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.ofSurfaceElevated(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          expand: false,
          builder: (ctx, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: AppColors.ofBorder(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    l10n.weightHistory,
                    style: AppTypography.ofTitleLarge(context),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      bloc: cubit,
                      builder: (context, state) {
                        final currentLogs = state.weightLogs;
                        if (currentLogs.isEmpty) {
                          return Center(child: Text(l10n.noWeightHistory));
                        }
                        return ListView.separated(
                          controller: scrollController,
                          itemCount: currentLogs.length,
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.ofBorder(
                              context,
                            ).withValues(alpha: 0.4),
                            height: 1,
                          ),
                          itemBuilder: (ctx, idx) {
                            final item = currentLogs[idx];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.scale_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                '${item.weightKg.toStringAsFixed(1)} kg',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                '${DateFormat.yMMMd().format(item.loggedAt)}${item.notes != null ? ' • ${item.notes}' : ''}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.ofTextSecondary(context),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                ),
                                color: AppColors.error,
                                tooltip: l10n.deleteWeighIn,
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: ctx,
                                    builder: (dCtx) => AlertDialog(
                                      title: Text(l10n.deleteWeighIn),
                                      content: Text(l10n.deleteWeighInConfirm),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(dCtx, false),
                                          child: Text(l10n.cancel),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(dCtx, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.error,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(l10n.delete),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    cubit.deleteBodyWeightLog(item.id);
                                    HapticFeedback.mediumImpact();
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
