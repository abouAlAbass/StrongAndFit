import 'package:equatable/equatable.dart';

/// Represents a single warm-up ramp set.
class WarmupStep extends Equatable {
  final int stepNumber;
  final double weightKg;
  final int reps;
  final int percentage;
  final String label;

  const WarmupStep({
    required this.stepNumber,
    required this.weightKg,
    required this.reps,
    required this.percentage,
    required this.label,
  });

  @override
  List<Object?> get props => [stepNumber, weightKg, reps, percentage, label];
}

/// Domain utility generating safe and progressive warm-up sets up to working weight.
class WarmupCalculator {
  WarmupCalculator._();

  /// Generates a structured warm-up progression based on target working weight.
  /// Weights are automatically rounded to the nearest standard plate increment (2.5 kg).
  static List<WarmupStep> generate({
    required double workingWeightKg,
    double barWeightKg = 20.0,
    double plateIncrement = 2.5,
  }) {
    if (workingWeightKg <= barWeightKg) {
      return [
        WarmupStep(
          stepNumber: 1,
          weightKg: barWeightKg,
          reps: 10,
          percentage: 100,
          label: 'Bar Warmup',
        ),
      ];
    }

    final steps = <WarmupStep>[];
    int stepNum = 1;

    // Step 1: Empty Bar (or ~40% for light weights)
    steps.add(
      WarmupStep(
        stepNumber: stepNum++,
        weightKg: barWeightKg,
        reps: 10,
        percentage: ((barWeightKg / workingWeightKg) * 100).round().clamp(
          10,
          100,
        ),
        label: 'Activation',
      ),
    );

    // Protocol based on working weight range
    final protocols = <(double pct, int reps, String label)>[
      (0.50, 5, 'Potentiation 50%'),
      (0.70, 3, 'Acclimation 70%'),
      (0.85, 1, 'Neural Primer 85%'),
    ];

    for (final (pct, reps, label) in protocols) {
      final rawWeight = workingWeightKg * pct;
      final roundedWeight = _roundToIncrement(rawWeight, plateIncrement);

      // Only add if it's strictly greater than previous step and significantly below working weight
      if (roundedWeight > steps.last.weightKg &&
          roundedWeight < workingWeightKg - 2.5) {
        steps.add(
          WarmupStep(
            stepNumber: stepNum++,
            weightKg: roundedWeight,
            reps: reps,
            percentage: (pct * 100).round(),
            label: label,
          ),
        );
      }
    }

    return steps;
  }

  static double _roundToIncrement(double value, double increment) {
    if (increment <= 0) return value;
    return (value / increment).round() * increment;
  }
}
