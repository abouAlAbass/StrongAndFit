import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/services/ai_key_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../exercises/domain/repositories/exercise_repository.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/widgets/ai_key_settings_sheet.dart';
import '../../domain/models/workout_ai_models.dart';
import '../../domain/services/workout_ai_service.dart';
import '../bloc/workout_session_bloc.dart';
import '../bloc/workout_session_event.dart';
import '../cubit/routines_cubit.dart';
import '../screens/workout_session_screen.dart';

/// Interactive modal sheet that creates custom, optimized workout routine templates
/// directly into the app's SQLite database via Google Gemini Generative AI.
class AiRoutineGeneratorDialog extends StatefulWidget {
  final ValueChanged<Locale>? onLocaleChanged;
  final Locale? currentLocale;

  const AiRoutineGeneratorDialog({
    super.key,
    this.onLocaleChanged,
    this.currentLocale,
  });

  static Future<void> show(
    BuildContext context, {
    ValueChanged<Locale>? onLocaleChanged,
    Locale? currentLocale,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: AiRoutineGeneratorDialog(
            onLocaleChanged: onLocaleChanged,
            currentLocale: currentLocale,
          ),
        ),
      ),
    );
  }

  @override
  State<AiRoutineGeneratorDialog> createState() =>
      _AiRoutineGeneratorDialogState();
}

class _AiRoutineGeneratorDialogState extends State<AiRoutineGeneratorDialog> {
  final TextEditingController _promptController = TextEditingController();
  final AiKeyStorageService _keyStorage = AiKeyStorageService();

  bool _isLoading = false;
  String? _errorMessage;
  GeneratedAiRoutine? _generatedRoutine;
  List<({int exerciseId, String name, int targetSets})> _draftExercises = [];

  String _selectedDuration = '45min';
  String _selectedFocus = '';

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateRoutine() async {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.read<ProfileCubit>().state.profile;
    final langCode = Localizations.localeOf(context).languageCode;
    final exerciseRepo = context.read<ExerciseRepository>();

    final userPrompt = _promptController.text.trim();
    if (userPrompt.isEmpty && _selectedFocus.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez saisir vos souhaits ou choisir un focus.';
      });
      return;
    }

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
      final allExercises = await exerciseRepo.watchAllExercises().first;
      if (!mounted) return;
      final localizedNames = <int, String>{};
      final catalog = allExercises.map((e) {
        final locName = e.localizedName(context);
        localizedNames[e.id] = locName;
        return {
          'exercise_id': e.id,
          'exercise_slug': e.slug,
          'exercise_name': locName,
          'muscle_group': e.localizedMuscleGroup(context),
        };
      }).toList();

      final fullPrompt = StringBuffer();
      if (_selectedFocus.isNotEmpty) {
        fullPrompt.write('Objectif focus : $_selectedFocus. ');
      }
      fullPrompt.write('Durée visée : $_selectedDuration. ');
      if (userPrompt.isNotEmpty) {
        fullPrompt.write('Précisions athlète : $userPrompt');
      }

      final aiService = WorkoutAiService(keyStorage: _keyStorage);
      final routine = await aiService.generateRoutine(
        prompt: fullPrompt.toString(),
        availableExercises: catalog,
        athleteName: profile?.name,
        experienceLevel: profile?.experienceLevel.name,
        bodyWeightKg: profile?.weightKg,
        languageCode: langCode,
      );

      // Map generated exercises to validated database exercises
      final validExercises =
          <({int exerciseId, String name, int targetSets})>[];
      for (final rec in routine.exercises) {
        Exercise? matched;
        if (rec.exerciseId > 0) {
          final byId = allExercises.where((e) => e.id == rec.exerciseId);
          if (byId.isNotEmpty) matched = byId.first;
        }
        if (matched == null && rec.exerciseSlug != null) {
          final bySlug = allExercises.where((e) => e.slug == rec.exerciseSlug);
          if (bySlug.isNotEmpty) matched = bySlug.first;
        }
        if (matched != null) {
          validExercises.add((
            exerciseId: matched.id,
            name: localizedNames[matched.id] ?? matched.slug,
            targetSets: rec.targetSets,
          ));
        }
      }

      HapticFeedback.heavyImpact();
      if (mounted) {
        setState(() {
          _generatedRoutine = routine;
          _draftExercises = validExercises;
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

  Future<int?> _persistRoutineInDatabase() async {
    final l10n = AppLocalizations.of(context)!;
    if (_generatedRoutine == null || _draftExercises.isEmpty) return null;

    final templateId = await context.read<RoutinesCubit>().createRoutine(
      name: _generatedRoutine!.name,
      notes: _generatedRoutine!.rationale,
      exercises: _draftExercises
          .map((e) => (exerciseId: e.exerciseId, targetSets: e.targetSets))
          .toList(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.aiRoutineCreatedSuccess),
          backgroundColor: AppColors.completed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    return templateId;
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF387BFF), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
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
                        l10n.aiRoutineGeneratorTitle,
                        style: AppTypography.ofTitleLarge(context),
                      ),
                      Text(
                        'Conception automatique & insertion SQLite',
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

          // Body
          Expanded(
            child: _isLoading
                ? _buildLoadingState(l10n)
                : (_generatedRoutine != null
                      ? _buildPreviewState(l10n)
                      : _buildInputState(l10n)),
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
              'Gemini structure votre séance avec les séries et exercices optimaux...',
              style: AppTypography.ofCaption(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputState(AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
      children: [
        Text(
          l10n.aiRoutineGeneratorSubtitle,
          style: AppTypography.ofBodySecondary(context),
        ),
        const SizedBox(height: 18),

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

        // Quick Focus Chips
        const Text(
          'Structure / Focus ciblé',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChoiceChip(
              label: 'Push (Pecs / Épaules / Triceps)',
              isSelected: _selectedFocus == 'Push',
              onSelected: () => setState(
                () => _selectedFocus = _selectedFocus == 'Push' ? '' : 'Push',
              ),
            ),
            _buildChoiceChip(
              label: 'Pull (Dos / Biceps)',
              isSelected: _selectedFocus == 'Pull',
              onSelected: () => setState(
                () => _selectedFocus = _selectedFocus == 'Pull' ? '' : 'Pull',
              ),
            ),
            _buildChoiceChip(
              label: 'Legs (Cuisses & Fessiers)',
              isSelected: _selectedFocus == 'Legs',
              onSelected: () => setState(
                () => _selectedFocus = _selectedFocus == 'Legs' ? '' : 'Legs',
              ),
            ),
            _buildChoiceChip(
              label: 'Full Body (Corps complet)',
              isSelected: _selectedFocus == 'Full Body',
              onSelected: () => setState(
                () => _selectedFocus = _selectedFocus == 'Full Body'
                    ? ''
                    : 'Full Body',
              ),
            ),
            _buildChoiceChip(
              label: 'Upper Body (Haut du corps)',
              isSelected: _selectedFocus == 'Upper Body',
              onSelected: () => setState(
                () => _selectedFocus = _selectedFocus == 'Upper Body'
                    ? ''
                    : 'Upper Body',
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Duration Chips
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
              label: '⏱ 30 min',
              isSelected: _selectedDuration == '30min',
              onSelected: () => setState(() => _selectedDuration = '30min'),
            ),
            _buildChoiceChip(
              label: '⏱ 45 min',
              isSelected: _selectedDuration == '45min',
              onSelected: () => setState(() => _selectedDuration = '45min'),
            ),
            _buildChoiceChip(
              label: '⏱ 60 min',
              isSelected: _selectedDuration == '60min',
              onSelected: () => setState(() => _selectedDuration = '60min'),
            ),
            _buildChoiceChip(
              label: '⏱ 75 min',
              isSelected: _selectedDuration == '75min',
              onSelected: () => setState(() => _selectedDuration = '75min'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Free prompt input
        Text(
          l10n.aiPromptInputLabel,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _promptController,
          maxLines: 4,
          minLines: 2,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: l10n.aiPromptInputHint,
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

        // Generate Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.auto_awesome, size: 20),
            label: Text(l10n.aiGenerateRoutineButton),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: _generateRoutine,
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewState(AppLocalizations l10n) {
    final routine = _generatedRoutine!;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
      children: [
        // Title & Rationale Header Card
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Généré par Gemini IA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white70,
                      size: 20,
                    ),
                    tooltip: 'Régénérer',
                    onPressed: () => setState(() => _generatedRoutine = null),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                routine.name,
                style: AppTypography.ofTitleLarge(
                  context,
                ).copyWith(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                routine.rationale,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.white70,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Exercises List
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercices planifiés (${_draftExercises.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '${_draftExercises.fold<int>(0, (sum, e) => sum + e.targetSets)} séries au total',
              style: AppTypography.ofCaption(context),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ..._draftExercises.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Container(
            margin: const EdgeInsetsDirectional.only(bottom: 10),
            padding: const EdgeInsetsDirectional.all(12),
            decoration: BoxDecoration(
              color: AppColors.ofCard(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.ofBorder(context),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                // Stepper for target sets
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (item.targetSets > 1) {
                          setState(() {
                            _draftExercises[index] = (
                              exerciseId: item.exerciseId,
                              name: item.name,
                              targetSets: item.targetSets - 1,
                            );
                          });
                        }
                      },
                    ),
                    Text(
                      '${item.targetSets}s',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _draftExercises[index] = (
                            exerciseId: item.exerciseId,
                            name: item.name,
                            targetSets: item.targetSets + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  padding: EdgeInsets.zero,
                  color: AppColors.ofTextTertiary(context),
                  onPressed: () {
                    setState(() {
                      _draftExercises.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),

        // 1. Action: Save to My Routines
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded, size: 20),
            label: Text(l10n.aiSaveRoutineToDatabase),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await _persistRoutineInDatabase();
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ),
        const SizedBox(height: 12),

        // 2. Action: Start Workout Now
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(l10n.aiStartRoutineImmediately),
            onPressed: () async {
              await _persistRoutineInDatabase();
              if (!mounted) return;

              // Find newly created template from RoutinesCubit
              final routines = context.read<RoutinesCubit>().state.templates;
              if (routines.isNotEmpty) {
                final match = routines.firstWhere(
                  (t) => t.template.name == routine.name,
                  orElse: () => routines.first,
                );
                context.read<WorkoutSessionBloc>().add(
                  StartSessionFromTemplateRequested(match),
                );
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WorkoutSessionScreen(
                      currentLocale: widget.currentLocale ?? const Locale('fr'),
                      onLocaleChanged: widget.onLocaleChanged ?? (_) {},
                    ),
                  ),
                );
              }
            },
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
}
