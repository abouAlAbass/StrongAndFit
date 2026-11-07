import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Specification for a weight plate denomination.
class PlateSpec extends Equatable {
  final double weightKg;
  final Color color;
  final String label;

  const PlateSpec({
    required this.weightKg,
    required this.color,
    required this.label,
  });

  @override
  List<Object?> get props => [weightKg, color, label];
}

/// Result of plate loading calculation.
class PlateLoadResult extends Equatable {
  final double targetWeight;
  final double barWeight;
  final double weightPerSide;
  final List<PlateSpec> platesPerSide;
  final double actualTotalWeight;
  final double remainderWeight;

  const PlateLoadResult({
    required this.targetWeight,
    required this.barWeight,
    required this.weightPerSide,
    required this.platesPerSide,
    required this.actualTotalWeight,
    required this.remainderWeight,
  });

  bool get isExact => remainderWeight.abs() < 0.001;

  @override
  List<Object?> get props => [
        targetWeight,
        barWeight,
        weightPerSide,
        platesPerSide,
        actualTotalWeight,
        remainderWeight,
      ];
}

/// Domain utility that calculates optimal plate loading for Olympic and standard barbells.
class PlateCalculator {
  PlateCalculator._();

  static const List<PlateSpec> standardOlympicPlates = [
    PlateSpec(weightKg: 25.0, color: Color(0xFFE53935), label: '25'), // Red
    PlateSpec(weightKg: 20.0, color: Color(0xFF1E88E5), label: '20'), // Blue
    PlateSpec(weightKg: 15.0, color: Color(0xFFFDD835), label: '15'), // Yellow
    PlateSpec(weightKg: 10.0, color: Color(0xFF43A047), label: '10'), // Green
    PlateSpec(weightKg: 5.0, color: Color(0xFFECEFF1), label: '5'),   // White
    PlateSpec(weightKg: 2.5, color: Color(0xFF37474F), label: '2.5'), // Black
    PlateSpec(weightKg: 1.25, color: Color(0xFF90A4AE), label: '1.25'), // Silver
  ];

  /// Calculates plates needed per side of the barbell using a greedy algorithm.
  static PlateLoadResult calculate({
    required double targetWeight,
    double barWeight = 20.0,
    List<PlateSpec>? availablePlates,
  }) {
    final plates = List<PlateSpec>.from(availablePlates ?? standardOlympicPlates)
      ..sort((a, b) => b.weightKg.compareTo(a.weightKg));

    if (targetWeight <= barWeight) {
      return PlateLoadResult(
        targetWeight: targetWeight,
        barWeight: barWeight,
        weightPerSide: 0.0,
        platesPerSide: const [],
        actualTotalWeight: barWeight,
        remainderWeight: (targetWeight - barWeight).clamp(double.negativeInfinity, 0.0),
      );
    }

    final neededPerSide = (targetWeight - barWeight) / 2.0;
    var remaining = neededPerSide;
    final resultPlates = <PlateSpec>[];

    for (final plate in plates) {
      while (remaining >= plate.weightKg - 0.001) {
        resultPlates.add(plate);
        remaining -= plate.weightKg;
      }
    }

    final loadedPerSide = neededPerSide - remaining;
    final actualTotal = barWeight + (loadedPerSide * 2.0);

    return PlateLoadResult(
      targetWeight: targetWeight,
      barWeight: barWeight,
      weightPerSide: neededPerSide,
      platesPerSide: resultPlates,
      actualTotalWeight: actualTotal,
      remainderWeight: targetWeight - actualTotal,
    );
  }
}
