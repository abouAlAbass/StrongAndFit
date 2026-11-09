import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/daos/template_dao.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../../../../core/services/ai_report_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/widgets/ai_key_settings_sheet.dart';
import '../../domain/models/workout_ai_models.dart';
import '../../domain/services/workout_ai_service.dart';
import 'ai_routine_generator_dialog.dart';

/// Interactive modal sheet allowing athletes to audit their workout program/routine
/// using Google Gemini AI, featuring interactive questions and free-text custom requests.
class ProgramAiAnalysisDialog extends StatefulWidget {
  final TemplateDetail template;

  const ProgramAiAnalysisDialog({super.key, required this.template});

  static Future<void> show(
    BuildContext context, {
    required TemplateDetail template,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ProgramAiAnalysisDialog(template: template),
        ),
      ),
    );
  }

  @override
  State<ProgramAiAnalysisDialog> createState() =>
      _ProgramAiAnalysisDialogState();
}

class _ProgramAiAnalysisDialogState extends State<ProgramAiAnalysisDialog> {
  final TextEditingController _notesController = TextEditingController();
  final AiKeyStorageService _keyStorage = AiKeyStorageService();
  final AiReportStorageService _reportStorage = AiReportStorageService();

  // Questionnaire state
  String _fatigueLevel = 'fresh';
  String _targetFocus = 'balanced';
  String _sessionDuration = '60min';
  String _painArea = 'none';

  bool _isLoading = false;
  String? _errorMessage;
  ProgramAiAnalysis? _analysisResult;

  @override
  void initState() {
    super.initState();
    _loadSavedReport();
  }

  Future<void> _loadSavedReport() async {
    final saved = await _reportStorage.getLatestProgramAnalysis();
    if (saved != null && mounted) {
      setState(() => _analysisResult = saved);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _runAnalysis() async {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.read<ProfileCubit>().state.profile;
    final langCode = Localizations.localeOf(context).languageCode;
    final exercisesData = widget.template.exercises.map((item) {
      return {
        'name': item.exercise.localizedName(context),
        'muscle_group': item.exercise.localizedMuscleGroup(context),
        'target_sets': item.templateExercise.targetSets,
        'notes': ?item.templateExercise.notes,
      };
    }).toList();

    final hasKey = await _keyStorage.hasApiKey();

    if (!hasKey) {
      if (!mounted) return;
      final configured = await AiKeySettingsSheet.show(context);
      if (configured != true) return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final questionnaire = ProgramAiQuestionnaire(
        fatigueLevel: _resolveFatigueText(l10n),
        targetFocus: _resolveFocusText(l10n),
        sessionDuration: _sessionDuration,
        painOrInjuries: _resolvePainText(l10n),
        freeTextNotes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      final aiService = WorkoutAiService(keyStorage: _keyStorage);
      final analysis = await aiService.analyzeProgram(
        programName: widget.template.template.name,
        programNotes: widget.template.template.notes,
        exercises: exercisesData,
        questionnaire: questionnaire,
        athleteName: profile?.name,
        experienceLevel: profile?.experienceLevel.name,
        bodyWeightKg: profile?.weightKg,
        languageCode: langCode,
      );

      await _reportStorage.saveProgramAnalysis(analysis);

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

  String _resolveFatigueText(AppLocalizations l10n) {
    switch (_fatigueLevel) {
      case 'fresh':
        return l10n.aiFatigueFresh;
      case 'exhausted':
        return l10n.aiFatigueExhausted;
      case 'moderate':
      default:
        return l10n.aiFatigueModerate;
    }
  }

  String _resolveFocusText(AppLocalizations l10n) {
    switch (_targetFocus) {
      case 'chest':
        return l10n.aiFocusChest;
      case 'back':
        return l10n.aiFocusBack;
      case 'legs':
        return l10n.aiFocusLegs;
      case 'shoulders_arms':
        return l10n.aiFocusShouldersArms;
      case 'balanced':
      default:
        return l10n.aiFocusBalanced;
    }
  }

  String _resolvePainText(AppLocalizations l10n) {
    switch (_painArea) {
      case 'shoulders':
        return l10n.aiPainShoulders;
      case 'lower_back':
        return l10n.aiPainLowerBack;
      case 'knees':
        return l10n.aiPainKnees;
      case 'elbows_wrists':
        return l10n.aiPainElbowsWrists;
      case 'none':
      default:
        return l10n.aiPainNone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      padding: EdgeInsets.only(bottom: keyboardSpace),
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
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
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
                        l10n.aiProgramAuditTitle,
                        style: AppTypography.ofTitleLarge(context),
                      ),
                      Text(
                        widget.template.template.name,
                        style: AppTypography.ofCaption(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                : (_analysisResult != null
                      ? _buildAnalysisResultView(l10n, _analysisResult!)
                      : _buildQuestionnaireView(l10n)),
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
              l10n.aiProgramAnalyzingHint,
              style: AppTypography.ofCaption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionnaireView(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
      children: [
        Text(
          l10n.aiProgramAuditSubtitle,
          style: AppTypography.ofBodySecondary(context),
        ),
        const SizedBox(height: 20),

        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              color: AppColors.failure.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.failure, width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.failure,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppColors.failure,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 1. Fatigue & Recovery
        Text(
          l10n.aiFatigueQuestion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              label: '🟢 ${l10n.aiFatigueFresh}',
              isSelected: _fatigueLevel == 'fresh',
              onSelected: () => setState(() => _fatigueLevel = 'fresh'),
            ),
            _buildChoiceChip(
              label: '🟡 ${l10n.aiFatigueModerate}',
              isSelected: _fatigueLevel == 'moderate',
              onSelected: () => setState(() => _fatigueLevel = 'moderate'),
            ),
            _buildChoiceChip(
              label: '🔴 ${l10n.aiFatigueExhausted}',
              isSelected: _fatigueLevel == 'exhausted',
              onSelected: () => setState(() => _fatigueLevel = 'exhausted'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 2. Priority Target Muscle Group
        Text(
          l10n.aiWeakPointQuestion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              label: l10n.aiFocusBalanced,
              isSelected: _targetFocus == 'balanced',
              onSelected: () => setState(() => _targetFocus = 'balanced'),
            ),
            _buildChoiceChip(
              label: l10n.aiFocusChest,
              isSelected: _targetFocus == 'chest',
              onSelected: () => setState(() => _targetFocus = 'chest'),
            ),
            _buildChoiceChip(
              label: l10n.aiFocusBack,
              isSelected: _targetFocus == 'back',
              onSelected: () => setState(() => _targetFocus = 'back'),
            ),
            _buildChoiceChip(
              label: l10n.aiFocusLegs,
              isSelected: _targetFocus == 'legs',
              onSelected: () => setState(() => _targetFocus = 'legs'),
            ),
            _buildChoiceChip(
              label: l10n.aiFocusShouldersArms,
              isSelected: _targetFocus == 'shoulders_arms',
              onSelected: () => setState(() => _targetFocus = 'shoulders_arms'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 3. Target Duration
        Text(
          l10n.aiTimeConstraintQuestion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              label: '⏱ 45 min',
              isSelected: _sessionDuration == '45min',
              onSelected: () => setState(() => _sessionDuration = '45min'),
            ),
            _buildChoiceChip(
              label: '⏱ 60 min',
              isSelected: _sessionDuration == '60min',
              onSelected: () => setState(() => _sessionDuration = '60min'),
            ),
            _buildChoiceChip(
              label: '⏱ 75 min',
              isSelected: _sessionDuration == '75min',
              onSelected: () => setState(() => _sessionDuration = '75min'),
            ),
            _buildChoiceChip(
              label: '⏱ 90 min',
              isSelected: _sessionDuration == '90min',
              onSelected: () => setState(() => _sessionDuration = '90min'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // 4. Joint Discomfort / Injuries
        Text(
          l10n.aiPainQuestion,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              label: '🛡️ ${l10n.aiPainNone}',
              isSelected: _painArea == 'none',
              onSelected: () => setState(() => _painArea = 'none'),
            ),
            _buildChoiceChip(
              label: l10n.aiPainShoulders,
              isSelected: _painArea == 'shoulders',
              onSelected: () => setState(() => _painArea = 'shoulders'),
            ),
            _buildChoiceChip(
              label: l10n.aiPainLowerBack,
              isSelected: _painArea == 'lower_back',
              onSelected: () => setState(() => _painArea = 'lower_back'),
            ),
            _buildChoiceChip(
              label: l10n.aiPainKnees,
              isSelected: _painArea == 'knees',
              onSelected: () => setState(() => _painArea = 'knees'),
            ),
            _buildChoiceChip(
              label: l10n.aiPainElbowsWrists,
              isSelected: _painArea == 'elbows_wrists',
              onSelected: () => setState(() => _painArea = 'elbows_wrists'),
            ),
          ],
        ),
        const SizedBox(height: 22),

        // 5. Free Text Input (User specific requests & custom notes)
        Text(
          l10n.aiFreeTextLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 4,
          minLines: 2,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: l10n.aiFreeTextHint,
            hintStyle: TextStyle(
              color: AppColors.ofTextTertiary(context),
              fontSize: 12.5,
            ),
            filled: true,
            fillColor: AppColors.ofInputBackground(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.ofBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.ofBorder(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsetsDirectional.all(14),
          ),
        ),
        const SizedBox(height: 28),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome, size: 20),
            label: Text(l10n.aiLaunchProgramAudit),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _runAnalysis,
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withAlpha(40),
      labelStyle: TextStyle(
        fontSize: 12.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected
            ? AppColors.primary
            : AppColors.ofTextPrimary(context),
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.ofBorder(context),
        width: isSelected ? 1.4 : 0.8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: AppColors.ofSurfaceElevated(context),
    );
  }

  Widget _buildAnalysisResultView(
    AppLocalizations l10n,
    ProgramAiAnalysis analysis,
  ) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
      children: [
        // Score Card
        Container(
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${analysis.programMatchScore}/10',
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
                      l10n.aiProgramScoreLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      analysis.summary,
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

        // Volume Assessment
        _buildSectionCard(
          icon: Icons.pie_chart_rounded,
          iconColor: AppColors.secondary,
          title: 'Volume & Répartition',
          content: analysis.volumeAssessment,
        ),
        const SizedBox(height: 14),

        // Customized Modifications & Exercise Substitutions
        if (analysis.customizedModifications.isNotEmpty) ...[
          _buildBulletCard(
            icon: Icons.tune_rounded,
            iconColor: AppColors.primary,
            title: l10n.aiProgramModificationsTitle,
            items: analysis.customizedModifications,
          ),
          const SizedBox(height: 14),
        ],

        // Biomechanics & Injury Prevention
        if (analysis.injuryPreventionTips.isNotEmpty) ...[
          _buildBulletCard(
            icon: Icons.health_and_safety_rounded,
            iconColor: AppColors.failure,
            title: l10n.aiProgramInjuryTipsTitle,
            items: analysis.injuryPreventionTips,
          ),
          const SizedBox(height: 14),
        ],

        // Periodization & Cycle Strategy
        if (analysis.periodizationAdvice.isNotEmpty) ...[
          _buildBulletCard(
            icon: Icons.calendar_month_rounded,
            iconColor: AppColors.completed,
            title: l10n.aiProgramPeriodizationTitle,
            items: analysis.periodizationAdvice,
          ),
          const SizedBox(height: 24),
        ],

        // Create AI Variant / Generated Routine Button
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: Text(l10n.aiCreateOptimizedVariant),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              AiRoutineGeneratorDialog.show(context);
            },
          ),
        ),
        const SizedBox(height: 12),

        // Re-analyze Button
        OutlinedButton.icon(
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(l10n.aiModifyCriteriaAndReanalyze),
          onPressed: () => setState(() => _analysisResult = null),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.ofBodySecondary(
              context,
            ).copyWith(fontSize: 12.5, height: 1.4),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
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
                      style: AppTypography.ofBodySecondary(
                        context,
                      ).copyWith(fontSize: 12.5, height: 1.35),
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
