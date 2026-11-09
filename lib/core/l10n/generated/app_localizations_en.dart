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
  String get exercise_dips => 'Chest & Triceps Dips';

  @override
  String get exercise_cable_fly => 'Cable Chest Fly';

  @override
  String get exercise_chin_up => 'Chin-Up (Underhand)';

  @override
  String get exercise_dumbbell_row => 'One-Arm Dumbbell Row';

  @override
  String get exercise_seated_cable_row => 'Seated Cable Row';

  @override
  String get exercise_lunges => 'Dumbbell Walking Lunges';

  @override
  String get exercise_hip_thrust => 'Barbell Hip Thrust';

  @override
  String get exercise_bulgarian_split_squat => 'Bulgarian Split Squat';

  @override
  String get exercise_leg_extension => 'Seated Leg Extension';

  @override
  String get exercise_leg_curl => 'Hamstring Leg Curl';

  @override
  String get exercise_calf_raise => 'Standing Calf Raise';

  @override
  String get exercise_dumbbell_shoulder_press =>
      'Seated Dumbbell Shoulder Press';

  @override
  String get exercise_face_pull => 'Cable Face Pull';

  @override
  String get exercise_hammer_curl => 'Dumbbell Hammer Curl';

  @override
  String get exercise_incline_dumbbell_curl => 'Incline Dumbbell Curl';

  @override
  String get exercise_overhead_triceps_extension =>
      'Overhead Triceps Extension';

  @override
  String get exercise_skull_crusher => 'EZ-Bar Skull Crusher';

  @override
  String get exercise_cable_crunch => 'Kneeling Cable Crunch';

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

  @override
  String get oneHandedMode => '1-Hand Quick Input';

  @override
  String get validateSet => 'Complete Set';

  @override
  String get copyPrevious => 'Copy Previous';

  @override
  String get tapToCopy => 'Tap to copy';

  @override
  String get activeSet => 'Active Set';

  @override
  String get quickAdjustWeight => 'Weight';

  @override
  String get quickAdjustReps => 'Reps';

  @override
  String get exportSectionTitle => 'Backup & Data Export';

  @override
  String get exportCsvTitle => 'Export to CSV (Excel / Strong / Hevy)';

  @override
  String get exportCsvSubtitle =>
      'Complete spreadsheet compatible with Excel, Sheets and fitness apps';

  @override
  String get exportJsonTitle => 'Full JSON Backup';

  @override
  String get exportJsonSubtitle =>
      'Full archive of your athlete profile, sessions, exercises and sets';

  @override
  String get exportInProgress => 'Generating export file...';

  @override
  String get rateOfPerceivedExertion =>
      'Rate of Perceived Exertion (RPE / RIR)';

  @override
  String get rpeSubtitle =>
      'RPE 10 = Muscular Failure (0 RIR) • RPE 8 = 2 reps in reserve';

  @override
  String get repsInReserve => 'RIR';

  @override
  String get clearRpe => 'Clear RPE';

  @override
  String get superset => 'Superset';

  @override
  String get createSuperset => 'Create Superset';

  @override
  String get unlinkSuperset => 'Unlink from Superset';

  @override
  String get supersetLinked => 'Superset linked!';

  @override
  String get supersetUnlinked => 'Exercise unlinked from superset';

  @override
  String get supersetLabel => 'SUPERSET';

  @override
  String get linkWithNext => 'Link with next exercise';

  @override
  String get weightProgression => 'Body Weight Tracking';

  @override
  String get weightProgressionSubtitle =>
      'Weight progression curve & weigh-in logs';

  @override
  String get logWeight => 'New Weigh-in';

  @override
  String get weightHistory => 'Weigh-in History';

  @override
  String get noWeightHistory =>
      'No weigh-ins recorded yet. Log your weight to track your body composition trend.';

  @override
  String get weightDelta => 'Change';

  @override
  String get sinceStart => 'since start';

  @override
  String get weighInDate => 'Weigh-in Date';

  @override
  String get weighInNotes => 'Notes (optional)';

  @override
  String get weighInSaved => 'Weigh-in successfully logged';

  @override
  String get deleteWeighIn => 'Delete Weigh-in';

  @override
  String get deleteWeighInConfirm =>
      'Are you sure you want to delete this weigh-in?';

  @override
  String get onboardingPreferencesTitle => 'Language & Appearance';

  @override
  String get onboardingPreferencesSubtitle =>
      'Select your preferences or keep your device system settings';

  @override
  String get chooseLanguage => 'Application Language';

  @override
  String get chooseTheme => 'Visual Theme';

  @override
  String get systemDefault => 'System (Default)';

  @override
  String get importJsonTitle => 'Import JSON Backup';

  @override
  String get importJsonSubtitle =>
      'Restore your profile, custom exercises, and workout history from a JSON file';

  @override
  String get importConfirmTitle => 'Import JSON Backup?';

  @override
  String get importConfirmMessage =>
      'Choose how to restore the backup data. Merging keeps your current workouts and adds the backup records. Overwriting replaces all current workout history.';

  @override
  String get importMergeOption => 'Merge with existing data (Recommended)';

  @override
  String get importOverwriteOption => 'Overwrite existing history';

  @override
  String get importFilePathHint =>
      'Select a local backup or paste JSON content below';

  @override
  String get importPasteJsonLabel => 'JSON Backup Content or File Path';

  @override
  String get importStartButton => 'Restore Backup';

  @override
  String importSuccessMessage(int sessions, int sets) {
    return 'Backup restored successfully ($sessions workouts, $sets sets)!';
  }

  @override
  String importErrorMessage(String error) {
    return 'Import failed: $error';
  }

  @override
  String get aiCoachCardTitle => 'AI Coach — Google Gemini (BYOK)';

  @override
  String get aiCoachCardSubtitle => 'Progressive overload, RPE & PR analysis';

  @override
  String get aiCoachCardDescription =>
      'Use your own free Google AI Studio API key to get personalized strength coaching insights without any paid subscription.';

  @override
  String get aiCoachConfigureButton => 'Configure my Gemini key';

  @override
  String get aiKeySheetTitle => 'AI Coach — Google Gemini Key';

  @override
  String get aiKeySheetSubtitle => 'Bring Your Own Key (BYOK) — 100% Free';

  @override
  String get aiKeyPrivacyCallout =>
      'Your key stays on your device. It is encrypted in Android Keystore / iOS Keychain and is never sent to any third-party server.';

  @override
  String get aiKeyStepsTitle => 'How to get your free key in 30 seconds:';

  @override
  String get aiKeyStep1 => 'Sign in with your Google account on AI Studio.';

  @override
  String get aiKeyStep2 =>
      'Click \"Create API Key\" (no payment method required).';

  @override
  String get aiKeyStep3 => 'Copy the key and paste it into the field below.';

  @override
  String get aiKeyGetFreeKeyButton => 'Get a free key on Google AI Studio';

  @override
  String get aiKeyInputLabel => 'Google Gemini API Key (e.g. AIzaSy...)';

  @override
  String get aiKeyInputHint => 'Paste your key here';

  @override
  String get aiKeyPasteTooltip => 'Paste';

  @override
  String get aiKeyValidateAndSaveButton => 'Validate and Save';

  @override
  String get aiKeyDeleteSavedButton => 'Delete saved key';

  @override
  String get aiKeyDeleteConfirmTitle => 'Delete Gemini key?';

  @override
  String get aiKeyDeleteConfirmMessage =>
      'Automatic workout and personal record AI analysis features will be disabled.';

  @override
  String get aiKeyEmptyError => 'Please enter or paste your Gemini API key.';

  @override
  String get aiKeySavedSuccess => 'Gemini key validated and securely saved!';

  @override
  String get aiKeyDeletedSuccess => 'Key deleted.';

  @override
  String get networkConnectionError =>
      'Unable to connect to Google Gemini servers. Please check your Internet connection.';

  @override
  String get aiAnalysisDialogTitle => 'Strength Coach Analysis';

  @override
  String get aiAnalysisProgressiveOverloadTitle =>
      'Progressive Overload & Intensity';

  @override
  String get aiAnalysisRecoveryRpeTitle => 'Recovery & Fatigue (RPE/RIR)';

  @override
  String get aiAnalysisHighlightsTitle => 'Strengths & Achievements';

  @override
  String get aiAnalysisPlateausRisksTitle => 'Watchpoints & Plateau Risks';

  @override
  String get aiAnalysisNextCycleTitle => 'Next Cycle Recommendations';

  @override
  String get aiAnalysisCloseButton => 'Close';

  @override
  String get aiAnalyzeSessionButton => 'Analyze with Gemini AI Coach';

  @override
  String get aiAnalyzingProgress => 'AI Coach analysis in progress...';

  @override
  String get finishWorkoutTitle => 'Complete Workout Session';

  @override
  String get finishWorkoutNotesHint =>
      'How did the session feel? (RPE, energy, form notes...)';
}
