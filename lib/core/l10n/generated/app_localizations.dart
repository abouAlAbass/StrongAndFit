import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Strong Track'**
  String get appTitle;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @rpe.
  ///
  /// In en, this message translates to:
  /// **'RPE'**
  String get rpe;

  /// No description provided for @restTimer.
  ///
  /// In en, this message translates to:
  /// **'Rest Timer'**
  String get restTimer;

  /// No description provided for @addExercise.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get addExercise;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout'**
  String get finishWorkout;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get startWorkout;

  /// No description provided for @cancelWorkout.
  ///
  /// In en, this message translates to:
  /// **'Cancel Workout'**
  String get cancelWorkout;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @workoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Workout History'**
  String get workoutHistory;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @searchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises...'**
  String get searchExercises;

  /// No description provided for @customExercise.
  ///
  /// In en, this message translates to:
  /// **'Custom Exercise'**
  String get customExercise;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @emptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No workouts logged yet. Start crushing your goals today!'**
  String get emptyHistory;

  /// No description provided for @emptyTemplates.
  ///
  /// In en, this message translates to:
  /// **'No workout templates found.'**
  String get emptyTemplates;

  /// No description provided for @discardDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard Workout?'**
  String get discardDialogTitle;

  /// No description provided for @discardDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to discard this workout? All progress in this session will be lost.'**
  String get discardDialogMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @navWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get navExercises;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @quickStart.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get quickStart;

  /// No description provided for @quickStartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start an empty workout anytime'**
  String get quickStartSubtitle;

  /// No description provided for @routines.
  ///
  /// In en, this message translates to:
  /// **'Curated Routines'**
  String get routines;

  /// No description provided for @startRoutine.
  ///
  /// In en, this message translates to:
  /// **'Start Routine'**
  String get startRoutine;

  /// No description provided for @templateExercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String templateExercisesCount(int count);

  /// No description provided for @ongoingWorkout.
  ///
  /// In en, this message translates to:
  /// **'Active Workout in Progress'**
  String get ongoingWorkout;

  /// No description provided for @resumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'Resume Workout'**
  String get resumeWorkout;

  /// No description provided for @templateFullBodyTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Body Split'**
  String get templateFullBodyTitle;

  /// No description provided for @templateFullBodyDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced compound full body routine. Ideal for 3-4 days per week.'**
  String get templateFullBodyDesc;

  /// No description provided for @templateUpperTitle.
  ///
  /// In en, this message translates to:
  /// **'Upper Body Power'**
  String get templateUpperTitle;

  /// No description provided for @templateUpperDesc.
  ///
  /// In en, this message translates to:
  /// **'Chest, back, shoulders & arms strength & hypertrophy builder.'**
  String get templateUpperDesc;

  /// No description provided for @templateLowerTitle.
  ///
  /// In en, this message translates to:
  /// **'Lower Body & Core'**
  String get templateLowerTitle;

  /// No description provided for @templateLowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Heavy quads, hamstrings, glutes, and anterior core engine.'**
  String get templateLowerDesc;

  /// No description provided for @templatePushTitle.
  ///
  /// In en, this message translates to:
  /// **'Push Day (Chest, Shoulders, Triceps)'**
  String get templatePushTitle;

  /// No description provided for @templatePushDesc.
  ///
  /// In en, this message translates to:
  /// **'High intensity pressing angles and lateral shoulder development.'**
  String get templatePushDesc;

  /// No description provided for @templatePullTitle.
  ///
  /// In en, this message translates to:
  /// **'Pull Day (Deadlift, Back, Biceps)'**
  String get templatePullTitle;

  /// No description provided for @templatePullDesc.
  ///
  /// In en, this message translates to:
  /// **'Heavy posterior chain builder with deadlifts, rows and curls.'**
  String get templatePullDesc;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Athlete Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile & Metrics'**
  String get editProfile;

  /// No description provided for @athleteName.
  ///
  /// In en, this message translates to:
  /// **'Athlete Name'**
  String get athleteName;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Training Goal'**
  String get weeklyGoal;

  /// No description provided for @workoutsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count} workouts / week'**
  String workoutsPerWeek(int count);

  /// No description provided for @experienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Experience Level'**
  String get experienceLevel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced (Pro)'**
  String get advanced;

  /// No description provided for @consistencyScore.
  ///
  /// In en, this message translates to:
  /// **'Weekly Consistency'**
  String get consistencyScore;

  /// No description provided for @workoutsDoneThisWeek.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {goal} workouts completed'**
  String workoutsDoneThisWeek(int completed, int goal);

  /// No description provided for @bmiLabel.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index (BMI)'**
  String get bmiLabel;

  /// No description provided for @totalWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts Completed'**
  String get totalWorkouts;

  /// No description provided for @totalVolumeLifted.
  ///
  /// In en, this message translates to:
  /// **'Total Volume (kg)'**
  String get totalVolumeLifted;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings & Language'**
  String get appSettings;

  /// No description provided for @languageSelection.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get languageSelection;

  /// No description provided for @readyToLift.
  ///
  /// In en, this message translates to:
  /// **'READY TO LIFT!'**
  String get readyToLift;

  /// No description provided for @resting.
  ///
  /// In en, this message translates to:
  /// **'RESTING'**
  String get resting;

  /// No description provided for @timerPaused.
  ///
  /// In en, this message translates to:
  /// **'PAUSED'**
  String get timerPaused;

  /// No description provided for @quickPresets.
  ///
  /// In en, this message translates to:
  /// **'Quick Presets'**
  String get quickPresets;

  /// No description provided for @autoStartOnSet.
  ///
  /// In en, this message translates to:
  /// **'Auto-start on completed set'**
  String get autoStartOnSet;

  /// No description provided for @tapToAdjust.
  ///
  /// In en, this message translates to:
  /// **'Tap to adjust chrono'**
  String get tapToAdjust;

  /// No description provided for @tapToStartNextSet.
  ///
  /// In en, this message translates to:
  /// **'Tap to start next set'**
  String get tapToStartNextSet;

  /// No description provided for @timerReady.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get timerReady;

  /// No description provided for @restBetweenSets.
  ///
  /// In en, this message translates to:
  /// **'Between sets'**
  String get restBetweenSets;

  /// No description provided for @restBetweenExercises.
  ///
  /// In en, this message translates to:
  /// **'Between exercises'**
  String get restBetweenExercises;

  /// No description provided for @nextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next: {name}'**
  String nextExercise(String name);

  /// No description provided for @restNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest is over'**
  String get restNotificationTitle;

  /// No description provided for @restNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your next set 💪'**
  String get restNotificationBody;

  /// No description provided for @restNotificationsSetting.
  ///
  /// In en, this message translates to:
  /// **'Lock-screen alert'**
  String get restNotificationsSetting;

  /// No description provided for @restVibrationSetting.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get restVibrationSetting;

  /// No description provided for @exerciseRest.
  ///
  /// In en, this message translates to:
  /// **'Rest for this exercise'**
  String get exerciseRest;

  /// No description provided for @useDefaultRest.
  ///
  /// In en, this message translates to:
  /// **'Default ({duration})'**
  String useDefaultRest(String duration);

  /// No description provided for @restSettings.
  ///
  /// In en, this message translates to:
  /// **'Rest settings'**
  String get restSettings;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @restGuide.
  ///
  /// In en, this message translates to:
  /// **'Strength 2–5 min · Hypertrophy 60–90 s · Endurance 30–60 s'**
  String get restGuide;

  /// No description provided for @plateCalculator.
  ///
  /// In en, this message translates to:
  /// **'Plate Calculator'**
  String get plateCalculator;

  /// No description provided for @warmupCalculator.
  ///
  /// In en, this message translates to:
  /// **'Warm-up Sets'**
  String get warmupCalculator;

  /// No description provided for @personalRecord.
  ///
  /// In en, this message translates to:
  /// **'PR'**
  String get personalRecord;

  /// No description provided for @newPrAchieved.
  ///
  /// In en, this message translates to:
  /// **'New Personal Record! 🏆'**
  String get newPrAchieved;

  /// No description provided for @estimatedOneRepMax.
  ///
  /// In en, this message translates to:
  /// **'Est. 1RM'**
  String get estimatedOneRepMax;

  /// No description provided for @barWeight.
  ///
  /// In en, this message translates to:
  /// **'Bar Weight'**
  String get barWeight;

  /// No description provided for @perSide.
  ///
  /// In en, this message translates to:
  /// **'Per side'**
  String get perSide;

  /// No description provided for @muscleGroupChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleGroupChest;

  /// No description provided for @muscleGroupBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleGroupBack;

  /// No description provided for @muscleGroupLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get muscleGroupLegs;

  /// No description provided for @muscleGroupShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleGroupShoulders;

  /// No description provided for @muscleGroupArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get muscleGroupArms;

  /// No description provided for @muscleGroupCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleGroupCore;

  /// No description provided for @equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// No description provided for @equipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get equipmentDumbbell;

  /// No description provided for @equipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// No description provided for @equipmentBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipmentBodyweight;

  /// No description provided for @equipmentCables.
  ///
  /// In en, this message translates to:
  /// **'Cables'**
  String get equipmentCables;

  /// No description provided for @setTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get setTypeNormal;

  /// No description provided for @setTypeWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warmup'**
  String get setTypeWarmup;

  /// No description provided for @setTypeDropset.
  ///
  /// In en, this message translates to:
  /// **'Drop Set'**
  String get setTypeDropset;

  /// No description provided for @setTypeFailure.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get setTypeFailure;

  /// No description provided for @exercise_bench_press.
  ///
  /// In en, this message translates to:
  /// **'Barbell Bench Press'**
  String get exercise_bench_press;

  /// No description provided for @exercise_incline_dumbbell_press.
  ///
  /// In en, this message translates to:
  /// **'Incline Dumbbell Press'**
  String get exercise_incline_dumbbell_press;

  /// No description provided for @exercise_push_up.
  ///
  /// In en, this message translates to:
  /// **'Push-Up'**
  String get exercise_push_up;

  /// No description provided for @exercise_deadlift.
  ///
  /// In en, this message translates to:
  /// **'Barbell Deadlift'**
  String get exercise_deadlift;

  /// No description provided for @exercise_barbell_row.
  ///
  /// In en, this message translates to:
  /// **'Bent-Over Barbell Row'**
  String get exercise_barbell_row;

  /// No description provided for @exercise_pull_up.
  ///
  /// In en, this message translates to:
  /// **'Pull-Up'**
  String get exercise_pull_up;

  /// No description provided for @exercise_lat_pulldown.
  ///
  /// In en, this message translates to:
  /// **'Lat Pulldown'**
  String get exercise_lat_pulldown;

  /// No description provided for @exercise_squat.
  ///
  /// In en, this message translates to:
  /// **'Barbell Back Squat'**
  String get exercise_squat;

  /// No description provided for @exercise_leg_press.
  ///
  /// In en, this message translates to:
  /// **'Leg Press'**
  String get exercise_leg_press;

  /// No description provided for @exercise_romanian_deadlift.
  ///
  /// In en, this message translates to:
  /// **'Romanian Deadlift'**
  String get exercise_romanian_deadlift;

  /// No description provided for @exercise_overhead_press.
  ///
  /// In en, this message translates to:
  /// **'Overhead Press (OHP)'**
  String get exercise_overhead_press;

  /// No description provided for @exercise_lateral_raise.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Lateral Raise'**
  String get exercise_lateral_raise;

  /// No description provided for @exercise_barbell_curl.
  ///
  /// In en, this message translates to:
  /// **'Barbell Bicep Curl'**
  String get exercise_barbell_curl;

  /// No description provided for @exercise_triceps_pushdown.
  ///
  /// In en, this message translates to:
  /// **'Triceps Cable Pushdown'**
  String get exercise_triceps_pushdown;

  /// No description provided for @exercise_plank.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get exercise_plank;

  /// No description provided for @exercise_hanging_leg_raise.
  ///
  /// In en, this message translates to:
  /// **'Hanging Leg Raise'**
  String get exercise_hanging_leg_raise;

  /// No description provided for @exerciseGuide.
  ///
  /// In en, this message translates to:
  /// **'Exercise Guide'**
  String get exerciseGuide;

  /// No description provided for @techniqueGuide.
  ///
  /// In en, this message translates to:
  /// **'Technique & Coaching'**
  String get techniqueGuide;

  /// No description provided for @setupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Setup & Position'**
  String get setupInstructions;

  /// No description provided for @executionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Execution & Form'**
  String get executionInstructions;

  /// No description provided for @breathingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get breathingInstructions;

  /// No description provided for @commonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get commonMistakes;

  /// No description provided for @coachTip.
  ///
  /// In en, this message translates to:
  /// **'Coach Tip'**
  String get coachTip;

  /// No description provided for @targetMuscles.
  ///
  /// In en, this message translates to:
  /// **'Target Muscles'**
  String get targetMuscles;

  /// No description provided for @primaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryMuscles;

  /// No description provided for @secondaryMuscles.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondaryMuscles;

  /// No description provided for @tempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tempo;

  /// No description provided for @hypertrophyRange.
  ///
  /// In en, this message translates to:
  /// **'Hypertrophy Range'**
  String get hypertrophyRange;

  /// No description provided for @strengthRange.
  ///
  /// In en, this message translates to:
  /// **'Strength Range'**
  String get strengthRange;

  /// No description provided for @viewGuide.
  ///
  /// In en, this message translates to:
  /// **'View Guide'**
  String get viewGuide;

  /// No description provided for @findIdealProgram.
  ///
  /// In en, this message translates to:
  /// **'Find My Ideal Routine'**
  String get findIdealProgram;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer 3 quick questions to get the perfect routine tailored to your goals'**
  String get onboardingSubtitle;

  /// No description provided for @stepTrainingGoal.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Your Primary Goal'**
  String get stepTrainingGoal;

  /// No description provided for @goalHypertrophy.
  ///
  /// In en, this message translates to:
  /// **'Muscle Building (Hypertrophy)'**
  String get goalHypertrophy;

  /// No description provided for @goalHypertrophyDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on volume and progressive overload for muscle growth.'**
  String get goalHypertrophyDesc;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength (Powerlifting / Compound)'**
  String get goalStrength;

  /// No description provided for @goalStrengthDesc.
  ///
  /// In en, this message translates to:
  /// **'Heavy compound lifts focused on neuromuscular adaptation.'**
  String get goalStrengthDesc;

  /// No description provided for @goalFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness & Well-being'**
  String get goalFitness;

  /// No description provided for @goalFitnessDesc.
  ///
  /// In en, this message translates to:
  /// **'Balanced routine for overall athleticism, stamina, and posture.'**
  String get goalFitnessDesc;

  /// No description provided for @stepWeeklyAvailability.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Days Per Week'**
  String get stepWeeklyAvailability;

  /// No description provided for @daysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{days} days per week'**
  String daysPerWeek(int days);

  /// No description provided for @stepExperienceLevel.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Experience Level'**
  String get stepExperienceLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner (< 1 year)'**
  String get levelBeginner;

  /// No description provided for @levelBeginnerDesc.
  ///
  /// In en, this message translates to:
  /// **'Mastering movement mechanics, consistent habit building.'**
  String get levelBeginnerDesc;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate (1 - 3 years)'**
  String get levelIntermediate;

  /// No description provided for @levelIntermediateDesc.
  ///
  /// In en, this message translates to:
  /// **'Familiar with barbell compound lifts, ready for periodization.'**
  String get levelIntermediateDesc;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced / Pro (3+ years)'**
  String get levelAdvanced;

  /// No description provided for @levelAdvancedDesc.
  ///
  /// In en, this message translates to:
  /// **'High volume tolerance, customized splits and RPE pacing.'**
  String get levelAdvancedDesc;

  /// No description provided for @recommendedRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Recommended Routine'**
  String get recommendedRoutineTitle;

  /// No description provided for @startRecommendedRoutine.
  ///
  /// In en, this message translates to:
  /// **'Start This Routine'**
  String get startRecommendedRoutine;

  /// No description provided for @routineMatchedReason.
  ///
  /// In en, this message translates to:
  /// **'Based on your {days}-day availability and {goal} focus, this plan provides optimal recovery and frequency.'**
  String routineMatchedReason(int days, String goal);

  /// No description provided for @applyAndSave.
  ///
  /// In en, this message translates to:
  /// **'Apply & Save to Profile'**
  String get applyAndSave;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated!'**
  String get onboardingDone;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @createRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create Routine'**
  String get createRoutine;

  /// No description provided for @routineName.
  ///
  /// In en, this message translates to:
  /// **'Routine Name'**
  String get routineName;

  /// No description provided for @saveAsRoutine.
  ///
  /// In en, this message translates to:
  /// **'Save as Routine'**
  String get saveAsRoutine;

  /// No description provided for @routineSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to your routines!'**
  String get routineSaved;

  /// No description provided for @repeatWorkout.
  ///
  /// In en, this message translates to:
  /// **'Repeat Workout'**
  String get repeatWorkout;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Summary'**
  String get sessionDetails;

  /// No description provided for @muscleDistribution.
  ///
  /// In en, this message translates to:
  /// **'Muscle Group Distribution'**
  String get muscleDistribution;

  /// No description provided for @progressionHistory.
  ///
  /// In en, this message translates to:
  /// **'1RM Progression History'**
  String get progressionHistory;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile & Data'**
  String get deleteProfile;

  /// No description provided for @deleteProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Permanently erase your athlete profile, workout logs, and biometrics.'**
  String get deleteProfileDesc;

  /// No description provided for @deleteProfileConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile?'**
  String get deleteProfileConfirmTitle;

  /// No description provided for @deleteProfileConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All your workout sessions, sets, volume history, and biometrics will be permanently deleted.'**
  String get deleteProfileConfirmMessage;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get deletePermanently;

  /// No description provided for @profileDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile and athlete data successfully reset'**
  String get profileDeletedSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
