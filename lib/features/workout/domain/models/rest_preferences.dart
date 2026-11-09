import 'package:equatable/equatable.dart';

/// Pure domain model of the athlete's rest chronometer preferences.
class RestPreferences extends Equatable {
  final int betweenSetsSeconds;
  final int betweenExercisesSeconds;
  final bool autoStart;
  final bool notificationsEnabled;
  final bool vibrationEnabled;

  const RestPreferences({
    this.betweenSetsSeconds = 90,
    this.betweenExercisesSeconds = 150,
    this.autoStart = true,
    this.notificationsEnabled = true,
    this.vibrationEnabled = true,
  });

  RestPreferences copyWith({
    int? betweenSetsSeconds,
    int? betweenExercisesSeconds,
    bool? autoStart,
    bool? notificationsEnabled,
    bool? vibrationEnabled,
  }) {
    return RestPreferences(
      betweenSetsSeconds: betweenSetsSeconds ?? this.betweenSetsSeconds,
      betweenExercisesSeconds:
          betweenExercisesSeconds ?? this.betweenExercisesSeconds,
      autoStart: autoStart ?? this.autoStart,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    betweenSetsSeconds,
    betweenExercisesSeconds,
    autoStart,
    notificationsEnabled,
    vibrationEnabled,
  ];
}
