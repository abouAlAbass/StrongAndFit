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

  /// No description provided for @exercise_dips.
  ///
  /// In en, this message translates to:
  /// **'Chest & Triceps Dips'**
  String get exercise_dips;

  /// No description provided for @exercise_cable_fly.
  ///
  /// In en, this message translates to:
  /// **'Cable Chest Fly'**
  String get exercise_cable_fly;

  /// No description provided for @exercise_chin_up.
  ///
  /// In en, this message translates to:
  /// **'Chin-Up (Underhand)'**
  String get exercise_chin_up;

  /// No description provided for @exercise_dumbbell_row.
  ///
  /// In en, this message translates to:
  /// **'One-Arm Dumbbell Row'**
  String get exercise_dumbbell_row;

  /// No description provided for @exercise_seated_cable_row.
  ///
  /// In en, this message translates to:
  /// **'Seated Cable Row'**
  String get exercise_seated_cable_row;

  /// No description provided for @exercise_lunges.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Walking Lunges'**
  String get exercise_lunges;

  /// No description provided for @exercise_hip_thrust.
  ///
  /// In en, this message translates to:
  /// **'Barbell Hip Thrust'**
  String get exercise_hip_thrust;

  /// No description provided for @exercise_bulgarian_split_squat.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian Split Squat'**
  String get exercise_bulgarian_split_squat;

  /// No description provided for @exercise_leg_extension.
  ///
  /// In en, this message translates to:
  /// **'Seated Leg Extension'**
  String get exercise_leg_extension;

  /// No description provided for @exercise_leg_curl.
  ///
  /// In en, this message translates to:
  /// **'Hamstring Leg Curl'**
  String get exercise_leg_curl;

  /// No description provided for @exercise_calf_raise.
  ///
  /// In en, this message translates to:
  /// **'Standing Calf Raise'**
  String get exercise_calf_raise;

  /// No description provided for @exercise_dumbbell_shoulder_press.
  ///
  /// In en, this message translates to:
  /// **'Seated Dumbbell Shoulder Press'**
  String get exercise_dumbbell_shoulder_press;

  /// No description provided for @exercise_face_pull.
  ///
  /// In en, this message translates to:
  /// **'Cable Face Pull'**
  String get exercise_face_pull;

  /// No description provided for @exercise_hammer_curl.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Hammer Curl'**
  String get exercise_hammer_curl;

  /// No description provided for @exercise_incline_dumbbell_curl.
  ///
  /// In en, this message translates to:
  /// **'Incline Dumbbell Curl'**
  String get exercise_incline_dumbbell_curl;

  /// No description provided for @exercise_overhead_triceps_extension.
  ///
  /// In en, this message translates to:
  /// **'Overhead Triceps Extension'**
  String get exercise_overhead_triceps_extension;

  /// No description provided for @exercise_skull_crusher.
  ///
  /// In en, this message translates to:
  /// **'EZ-Bar Skull Crusher'**
  String get exercise_skull_crusher;

  /// No description provided for @exercise_cable_crunch.
  ///
  /// In en, this message translates to:
  /// **'Kneeling Cable Crunch'**
  String get exercise_cable_crunch;

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

  /// No description provided for @customWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Workout'**
  String get customWorkoutTitle;

  /// No description provided for @customWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start an empty workout and log your exercises'**
  String get customWorkoutSubtitle;

  /// No description provided for @findIdealWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Find your ideal workout'**
  String get findIdealWorkoutTitle;

  /// No description provided for @findIdealWorkoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Answer 3 quick questions to discover your optimal routine'**
  String get findIdealWorkoutSubtitle;

  /// No description provided for @yourProgram.
  ///
  /// In en, this message translates to:
  /// **'Your Program'**
  String get yourProgram;

  /// No description provided for @readyTemplates.
  ///
  /// In en, this message translates to:
  /// **'Ready Templates & Routines'**
  String get readyTemplates;

  /// No description provided for @oneHandedMode.
  ///
  /// In en, this message translates to:
  /// **'1-Hand Quick Input'**
  String get oneHandedMode;

  /// No description provided for @validateSet.
  ///
  /// In en, this message translates to:
  /// **'Complete Set'**
  String get validateSet;

  /// No description provided for @copyPrevious.
  ///
  /// In en, this message translates to:
  /// **'Copy Previous'**
  String get copyPrevious;

  /// No description provided for @tapToCopy.
  ///
  /// In en, this message translates to:
  /// **'Tap to copy'**
  String get tapToCopy;

  /// No description provided for @activeSet.
  ///
  /// In en, this message translates to:
  /// **'Active Set'**
  String get activeSet;

  /// No description provided for @quickAdjustWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get quickAdjustWeight;

  /// No description provided for @quickAdjustReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get quickAdjustReps;

  /// No description provided for @exportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Data Export'**
  String get exportSectionTitle;

  /// No description provided for @exportCsvTitle.
  ///
  /// In en, this message translates to:
  /// **'Export to CSV (Excel / Strong / Hevy)'**
  String get exportCsvTitle;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete spreadsheet compatible with Excel, Sheets and fitness apps'**
  String get exportCsvSubtitle;

  /// No description provided for @exportJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Full JSON Backup'**
  String get exportJsonTitle;

  /// No description provided for @exportJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full archive of your athlete profile, sessions, exercises and sets'**
  String get exportJsonSubtitle;

  /// No description provided for @exportInProgress.
  ///
  /// In en, this message translates to:
  /// **'Generating export file...'**
  String get exportInProgress;

  /// No description provided for @rateOfPerceivedExertion.
  ///
  /// In en, this message translates to:
  /// **'Rate of Perceived Exertion (RPE / RIR)'**
  String get rateOfPerceivedExertion;

  /// No description provided for @rpeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'RPE 10 = Muscular Failure (0 RIR) • RPE 8 = 2 reps in reserve'**
  String get rpeSubtitle;

  /// No description provided for @repsInReserve.
  ///
  /// In en, this message translates to:
  /// **'RIR'**
  String get repsInReserve;

  /// No description provided for @clearRpe.
  ///
  /// In en, this message translates to:
  /// **'Clear RPE'**
  String get clearRpe;

  /// No description provided for @superset.
  ///
  /// In en, this message translates to:
  /// **'Superset'**
  String get superset;

  /// No description provided for @createSuperset.
  ///
  /// In en, this message translates to:
  /// **'Create Superset'**
  String get createSuperset;

  /// No description provided for @unlinkSuperset.
  ///
  /// In en, this message translates to:
  /// **'Unlink from Superset'**
  String get unlinkSuperset;

  /// No description provided for @supersetLinked.
  ///
  /// In en, this message translates to:
  /// **'Superset linked!'**
  String get supersetLinked;

  /// No description provided for @supersetUnlinked.
  ///
  /// In en, this message translates to:
  /// **'Exercise unlinked from superset'**
  String get supersetUnlinked;

  /// No description provided for @supersetLabel.
  ///
  /// In en, this message translates to:
  /// **'SUPERSET'**
  String get supersetLabel;

  /// No description provided for @linkWithNext.
  ///
  /// In en, this message translates to:
  /// **'Link with next exercise'**
  String get linkWithNext;

  /// No description provided for @weightProgression.
  ///
  /// In en, this message translates to:
  /// **'Body Weight Tracking'**
  String get weightProgression;

  /// No description provided for @weightProgressionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weight progression curve & weigh-in logs'**
  String get weightProgressionSubtitle;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'New Weigh-in'**
  String get logWeight;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in History'**
  String get weightHistory;

  /// No description provided for @noWeightHistory.
  ///
  /// In en, this message translates to:
  /// **'No weigh-ins recorded yet. Log your weight to track your body composition trend.'**
  String get noWeightHistory;

  /// No description provided for @weightDelta.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get weightDelta;

  /// No description provided for @sinceStart.
  ///
  /// In en, this message translates to:
  /// **'since start'**
  String get sinceStart;

  /// No description provided for @weighInDate.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in Date'**
  String get weighInDate;

  /// No description provided for @weighInNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get weighInNotes;

  /// No description provided for @weighInSaved.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in successfully logged'**
  String get weighInSaved;

  /// No description provided for @deleteWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Delete Weigh-in'**
  String get deleteWeighIn;

  /// No description provided for @deleteWeighInConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this weigh-in?'**
  String get deleteWeighInConfirm;

  /// No description provided for @onboardingPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & Appearance'**
  String get onboardingPreferencesTitle;

  /// No description provided for @onboardingPreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferences or keep your device system settings'**
  String get onboardingPreferencesSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get chooseLanguage;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Visual Theme'**
  String get chooseTheme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System (Default)'**
  String get systemDefault;

  /// No description provided for @importJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Import JSON Backup'**
  String get importJsonTitle;

  /// No description provided for @importJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your profile, custom exercises, and workout history from a JSON file'**
  String get importJsonSubtitle;

  /// No description provided for @importConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Import JSON Backup?'**
  String get importConfirmTitle;

  /// No description provided for @importConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose how to restore the backup data. Merging keeps your current workouts and adds the backup records. Overwriting replaces all current workout history.'**
  String get importConfirmMessage;

  /// No description provided for @importMergeOption.
  ///
  /// In en, this message translates to:
  /// **'Merge with existing data (Recommended)'**
  String get importMergeOption;

  /// No description provided for @importOverwriteOption.
  ///
  /// In en, this message translates to:
  /// **'Overwrite existing history'**
  String get importOverwriteOption;

  /// No description provided for @importFilePathHint.
  ///
  /// In en, this message translates to:
  /// **'Select a local backup or paste JSON content below'**
  String get importFilePathHint;

  /// No description provided for @importPasteJsonLabel.
  ///
  /// In en, this message translates to:
  /// **'JSON Backup Content or File Path'**
  String get importPasteJsonLabel;

  /// No description provided for @importStartButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get importStartButton;

  /// No description provided for @importSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully ({sessions} workouts, {sets} sets)!'**
  String importSuccessMessage(int sessions, int sets);

  /// No description provided for @importErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importErrorMessage(String error);

  /// No description provided for @aiCoachCardTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Coach — Google Gemini (BYOK)'**
  String get aiCoachCardTitle;

  /// No description provided for @aiCoachCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Progressive overload, RPE & PR analysis'**
  String get aiCoachCardSubtitle;

  /// No description provided for @aiCoachCardDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your own free Google AI Studio API key to get personalized strength coaching insights without any paid subscription.'**
  String get aiCoachCardDescription;

  /// No description provided for @aiCoachConfigureButton.
  ///
  /// In en, this message translates to:
  /// **'Configure my Gemini key'**
  String get aiCoachConfigureButton;

  /// No description provided for @aiKeySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Coach — Google Gemini Key'**
  String get aiKeySheetTitle;

  /// No description provided for @aiKeySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring Your Own Key (BYOK) — 100% Free'**
  String get aiKeySheetSubtitle;

  /// No description provided for @aiKeyPrivacyCallout.
  ///
  /// In en, this message translates to:
  /// **'Your key stays on your device. It is encrypted in Android Keystore / iOS Keychain and is never sent to any third-party server.'**
  String get aiKeyPrivacyCallout;

  /// No description provided for @aiKeyStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to get your free key in 30 seconds:'**
  String get aiKeyStepsTitle;

  /// No description provided for @aiKeyStep1.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account on AI Studio.'**
  String get aiKeyStep1;

  /// No description provided for @aiKeyStep2.
  ///
  /// In en, this message translates to:
  /// **'Click \"Create API Key\" (no payment method required).'**
  String get aiKeyStep2;

  /// No description provided for @aiKeyStep3.
  ///
  /// In en, this message translates to:
  /// **'Copy the key and paste it into the field below.'**
  String get aiKeyStep3;

  /// No description provided for @aiKeyGetFreeKeyButton.
  ///
  /// In en, this message translates to:
  /// **'Get a free key on Google AI Studio'**
  String get aiKeyGetFreeKeyButton;

  /// No description provided for @aiKeyInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Google Gemini API Key (e.g. AIzaSy...)'**
  String get aiKeyInputLabel;

  /// No description provided for @aiKeyInputHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your key here'**
  String get aiKeyInputHint;

  /// No description provided for @aiKeyPasteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get aiKeyPasteTooltip;

  /// No description provided for @aiKeyValidateAndSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Validate and Save'**
  String get aiKeyValidateAndSaveButton;

  /// No description provided for @aiKeyDeleteSavedButton.
  ///
  /// In en, this message translates to:
  /// **'Delete saved key'**
  String get aiKeyDeleteSavedButton;

  /// No description provided for @aiKeyDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Gemini key?'**
  String get aiKeyDeleteConfirmTitle;

  /// No description provided for @aiKeyDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Automatic workout and personal record AI analysis features will be disabled.'**
  String get aiKeyDeleteConfirmMessage;

  /// No description provided for @aiKeyEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter or paste your Gemini API key.'**
  String get aiKeyEmptyError;

  /// No description provided for @aiKeySavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gemini key validated and securely saved!'**
  String get aiKeySavedSuccess;

  /// No description provided for @aiKeyDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Key deleted.'**
  String get aiKeyDeletedSuccess;

  /// No description provided for @networkConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to Google Gemini servers. Please check your Internet connection.'**
  String get networkConnectionError;

  /// No description provided for @aiTimeoutError.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out while communicating with Google Gemini. Please check your Internet connection.'**
  String get aiTimeoutError;

  /// No description provided for @aiAnalysisDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Strength Coach Analysis'**
  String get aiAnalysisDialogTitle;

  /// No description provided for @aiAnalysisProgressiveOverloadTitle.
  ///
  /// In en, this message translates to:
  /// **'Progressive Overload & Intensity'**
  String get aiAnalysisProgressiveOverloadTitle;

  /// No description provided for @aiAnalysisRecoveryRpeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery & Fatigue (RPE/RIR)'**
  String get aiAnalysisRecoveryRpeTitle;

  /// No description provided for @aiAnalysisHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Strengths & Achievements'**
  String get aiAnalysisHighlightsTitle;

  /// No description provided for @aiAnalysisPlateausRisksTitle.
  ///
  /// In en, this message translates to:
  /// **'Watchpoints & Plateau Risks'**
  String get aiAnalysisPlateausRisksTitle;

  /// No description provided for @aiAnalysisNextCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Next Cycle Recommendations'**
  String get aiAnalysisNextCycleTitle;

  /// No description provided for @aiAnalysisCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get aiAnalysisCloseButton;

  /// No description provided for @aiAnalyzeSessionButton.
  ///
  /// In en, this message translates to:
  /// **'Analyze with Gemini AI Coach'**
  String get aiAnalyzeSessionButton;

  /// No description provided for @aiAnalyzingProgress.
  ///
  /// In en, this message translates to:
  /// **'AI Coach analysis in progress...'**
  String get aiAnalyzingProgress;

  /// No description provided for @finishWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Workout Session'**
  String get finishWorkoutTitle;

  /// No description provided for @finishWorkoutNotesHint.
  ///
  /// In en, this message translates to:
  /// **'How did the session feel? (RPE, energy, form notes...)'**
  String get finishWorkoutNotesHint;

  /// No description provided for @lastWeighInDate.
  ///
  /// In en, this message translates to:
  /// **'Last weigh-in: {date}'**
  String lastWeighInDate(String date);

  /// No description provided for @singleWeighInHint.
  ///
  /// In en, this message translates to:
  /// **'1 weigh-in recorded ({weight} kg). Add a 2nd weigh-in to plot your progress curve!'**
  String singleWeighInHint(String weight);

  /// No description provided for @finishWorkoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish workout?'**
  String get finishWorkoutConfirmTitle;

  /// No description provided for @finishWorkoutIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You still have incomplete sets. Are you sure you want to finish the workout now?'**
  String get finishWorkoutIncompleteMessage;

  /// No description provided for @deleteExerciseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise?'**
  String get deleteExerciseConfirmTitle;

  /// No description provided for @deleteExerciseConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this exercise and all its sets from the session?'**
  String get deleteExerciseConfirmMessage;

  /// No description provided for @deleteSetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete set?'**
  String get deleteSetConfirmTitle;

  /// No description provided for @deleteSetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this set?'**
  String get deleteSetConfirmMessage;

  /// No description provided for @backupBeforeDelete.
  ///
  /// In en, this message translates to:
  /// **'Export backup before deleting'**
  String get backupBeforeDelete;

  /// No description provided for @weightAndHeight.
  ///
  /// In en, this message translates to:
  /// **'Weight & Height'**
  String get weightAndHeight;

  /// No description provided for @biometricsStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your volume and 1RM metrics'**
  String get biometricsStepSubtitle;

  /// No description provided for @athleteHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get athleteHeightCm;

  /// No description provided for @athleteWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get athleteWeightKg;

  /// No description provided for @continueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue Workout'**
  String get continueWorkout;

  /// No description provided for @beginnerRecommendationNote.
  ///
  /// In en, this message translates to:
  /// **'Although you selected {days} days, we recommend starting with 3 sessions per week to optimize neuromuscular recovery.'**
  String beginnerRecommendationNote(int days);

  /// No description provided for @langArabicDesc.
  ///
  /// In en, this message translates to:
  /// **'Arabic interface, exercises, and RTL support'**
  String get langArabicDesc;

  /// No description provided for @langEnglishDesc.
  ///
  /// In en, this message translates to:
  /// **'English interface, exercise guides, and analytics'**
  String get langEnglishDesc;

  /// No description provided for @langFrenchDesc.
  ///
  /// In en, this message translates to:
  /// **'French interface, exercises, and metrics'**
  String get langFrenchDesc;

  /// No description provided for @systemDefaultDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically follows your device\'s settings'**
  String get systemDefaultDesc;

  /// No description provided for @themeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follows your device\'s light/dark mode'**
  String get themeSystemDesc;

  /// No description provided for @themeDarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimal dark contrast for the gym'**
  String get themeDarkDesc;

  /// No description provided for @themeLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Clean and bright style'**
  String get themeLightDesc;

  /// No description provided for @daysPerWeek3Desc.
  ///
  /// In en, this message translates to:
  /// **'Full-body frequency 3x per week. Optimal for fast recovery and baseline strength.'**
  String get daysPerWeek3Desc;

  /// No description provided for @daysPerWeek4Desc.
  ///
  /// In en, this message translates to:
  /// **'Upper / Lower 4-day split. The scientific gold standard for balanced volume.'**
  String get daysPerWeek4Desc;

  /// No description provided for @daysPerWeek5Desc.
  ///
  /// In en, this message translates to:
  /// **'Push / Pull / Legs 5-day cycle. Maximum specialization and hypertrophy stimulus.'**
  String get daysPerWeek5Desc;

  /// No description provided for @aiAnalyzeProgramButton.
  ///
  /// In en, this message translates to:
  /// **'AI Program Audit'**
  String get aiAnalyzeProgramButton;

  /// No description provided for @aiProgramAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Program Analysis'**
  String get aiProgramAuditTitle;

  /// No description provided for @aiProgramAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalized evaluation based on your recovery, weak points, and specific goals.'**
  String get aiProgramAuditSubtitle;

  /// No description provided for @aiFatigueQuestion.
  ///
  /// In en, this message translates to:
  /// **'Current Energy & Recovery'**
  String get aiFatigueQuestion;

  /// No description provided for @aiFatigueFresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh & Rested'**
  String get aiFatigueFresh;

  /// No description provided for @aiFatigueModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Fatigue'**
  String get aiFatigueModerate;

  /// No description provided for @aiFatigueExhausted.
  ///
  /// In en, this message translates to:
  /// **'Exhausted / Poor Recovery'**
  String get aiFatigueExhausted;

  /// No description provided for @aiWeakPointQuestion.
  ///
  /// In en, this message translates to:
  /// **'Priority Target Muscle Group'**
  String get aiWeakPointQuestion;

  /// No description provided for @aiFocusBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get aiFocusBalanced;

  /// No description provided for @aiFocusChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get aiFocusChest;

  /// No description provided for @aiFocusBack.
  ///
  /// In en, this message translates to:
  /// **'Back & Posterior Chain'**
  String get aiFocusBack;

  /// No description provided for @aiFocusLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs (Quads / Hamstrings / Glutes)'**
  String get aiFocusLegs;

  /// No description provided for @aiFocusShouldersArms.
  ///
  /// In en, this message translates to:
  /// **'Shoulders & Arms'**
  String get aiFocusShouldersArms;

  /// No description provided for @aiTimeConstraintQuestion.
  ///
  /// In en, this message translates to:
  /// **'Target Duration per Workout'**
  String get aiTimeConstraintQuestion;

  /// No description provided for @aiPainQuestion.
  ///
  /// In en, this message translates to:
  /// **'Joint Discomfort / Injuries'**
  String get aiPainQuestion;

  /// No description provided for @aiPainNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get aiPainNone;

  /// No description provided for @aiPainShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get aiPainShoulders;

  /// No description provided for @aiPainLowerBack.
  ///
  /// In en, this message translates to:
  /// **'Lower Back'**
  String get aiPainLowerBack;

  /// No description provided for @aiPainKnees.
  ///
  /// In en, this message translates to:
  /// **'Knees'**
  String get aiPainKnees;

  /// No description provided for @aiPainElbowsWrists.
  ///
  /// In en, this message translates to:
  /// **'Elbows / Wrists'**
  String get aiPainElbowsWrists;

  /// No description provided for @aiFreeTextLabel.
  ///
  /// In en, this message translates to:
  /// **'Specific Notes & Requests (Free text)'**
  String get aiFreeTextLabel;

  /// No description provided for @aiFreeTextHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Focus on lateral delts, prefer dumbbells for incline press, avoid heavy squats...'**
  String get aiFreeTextHint;

  /// No description provided for @aiLaunchProgramAudit.
  ///
  /// In en, this message translates to:
  /// **'Analyze Program with Gemini'**
  String get aiLaunchProgramAudit;

  /// No description provided for @aiProgramScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Program Match Score'**
  String get aiProgramScoreLabel;

  /// No description provided for @aiProgramModificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customized Adjustments'**
  String get aiProgramModificationsTitle;

  /// No description provided for @aiProgramInjuryTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Biomechanics & Injury Prevention'**
  String get aiProgramInjuryTipsTitle;

  /// No description provided for @aiProgramPeriodizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Periodization & Progression Strategy'**
  String get aiProgramPeriodizationTitle;

  /// No description provided for @aiAnalyzeHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'AI Progression Audit'**
  String get aiAnalyzeHistoryButton;

  /// No description provided for @aiHistoryAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Progression Audit'**
  String get aiHistoryAuditTitle;

  /// No description provided for @aiHistoryAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep longitudinal analysis of volume, progressive overload, and recovery across your workouts.'**
  String get aiHistoryAuditSubtitle;

  /// No description provided for @aiHistoryScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Consistency & Overload Score'**
  String get aiHistoryScoreLabel;

  /// No description provided for @aiHistoryVolumeTrajectory.
  ///
  /// In en, this message translates to:
  /// **'Volume Trajectory'**
  String get aiHistoryVolumeTrajectory;

  /// No description provided for @aiHistoryOverloadAssessment.
  ///
  /// In en, this message translates to:
  /// **'Progressive Overload Quality'**
  String get aiHistoryOverloadAssessment;

  /// No description provided for @aiHistoryMuscleBalance.
  ///
  /// In en, this message translates to:
  /// **'Muscular Distribution Balance'**
  String get aiHistoryMuscleBalance;

  /// No description provided for @aiHistoryPlateausTitle.
  ///
  /// In en, this message translates to:
  /// **'Plateau Warnings & Fatigue Alerts'**
  String get aiHistoryPlateausTitle;

  /// No description provided for @aiHistoryMilestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Cycle Milestones'**
  String get aiHistoryMilestonesTitle;

  /// No description provided for @viewWorkoutHistory.
  ///
  /// In en, this message translates to:
  /// **'View Workout History'**
  String get viewWorkoutHistory;

  /// No description provided for @tabWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get tabWorkouts;

  /// No description provided for @tabAiReports.
  ///
  /// In en, this message translates to:
  /// **'AI Coaching Reports'**
  String get tabAiReports;

  /// No description provided for @noAiReportsYet.
  ///
  /// In en, this message translates to:
  /// **'No AI reports generated yet. Analyze your program or training history to get started!'**
  String get noAiReportsYet;

  /// No description provided for @configureApiKeyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Configure Gemini API key to unlock AI Coach insights.'**
  String get configureApiKeyPrompt;

  /// No description provided for @aiGenerateRoutine.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get aiGenerateRoutine;

  /// No description provided for @aiRoutineGeneratorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Routine Generator'**
  String get aiRoutineGeneratorTitle;

  /// No description provided for @aiRoutineGeneratorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe your goals, equipment, and constraints — Gemini designs the optimal routine directly in your app.'**
  String get aiRoutineGeneratorSubtitle;

  /// No description provided for @aiPromptInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Goals & Constraints (Free prompt)'**
  String get aiPromptInputLabel;

  /// No description provided for @aiPromptInputHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45-min chest & triceps split, dumbbell-only, avoid heavy axial loading...'**
  String get aiPromptInputHint;

  /// No description provided for @aiGenerateRoutineButton.
  ///
  /// In en, this message translates to:
  /// **'Design Routine with Gemini'**
  String get aiGenerateRoutineButton;

  /// No description provided for @aiSaveRoutineToDatabase.
  ///
  /// In en, this message translates to:
  /// **'Save to My Routines'**
  String get aiSaveRoutineToDatabase;

  /// No description provided for @aiStartRoutineImmediately.
  ///
  /// In en, this message translates to:
  /// **'Start Workout Now'**
  String get aiStartRoutineImmediately;

  /// No description provided for @aiRoutineCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'AI Routine successfully saved to your routines!'**
  String get aiRoutineCreatedSuccess;

  /// No description provided for @aiRoutineGeneratorCaption.
  ///
  /// In en, this message translates to:
  /// **'Automatic design & SQLite insertion'**
  String get aiRoutineGeneratorCaption;

  /// No description provided for @aiRoutineGeneratingHint.
  ///
  /// In en, this message translates to:
  /// **'Gemini is structuring your routine with optimal exercises and sets...'**
  String get aiRoutineGeneratingHint;

  /// No description provided for @aiFocusTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Focus / Split'**
  String get aiFocusTargetTitle;

  /// No description provided for @aiFocusPush.
  ///
  /// In en, this message translates to:
  /// **'Push (Chest / Shoulders / Triceps)'**
  String get aiFocusPush;

  /// No description provided for @aiFocusPull.
  ///
  /// In en, this message translates to:
  /// **'Pull (Back / Biceps)'**
  String get aiFocusPull;

  /// No description provided for @aiFocusFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body (Complete)'**
  String get aiFocusFullBody;

  /// No description provided for @aiFocusUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper Body'**
  String get aiFocusUpperBody;

  /// No description provided for @aiGeneratedBadge.
  ///
  /// In en, this message translates to:
  /// **'Generated by Gemini AI'**
  String get aiGeneratedBadge;

  /// No description provided for @aiRegenerateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get aiRegenerateTooltip;

  /// No description provided for @aiPlannedExercises.
  ///
  /// In en, this message translates to:
  /// **'Planned Exercises ({count})'**
  String aiPlannedExercises(int count);

  /// No description provided for @aiTotalSetsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} total sets'**
  String aiTotalSetsCount(int count);

  /// No description provided for @aiProgramAnalyzingHint.
  ///
  /// In en, this message translates to:
  /// **'Gemini is analyzing volume, biomechanics, and your custom requests...'**
  String get aiProgramAnalyzingHint;

  /// No description provided for @aiCreateOptimizedVariant.
  ///
  /// In en, this message translates to:
  /// **'Create an AI-optimized routine variant'**
  String get aiCreateOptimizedVariant;

  /// No description provided for @aiModifyCriteriaAndReanalyze.
  ///
  /// In en, this message translates to:
  /// **'Modify criteria & Re-analyze'**
  String get aiModifyCriteriaAndReanalyze;

  /// No description provided for @aiSessionsAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'{count} workouts analyzed'**
  String aiSessionsAnalyzed(int count);

  /// No description provided for @aiHistoryAnalyzingHint.
  ///
  /// In en, this message translates to:
  /// **'Gemini is evaluating your progressive overload, volume, and consistency...'**
  String get aiHistoryAnalyzingHint;

  /// No description provided for @aiRefreshReport.
  ///
  /// In en, this message translates to:
  /// **'Refresh AI Report'**
  String get aiRefreshReport;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
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
