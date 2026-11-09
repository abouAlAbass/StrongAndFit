import 'package:equatable/equatable.dart';
import '../services/one_rep_max_calculator.dart';

/// Categories of Personal Records an athlete can break.
enum PrType { maxWeight, maxOneRepMax, maxVolume }

/// Historical record bests achieved for a specific exercise.
class ExercisePersonalRecords extends Equatable {
  final double maxWeight;
  final double maxOneRepMax;
  final double maxVolume;

  const ExercisePersonalRecords({
    this.maxWeight = 0.0,
    this.maxOneRepMax = 0.0,
    this.maxVolume = 0.0,
  });

  bool get isEmpty => maxWeight <= 0 && maxOneRepMax <= 0 && maxVolume <= 0;

  /// Evaluates whether a candidate set constitutes a new personal record compared to prior sessions.
  List<PrType> evaluateSet({required double weightKg, required int reps}) {
    if (weightKg <= 0 || reps <= 0) return const [];

    final badges = <PrType>[];
    final current1RM = OneRepMaxCalculator.epley(weight: weightKg, reps: reps);
    final currentVolume = weightKg * reps;

    // Must exceed existing non-zero record, or establish the first record if none exists.
    if (maxWeight > 0 && weightKg > maxWeight) {
      badges.add(PrType.maxWeight);
    }
    if (maxOneRepMax > 0 && current1RM > maxOneRepMax) {
      badges.add(PrType.maxOneRepMax);
    }
    if (maxVolume > 0 && currentVolume > maxVolume) {
      badges.add(PrType.maxVolume);
    }

    return badges;
  }

  @override
  List<Object?> get props => [maxWeight, maxOneRepMax, maxVolume];
}
