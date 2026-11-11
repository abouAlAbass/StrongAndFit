import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/muscle_group.dart';
import '../../../../core/l10n/exercise_translation_helper.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/responsive_content_wrapper.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';
import '../widgets/exercise_guide_sheet.dart';
import '../widgets/exercise_list_item.dart';
import '../widgets/exercise_picker_bottom_sheet.dart';
import 'exercise_display_showcase_screen.dart';

/// Full screen catalogue of default and custom exercises with responsive layout.
class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exercises, style: AppTypography.ofTitleLarge(context)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.science_outlined,
              color: AppColors.secondary,
            ),
            tooltip: 'Labo Visuel Exercices (Prototype)',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ExerciseDisplayShowcaseScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            tooltip: l10n.customExercise,
            onPressed: () {
              ExercisePickerBottomSheet.showCreateCustomExerciseDialog(context);
            },
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 780,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchExercises,
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.ofTextTertiary(context),
                  ),
                ),
                onChanged: (val) {
                  context.read<ExerciseListCubit>().updateSearchQuery(val);
                },
              ),
            ),

            // Muscle Group Horizontal Filters
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
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final group = MuscleGroup.values[index];
                      final isSelected = state.selectedMuscleGroup == group;

                      return FilterChip(
                        label: Text(group.localizedName(context)),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<ExerciseListCubit>().selectMuscleGroup(
                            group,
                          );
                        },
                        backgroundColor: AppColors.ofSurface(context),
                        selectedColor: AppColors.ofPrimaryContainer(context),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.ofBorder(context),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.ofTextSecondary(context),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Exercises List
            Expanded(
              child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
                builder: (context, state) {
                  if (state.status == ExerciseListStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final query = state.searchQuery.trim().toLowerCase();
                  final filtered = state.exercises.where((e) {
                    if (query.isEmpty) return true;
                    final localizedName = e
                        .localizedName(context)
                        .toLowerCase();
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
                        style: AppTypography.ofBodySecondary(context),
                      ),
                    );
                  }

                  return ListView.builder(
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
                          ExerciseGuideSheet.show(
                            context,
                            slug: exercise.slug,
                            exerciseName: exercise.localizedName(context),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
