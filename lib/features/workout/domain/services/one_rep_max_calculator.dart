/// Standard formulas for One Rep Max (1RM) estimation and percentage tables.
class OneRepMaxCalculator {
  OneRepMaxCalculator._();

  /// Epley Formula: 1RM = weight * (1 + reps / 30) for reps > 1.
  /// For 1 rep, 1RM equals the weight lifted.
  static double epley({required double weight, required int reps}) {
    if (weight <= 0 || reps <= 0) return 0.0;
    if (reps == 1) return weight;
    return weight * (1.0 + (reps / 30.0));
  }

  /// Brzycki Formula: 1RM = weight * (36 / (37 - reps)) for reps < 37.
  static double brzycki({required double weight, required int reps}) {
    if (weight <= 0 || reps <= 0) return 0.0;
    if (reps == 1) return weight;
    if (reps >= 37) return epley(weight: weight, reps: reps);
    return weight * (36.0 / (37.0 - reps));
  }

  /// Calculates estimated 1RM rounded to 1 decimal place.
  static double calculate({required double weight, required int reps}) {
    return double.parse(epley(weight: weight, reps: reps).toStringAsFixed(1));
  }

  /// Calculates the training weight for a given target percentage of 1RM
  /// (e.g. 75% for hypertrophy, 85% for strength).
  static double weightForPercentage({
    required double oneRepMax,
    required double percentage,
    double step = 2.5,
  }) {
    if (oneRepMax <= 0 || percentage <= 0) return 0.0;
    final raw = oneRepMax * (percentage / 100.0);
    // Round to the nearest plate step (default 2.5 kg)
    return (raw / step).round() * step;
  }
}
