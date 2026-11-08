// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Strong Track';

  @override
  String get sets => 'Sets';

  @override
  String get set => 'Set';

  @override
  String get reps => 'Reps';

  @override
  String get weight => 'Weight';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get height => 'Height';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get rpe => 'RPE';

  @override
  String get restTimer => 'Rest Timer';

  @override
  String get addExercise => 'Add Exercise';

  @override
  String get finishWorkout => 'Finish Workout';

  @override
  String get startWorkout => 'Start Workout';

  @override
  String get cancelWorkout => 'Cancel Workout';

  @override
  String get history => 'History';

  @override
  String get workoutHistory => 'Workout History';

  @override
  String get templates => 'Templates';

  @override
  String get settings => 'Settings';

  @override
  String get exercises => 'Exercises';

  @override
  String get searchExercises => 'Search exercises...';

  @override
  String get customExercise => 'Custom Exercise';

  @override
  String get previous => 'Previous';

  @override
  String get notes => 'Notes';

  @override
  String get duration => 'Duration';

  @override
  String get completed => 'Completed';

  @override
  String get emptyHistory =>
      'No workouts logged yet. Start crushing your goals today!';

  @override
  String get emptyTemplates => 'No workout templates found.';

  @override
  String get discardDialogTitle => 'Discard Workout?';

  @override
  String get discardDialogMessage =>
      'Are you sure you want to discard this workout? All progress in this session will be lost.';

  @override
  String get discard => 'Discard';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navHistory => 'History';

  @override
  String get navExercises => 'Exercises';

  @override
  String get navProfile => 'Profile';

  @override
  String get quickStart => 'Quick Start';

  @override
  String get quickStartSubtitle => 'Start an empty workout anytime';

  @override
  String get routines => 'Curated Routines';

  @override
  String get startRoutine => 'Start Routine';

  @override
  String templateExercisesCount(int count) {
    return '$count exercises';
  }

  @override
  String get ongoingWorkout => 'Active Workout in Progress';

  @override
  String get resumeWorkout => 'Resume Workout';

  @override
  String get templateFullBodyTitle => 'Full Body Split';

  @override
  String get templateFullBodyDesc =>
      'Balanced compound full body routine. Ideal for 3-4 days per week.';

  @override
  String get templateUpperTitle => 'Upper Body Power';

  @override
  String get templateUpperDesc =>
      'Chest, back, shoulders & arms strength & hypertrophy builder.';

  @override
  String get templateLowerTitle => 'Lower Body & Core';

  @override
  String get templateLowerDesc =>
      'Heavy quads, hamstrings, glutes, and anterior core engine.';

  @override
  String get templatePushTitle => 'Push Day (Chest, Shoulders, Triceps)';

  @override
  String get templatePushDesc =>
      'High intensity pressing angles and lateral shoulder development.';

  @override
  String get templatePullTitle => 'Pull Day (Deadlift, Back, Biceps)';

  @override
  String get templatePullDesc =>
      'Heavy posterior chain builder with deadlifts, rows and curls.';

  @override
  String get profile => 'Athlete Profile';

  @override
  String get editProfile => 'Edit Profile & Metrics';

  @override
  String get athleteName => 'Athlete Name';

  @override
  String get weeklyGoal => 'Weekly Training Goal';

  @override
  String workoutsPerWeek(int count) {
    return '$count workouts / week';
  }

  @override
  String get experienceLevel => 'Experience Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced (Pro)';

  @override
  String get consistencyScore => 'Weekly Consistency';

  @override
  String workoutsDoneThisWeek(int completed, int goal) {
    return '$completed of $goal workouts completed';
  }

  @override
  String get bmiLabel => 'Body Mass Index (BMI)';

  @override
  String get totalWorkouts => 'Workouts Completed';

  @override
  String get totalVolumeLifted => 'Total Volume (kg)';

  @override
  String get appSettings => 'Settings & Language';

  @override
  String get languageSelection => 'App Language';

  @override
  String get readyToLift => 'READY TO LIFT!';

  @override
  String get resting => 'RESTING';

  @override
  String get timerPaused => 'PAUSED';

  @override
  String get quickPresets => 'Quick Presets';

  @override
  String get autoStartOnSet => 'Auto-start on completed set';

  @override
  String get tapToAdjust => 'Tap to adjust chrono';

  @override
  String get tapToStartNextSet => 'Tap to start next set';

  @override
  String get timerReady => 'READY';

  @override
  String get restBetweenSets => 'Between sets';

  @override
  String get restBetweenExercises => 'Between exercises';

  @override
  String nextExercise(String name) {
    return 'Next: $name';
  }

  @override
  String get restNotificationTitle => 'Rest is over';

  @override
  String get restNotificationBody => 'Time for your next set 💪';

  @override
  String get restNotificationsSetting => 'Lock-screen alert';

  @override
  String get restVibrationSetting => 'Vibration';

  @override
  String get exerciseRest => 'Rest for this exercise';

  @override
  String useDefaultRest(String duration) {
    return 'Default ($duration)';
  }

  @override
  String get restSettings => 'Rest settings';

  @override
  String get skip => 'Skip';

  @override
  String get restGuide =>
      'Strength 2–5 min · Hypertrophy 60–90 s · Endurance 30–60 s';

  @override
  String get plateCalculator => 'Plate Calculator';

  @override
  String get warmupCalculator => 'Warm-up Sets';

  @override
  String get personalRecord => 'PR';

  @override
  String get newPrAchieved => 'New Personal Record! 🏆';

  @override
  String get estimatedOneRepMax => 'Est. 1RM';

  @override
  String get barWeight => 'Bar Weight';

  @override
  String get perSide => 'Per side';

  @override
  String get muscleGroupChest => 'Chest';

  @override
  String get muscleGroupBack => 'Back';

  @override
  String get muscleGroupLegs => 'Legs';

  @override
  String get muscleGroupShoulders => 'Shoulders';

  @override
  String get muscleGroupArms => 'Arms';

  @override
  String get muscleGroupCore => 'Core';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentDumbbell => 'Dumbbell';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentBodyweight => 'Bodyweight';

  @override
  String get equipmentCables => 'Cables';

  @override
  String get setTypeNormal => 'Normal';

  @override
  String get setTypeWarmup => 'Warmup';

  @override
  String get setTypeDropset => 'Drop Set';

  @override
  String get setTypeFailure => 'Failure';

  @override
  String get exercise_bench_press => 'Barbell Bench Press';

  @override
  String get exercise_incline_dumbbell_press => 'Incline Dumbbell Press';

  @override
  String get exercise_push_up => 'Push-Up';

  @override
  String get exercise_deadlift => 'Barbell Deadlift';

  @override
  String get exercise_barbell_row => 'Bent-Over Barbell Row';

  @override
  String get exercise_pull_up => 'Pull-Up';

  @override
  String get exercise_lat_pulldown => 'Lat Pulldown';

  @override
  String get exercise_squat => 'Barbell Back Squat';

  @override
  String get exercise_leg_press => 'Leg Press';

  @override
  String get exercise_romanian_deadlift => 'Romanian Deadlift';

  @override
  String get exercise_overhead_press => 'Overhead Press (OHP)';

  @override
  String get exercise_lateral_raise => 'Dumbbell Lateral Raise';

  @override
  String get exercise_barbell_curl => 'Barbell Bicep Curl';

  @override
  String get exercise_triceps_pushdown => 'Triceps Cable Pushdown';

  @override
  String get exercise_plank => 'Plank';

  @override
  String get exercise_hanging_leg_raise => 'Hanging Leg Raise';

  @override
  String get exerciseGuide => 'Exercise Guide';

  @override
  String get techniqueGuide => 'Technique & Coaching';

  @override
  String get setupInstructions => 'Setup & Position';

  @override
  String get executionInstructions => 'Execution & Form';

  @override
  String get breathingInstructions => 'Breathing';

  @override
  String get commonMistakes => 'Common Mistakes';

  @override
  String get coachTip => 'Coach Tip';

  @override
  String get targetMuscles => 'Target Muscles';

  @override
  String get primaryMuscles => 'Primary';

  @override
  String get secondaryMuscles => 'Secondary';

  @override
  String get tempo => 'Tempo';

  @override
  String get hypertrophyRange => 'Hypertrophy Range';

  @override
  String get strengthRange => 'Strength Range';

  @override
  String get viewGuide => 'View Guide';

  @override
  String get findIdealProgram => 'Find My Ideal Routine';

  @override
  String get onboardingSubtitle =>
      'Answer 3 quick questions to get the perfect routine tailored to your goals';

  @override
  String get stepTrainingGoal => 'Step 1: Your Primary Goal';

  @override
  String get goalHypertrophy => 'Muscle Building (Hypertrophy)';

  @override
  String get goalHypertrophyDesc =>
      'Focus on volume and progressive overload for muscle growth.';

  @override
  String get goalStrength => 'Strength (Powerlifting / Compound)';

  @override
  String get goalStrengthDesc =>
      'Heavy compound lifts focused on neuromuscular adaptation.';

  @override
  String get goalFitness => 'Fitness & Well-being';

  @override
  String get goalFitnessDesc =>
      'Balanced routine for overall athleticism, stamina, and posture.';

  @override
  String get stepWeeklyAvailability => 'Step 2: Days Per Week';

  @override
  String daysPerWeek(int days) {
    return '$days days per week';
  }

  @override
  String get stepExperienceLevel => 'Step 3: Experience Level';

  @override
  String get levelBeginner => 'Beginner (< 1 year)';

  @override
  String get levelBeginnerDesc =>
      'Mastering movement mechanics, consistent habit building.';

  @override
  String get levelIntermediate => 'Intermediate (1 - 3 years)';

  @override
  String get levelIntermediateDesc =>
      'Familiar with barbell compound lifts, ready for periodization.';

  @override
  String get levelAdvanced => 'Advanced / Pro (3+ years)';

  @override
  String get levelAdvancedDesc =>
      'High volume tolerance, customized splits and RPE pacing.';

  @override
  String get recommendedRoutineTitle => 'Your Recommended Routine';

  @override
  String get startRecommendedRoutine => 'Start This Routine';

  @override
  String routineMatchedReason(int days, String goal) {
    return 'Based on your $days-day availability and $goal focus, this plan provides optimal recovery and frequency.';
  }

  @override
  String get applyAndSave => 'Apply & Save to Profile';

  @override
  String get onboardingDone => 'Profile Updated!';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get createRoutine => 'Create Routine';

  @override
  String get routineName => 'Routine Name';

  @override
  String get saveAsRoutine => 'Save as Routine';

  @override
  String get routineSaved => 'Saved to your routines!';

  @override
  String get repeatWorkout => 'Repeat Workout';

  @override
  String get sessionDetails => 'Session Summary';

  @override
  String get muscleDistribution => 'Muscle Group Distribution';

  @override
  String get progressionHistory => '1RM Progression History';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeSystem => 'System';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteProfile => 'Delete Profile & Data';

  @override
  String get deleteProfileDesc =>
      'Permanently erase your athlete profile, workout logs, and biometrics.';

  @override
  String get deleteProfileConfirmTitle => 'Delete Profile?';

  @override
  String get deleteProfileConfirmMessage =>
      'This action is irreversible. All your workout sessions, sets, volume history, and biometrics will be permanently deleted.';

  @override
  String get deletePermanently => 'Delete Permanently';

  @override
  String get profileDeletedSuccess =>
      'Profile and athlete data successfully reset';

  @override
  String get customWorkoutTitle => 'Custom Workout';

  @override
  String get customWorkoutSubtitle =>
      'Start an empty workout and log your exercises';

  @override
  String get findIdealWorkoutTitle => 'Find your ideal workout';

  @override
  String get findIdealWorkoutSubtitle =>
      'Answer 3 quick questions to discover your optimal routine';

  @override
  String get yourProgram => 'Your Program';

  @override
  String get readyTemplates => 'Ready Templates & Routines';
}
