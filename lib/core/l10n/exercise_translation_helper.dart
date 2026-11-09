import 'package:flutter/widgets.dart';
import '../database/app_database.dart';
import '../enums/equipment_type.dart';
import '../enums/muscle_group.dart';
import '../enums/set_type.dart';
import 'generated/app_localizations.dart';

/// Translation resolver bridging the gap between canonical database slugs/enums
/// and dynamic, locale-aware strings (`en`, `fr`, `ar`).
class ExerciseTranslationHelper {
  ExerciseTranslationHelper._();

  /// Maps a canonical exercise slug (e.g., 'bench_press') to its localized translation.
  static String? resolveDefaultExerciseName(
    String slug,
    AppLocalizations l10n,
  ) {
    switch (slug) {
      case 'bench_press':
        return l10n.exercise_bench_press;
      case 'incline_dumbbell_press':
        return l10n.exercise_incline_dumbbell_press;
      case 'push_up':
        return l10n.exercise_push_up;
      case 'deadlift':
        return l10n.exercise_deadlift;
      case 'barbell_row':
        return l10n.exercise_barbell_row;
      case 'pull_up':
        return l10n.exercise_pull_up;
      case 'lat_pulldown':
        return l10n.exercise_lat_pulldown;
      case 'squat':
        return l10n.exercise_squat;
      case 'leg_press':
        return l10n.exercise_leg_press;
      case 'romanian_deadlift':
        return l10n.exercise_romanian_deadlift;
      case 'overhead_press':
        return l10n.exercise_overhead_press;
      case 'lateral_raise':
        return l10n.exercise_lateral_raise;
      case 'barbell_curl':
        return l10n.exercise_barbell_curl;
      case 'triceps_pushdown':
        return l10n.exercise_triceps_pushdown;
      case 'plank':
        return l10n.exercise_plank;
      case 'hanging_leg_raise':
        return l10n.exercise_hanging_leg_raise;
      default:
        return null;
    }
  }

  /// Master resolver for exercise titles:
  /// - Returns [customName] directly if [exercise.isCustom] is true.
  /// - Otherwise resolves the active locale's string via [slug].
  /// - Falls back gracefully if an unmapped slug is encountered.
  static String resolveExerciseName(Exercise exercise, AppLocalizations l10n) {
    if (exercise.isCustom &&
        exercise.customName != null &&
        exercise.customName!.trim().isNotEmpty) {
      return exercise.customName!;
    }
    return resolveDefaultExerciseName(exercise.slug, l10n) ??
        exercise.customName ??
        exercise.slug.replaceAll('_', ' ').toUpperCase();
  }

  /// Resolves the localized display label for a [MuscleGroup].
  static String resolveMuscleGroup(MuscleGroup group, AppLocalizations l10n) {
    switch (group) {
      case MuscleGroup.chest:
        return l10n.muscleGroupChest;
      case MuscleGroup.back:
        return l10n.muscleGroupBack;
      case MuscleGroup.legs:
        return l10n.muscleGroupLegs;
      case MuscleGroup.shoulders:
        return l10n.muscleGroupShoulders;
      case MuscleGroup.arms:
        return l10n.muscleGroupArms;
      case MuscleGroup.core:
        return l10n.muscleGroupCore;
    }
  }

  /// Resolves the localized display label for an [EquipmentType].
  static String resolveEquipment(
    EquipmentType equipment,
    AppLocalizations l10n,
  ) {
    switch (equipment) {
      case EquipmentType.barbell:
        return l10n.equipmentBarbell;
      case EquipmentType.dumbbell:
        return l10n.equipmentDumbbell;
      case EquipmentType.machine:
        return l10n.equipmentMachine;
      case EquipmentType.bodyweight:
        return l10n.equipmentBodyweight;
      case EquipmentType.cables:
        return l10n.equipmentCables;
    }
  }

  /// Resolves the localized display label for a [SetType].
  static String resolveSetType(SetType setType, AppLocalizations l10n) {
    switch (setType) {
      case SetType.normal:
        return l10n.setTypeNormal;
      case SetType.warmup:
        return l10n.setTypeWarmup;
      case SetType.dropset:
        return l10n.setTypeDropset;
      case SetType.failure:
        return l10n.setTypeFailure;
    }
  }
}

/// Convenience extensions for clean, idiomatic UI code.
extension ExerciseLocalizationExtension on Exercise {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveExerciseName(this, l10n);
  }

  String localizedMuscleGroup(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveMuscleGroup(muscleGroup, l10n);
  }

  String localizedEquipment(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveEquipment(equipment, l10n);
  }
}

extension MuscleGroupLocalizationExtension on MuscleGroup {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveMuscleGroup(this, l10n);
  }
}

extension EquipmentTypeLocalizationExtension on EquipmentType {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveEquipment(this, l10n);
  }
}

extension SetTypeLocalizationExtension on SetType {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExerciseTranslationHelper.resolveSetType(this, l10n);
  }
}
