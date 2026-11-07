import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/enums/equipment_type.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';
import 'exercise_list_item.dart';

/// Modal bottom sheet allowing users to select exercises or create custom ones.
class ExercisePickerBottomSheet extends StatelessWidget {
  final ValueChanged<Exercise> onExerciseSelected;

  const ExercisePickerBottomSheet({
    super.key,
    required this.onExerciseSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<Exercise> onExerciseSelected,
  }) {
    final exerciseRepo = context.read<ExerciseRepository>();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => ExerciseListCubit(exerciseRepo),
        child: ExercisePickerBottomSheet(onExerciseSelected: onExerciseSelected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Sheet Grab Handle
              Center(
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 10, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header with Close, Title & Custom Exercise Button
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n.exercises, style: AppTypography.titleLarge),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l10n.customExercise),
                      onPressed: () => showCreateCustomExerciseDialog(context),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchExercises,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  onChanged: (val) {
                    context.read<ExerciseListCubit>().updateSearchQuery(val);
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Muscle Group Filter Chips
              SizedBox(
                height: 38,
                child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
                  buildWhen: (p, c) =>
                      p.selectedMuscleGroup != c.selectedMuscleGroup,
                  builder: (context, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: MuscleGroup.values.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final group = MuscleGroup.values[index];
                        final isSelected = state.selectedMuscleGroup == group;

                        return FilterChip(
                          label: Text(group.localizedName(context)),
                          selected: isSelected,
                          onSelected: (_) {
                            context
                                .read<ExerciseListCubit>()
                                .selectMuscleGroup(group);
                          },
                          backgroundColor: AppColors.surface,
                          selectedColor: AppColors.primaryContainer,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Exercise List
              Expanded(
                child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
                  builder: (context, state) {
                    if (state.status == ExerciseListStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Filter based on search query
                    final query = state.searchQuery.trim().toLowerCase();
                    final filtered = state.exercises.where((e) {
                      if (query.isEmpty) return true;
                      final localizedName = e.localizedName(context).toLowerCase();
                      final slug = e.slug.toLowerCase();
                      final customName = (e.customName ?? '').toLowerCase();
                      return localizedName.contains(query) ||
                          slug.contains(query) ||
                          customName.contains(query);
                    }).toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.emptyTemplates,
                          style: AppTypography.bodySecondary,
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final exercise = filtered[index];
                        return ExerciseListItem(
                          exercise: exercise,
                          onTap: () {
                            Navigator.pop(context);
                            onExerciseSelected(exercise);
                          },
                          trailing: const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.primary,
                            size: 24,
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
  }

  static void showCreateCustomExerciseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final repo = context.read<ExerciseRepository>();
    final cubit = context.read<ExerciseListCubit>();
    final nameController = TextEditingController();
    MuscleGroup selectedGroup = MuscleGroup.chest;
    EquipmentType selectedEquipment = EquipmentType.barbell;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(l10n.customExercise, style: AppTypography.titleLarge),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: l10n.customExercise,
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.muscleGroupChest, style: AppTypography.caption),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<MuscleGroup>(
                    initialValue: selectedGroup,
                    dropdownColor: AppColors.surfaceElevated,
                    decoration: const InputDecoration(),
                    items: MuscleGroup.values.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(g.localizedName(dialogCtx)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedGroup = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.equipmentBarbell, style: AppTypography.caption),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<EquipmentType>(
                    initialValue: selectedEquipment,
                    dropdownColor: AppColors.surfaceElevated,
                    decoration: const InputDecoration(),
                    items: EquipmentType.values.map((eq) {
                      return DropdownMenuItem(
                        value: eq,
                        child: Text(eq.localizedName(dialogCtx)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedEquipment = val);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final text = nameController.text.trim();
                  if (text.isEmpty) return;
                  Navigator.pop(dialogCtx);
                  await repo.createCustomExercise(
                    name: text,
                    muscleGroup: selectedGroup,
                    equipment: selectedEquipment,
                  );
                  cubit.loadExercises();
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );
  }
}
