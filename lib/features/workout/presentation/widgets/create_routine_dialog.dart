import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../exercises/presentation/widgets/exercise_picker_bottom_sheet.dart';
import '../cubit/routines_cubit.dart';

/// Modal bottom sheet allowing athletes to build and save a custom workout routine.
class CreateRoutineDialog extends StatefulWidget {
  const CreateRoutineDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: const CreateRoutineDialog(),
        ),
      ),
    );
  }

  @override
  State<CreateRoutineDialog> createState() => _CreateRoutineDialogState();
}

class _DraftRoutineExercise {
  final Exercise exercise;
  int targetSets = 3;

  _DraftRoutineExercise({required this.exercise});
}

class _CreateRoutineDialogState extends State<CreateRoutineDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<_DraftRoutineExercise> _selectedExercises = [];

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveRoutine() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedExercises.isEmpty) return;

    final notes = _notesController.text.trim();
    await context.read<RoutinesCubit>().createRoutine(
      name: name,
      notes: notes.isEmpty ? null : notes,
      exercises: _selectedExercises
          .map((e) => (exerciseId: e.exercise.id, targetSets: e.targetSets))
          .toList(),
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.routineSaved),
          backgroundColor: AppColors.completed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSave =
        _nameController.text.trim().isNotEmpty && _selectedExercises.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: AppColors.ofSurfaceElevated(context),
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
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.createRoutine,
                  style: AppTypography.ofTitleLarge(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.ofTextSecondary(context),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.ofBorder(context), height: 1),

          // Body
          Expanded(
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 24),
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.routineName,
                    hintText: 'e.g. Arnold Split - Chest & Back',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: l10n.notes),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.exercises,
                      style: AppTypography.ofTitleMedium(context),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.addExercise),
                      onPressed: () {
                        ExercisePickerBottomSheet.show(
                          context,
                          onExerciseSelected: (exercise) {
                            setState(() {
                              _selectedExercises.add(
                                _DraftRoutineExercise(exercise: exercise),
                              );
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (_selectedExercises.isEmpty)
                  Container(
                    padding: const EdgeInsetsDirectional.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.ofSurface(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.ofBorder(context)),
                    ),
                    child: Center(
                      child: Text(
                        l10n.addExercise,
                        style: AppTypography.ofBodySecondary(context),
                      ),
                    ),
                  )
                else
                  ..._selectedExercises.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final draft = entry.value;
                    return Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 10),
                      padding: const EdgeInsetsDirectional.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.ofSurface(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.ofBorder(context)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  draft.exercise.localizedName(context),
                                  style: AppTypography.ofBody(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  draft.exercise.localizedMuscleGroup(context),
                                  style: AppTypography.ofCaption(context),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                            ),
                            onPressed: draft.targetSets > 1
                                ? () => setState(() => draft.targetSets--)
                                : null,
                          ),
                          Text(
                            '${draft.targetSets} ${l10n.sets.toLowerCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.ofTextPrimary(context),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                            onPressed: () => setState(() => draft.targetSets++),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.failure,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _selectedExercises.removeAt(idx));
                            },
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          // Save Footer
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.save),
                  onPressed: canSave ? _saveRoutine : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
