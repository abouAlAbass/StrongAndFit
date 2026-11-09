// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سترونغ تراك';

  @override
  String get sets => 'الجلسات';

  @override
  String get set => 'الجلسة';

  @override
  String get reps => 'التكرارات';

  @override
  String get weight => 'الوزن';

  @override
  String get weightKg => 'الوزن (كغ)';

  @override
  String get height => 'الطول';

  @override
  String get heightCm => 'الطول (سم)';

  @override
  String get rpe => 'RPE';

  @override
  String get restTimer => 'مؤقت الراحة';

  @override
  String get addExercise => 'إضافة تمرين';

  @override
  String get finishWorkout => 'إنهاء التمرين';

  @override
  String get startWorkout => 'بدء التمرين';

  @override
  String get cancelWorkout => 'إلغاء التمرين';

  @override
  String get history => 'السجل';

  @override
  String get workoutHistory => 'سجل التمارين';

  @override
  String get templates => 'النماذج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get exercises => 'التمارين';

  @override
  String get searchExercises => 'بحث عن التمارين...';

  @override
  String get customExercise => 'تمرين مخصص';

  @override
  String get previous => 'السابق';

  @override
  String get notes => 'ملاحظات';

  @override
  String get duration => 'المدة';

  @override
  String get completed => 'مكتمل';

  @override
  String get emptyHistory =>
      'لا توجد تمارين مسجلة بعد. ابدأ بتحقيق أهدافك اليوم!';

  @override
  String get emptyTemplates => 'لا توجد نماذج تمارين محفوظة.';

  @override
  String get discardDialogTitle => 'تجاهل التمرين؟';

  @override
  String get discardDialogMessage =>
      'هل أنت متأكد من رغبتك في تجاهل هذا التمرين؟ سيتم فقدان جميع التغييرات.';

  @override
  String get discard => 'تجاهل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get navWorkout => 'التمارين';

  @override
  String get navHistory => 'السجل';

  @override
  String get navExercises => 'المكتبة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get quickStart => 'بدء سريع';

  @override
  String get quickStartSubtitle => 'بدء تمرين حر فارغ مباشرة';

  @override
  String get routines => 'البرامج والروتينات المقترحة';

  @override
  String get startRoutine => 'بدء هذا الروتين';

  @override
  String templateExercisesCount(int count) {
    return '$count تمارين';
  }

  @override
  String get ongoingWorkout => 'جلسة تمرين نشطة حالياً';

  @override
  String get resumeWorkout => 'متابعة التمرين';

  @override
  String get templateFullBodyTitle => 'روتين كامل الجسم (فول بودي)';

  @override
  String get templateFullBodyDesc =>
      'برنامج متكامل للجسم يركز على الحركات المركبة. مثالي لـ 3-4 أيام أسبوعياً.';

  @override
  String get templateUpperTitle => 'الجزء العلوي (أبر بودي)';

  @override
  String get templateUpperDesc =>
      'قوة وضخامة عضلية للصدر والظهر والأكتاف والذراعين.';

  @override
  String get templateLowerTitle => 'الجزء السفلي والجذع (لوور بودي)';

  @override
  String get templateLowerDesc =>
      'بناء الفخذين والأوتار والمؤخرة وعضلات البطن.';

  @override
  String get templatePushTitle => 'يوم الدفع (بوش - صدر، كتف، ترايسبس)';

  @override
  String get templatePushDesc =>
      'حركات دفع قوية لبناء الصدر والأكتاف والترايسبس.';

  @override
  String get templatePullTitle => 'يوم السحب (بول - ظهر، بايسبس، ديدليفت)';

  @override
  String get templatePullDesc =>
      'تمارين السحب والأوزان الحرة لتطوير عضلات الظهر والبايسبس.';

  @override
  String get profile => 'ملف الرياضي';

  @override
  String get editProfile => 'تعديل البيانات والقياسات';

  @override
  String get athleteName => 'اسم الرياضي';

  @override
  String get weeklyGoal => 'الهدف الأسبوعي';

  @override
  String workoutsPerWeek(int count) {
    return '$count تمارين / أسبوع';
  }

  @override
  String get experienceLevel => 'مستوى الخبرة';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم (محترف)';

  @override
  String get consistencyScore => 'الاستمرارية الأسبوعية';

  @override
  String workoutsDoneThisWeek(int completed, int goal) {
    return 'تم إنجاز $completed من $goal تمارين هذا الأسبوع';
  }

  @override
  String get bmiLabel => 'مؤشر كتلة الجسم (BMI)';

  @override
  String get totalWorkouts => 'إجمالي التمارين المنجزة';

  @override
  String get totalVolumeLifted => 'إجمالي الأوزان المرفوعة (كغ)';

  @override
  String get appSettings => 'الإعدادات واللغة';

  @override
  String get languageSelection => 'لغة التطبيق';

  @override
  String get readyToLift => 'جاهز للتمرين!';

  @override
  String get resting => 'فترة راحة';

  @override
  String get timerPaused => 'متوقف مؤقتاً';

  @override
  String get quickPresets => 'إعدادات سريعة';

  @override
  String get autoStartOnSet => 'بدء تلقائي بعد إكمال كل مجموعة';

  @override
  String get tapToAdjust => 'اضغط لتعديل المؤقت';

  @override
  String get tapToStartNextSet => 'اضغط لبدء المجموعة التالية';

  @override
  String get timerReady => 'جاهز';

  @override
  String get restBetweenSets => 'بين المجموعات';

  @override
  String get restBetweenExercises => 'بين التمارين';

  @override
  String nextExercise(String name) {
    return 'التالي: $name';
  }

  @override
  String get restNotificationTitle => 'انتهت فترة الراحة';

  @override
  String get restNotificationBody => 'حان وقت المجموعة التالية 💪';

  @override
  String get restNotificationsSetting => 'تنبيه على شاشة القفل';

  @override
  String get restVibrationSetting => 'الاهتزاز';

  @override
  String get exerciseRest => 'الراحة لهذا التمرين';

  @override
  String useDefaultRest(String duration) {
    return 'الافتراضي ($duration)';
  }

  @override
  String get restSettings => 'إعدادات الراحة';

  @override
  String get skip => 'تخطي';

  @override
  String get restGuide => 'القوة 2–5 د · الضخامة 60–90 ث · التحمل 30–60 ث';

  @override
  String get plateCalculator => 'حاسبة الأقراص والبار';

  @override
  String get warmupCalculator => 'مجموعات التسخين';

  @override
  String get personalRecord => 'رقم قياسي';

  @override
  String get newPrAchieved => 'رقم قياسي شخصي جديد! 🏆';

  @override
  String get estimatedOneRepMax => 'أقصى وزن تقديري (1RM)';

  @override
  String get barWeight => 'وزن البار';

  @override
  String get perSide => 'لكل جانب';

  @override
  String get muscleGroupChest => 'الصدر';

  @override
  String get muscleGroupBack => 'الظهر';

  @override
  String get muscleGroupLegs => 'الأرجل';

  @override
  String get muscleGroupShoulders => 'الأكتاف';

  @override
  String get muscleGroupArms => 'الذراعين';

  @override
  String get muscleGroupCore => 'البطن والجذع';

  @override
  String get equipmentBarbell => 'باربل';

  @override
  String get equipmentDumbbell => 'دامبلز';

  @override
  String get equipmentMachine => 'جهاز';

  @override
  String get equipmentBodyweight => 'وزن الجسم';

  @override
  String get equipmentCables => 'كابلات';

  @override
  String get setTypeNormal => 'عادي';

  @override
  String get setTypeWarmup => 'إحماء';

  @override
  String get setTypeDropset => 'دروب ست';

  @override
  String get setTypeFailure => 'حتى الفشل';

  @override
  String get exercise_bench_press => 'بنش برس مستوي بالبار';

  @override
  String get exercise_incline_dumbbell_press => 'بنش برس مائل بالدامبلز';

  @override
  String get exercise_push_up => 'تمرين الضغط';

  @override
  String get exercise_deadlift => 'ديدليفت بالبار';

  @override
  String get exercise_barbell_row => 'سحب بار منحني (بنت أوفر)';

  @override
  String get exercise_pull_up => 'تمرين العقلة';

  @override
  String get exercise_lat_pulldown => 'سحب عالي بالكيبل';

  @override
  String get exercise_squat => 'سكوات خلفي بالبار';

  @override
  String get exercise_leg_press => 'دفع الأرجل بالجهاز';

  @override
  String get exercise_romanian_deadlift => 'ديدليفت روماني';

  @override
  String get exercise_overhead_press => 'ضغط كتف عسكري بالبار';

  @override
  String get exercise_lateral_raise => 'رفرفة جانبية بالدامبلز';

  @override
  String get exercise_barbell_curl => 'كيرل بايسبس بالبار';

  @override
  String get exercise_triceps_pushdown => 'ضغط ترايسبس بالكيبل';

  @override
  String get exercise_plank => 'تمرين البلانك';

  @override
  String get exercise_hanging_leg_raise => 'رفع الأرجل معلقاً';

  @override
  String get exercise_dips => 'متوازي للصدر والترايسبس (Dips)';

  @override
  String get exercise_cable_fly => 'تفتيح صدر بالكيبل';

  @override
  String get exercise_chin_up => 'عقلة قبضة معكوسة (سوبينيشن)';

  @override
  String get exercise_dumbbell_row => 'سحب دامبل فردي للظهر (منشار)';

  @override
  String get exercise_seated_cable_row => 'سحب أرضي جالس بالكيبل';

  @override
  String get exercise_lunges => 'طعن المشي بالدامبلز (Lunges)';

  @override
  String get exercise_hip_thrust => 'دفع الحوض بالبار (Hip Thrust)';

  @override
  String get exercise_bulgarian_split_squat => 'سكوات بلغاري بالدامبلز';

  @override
  String get exercise_leg_extension => 'رفرفة أرجل أمامي بالجهاز';

  @override
  String get exercise_leg_curl => 'ثني الأرجل الخلفي بالجهاز';

  @override
  String get exercise_calf_raise => 'رفع السمانة واقفاً';

  @override
  String get exercise_dumbbell_shoulder_press => 'ضغط أكتاف جالس بالدامبلز';

  @override
  String get exercise_face_pull => 'سحب الحبل للوجه (Face Pull)';

  @override
  String get exercise_hammer_curl => 'كيرل مطرقة بالدامبلز (هامر)';

  @override
  String get exercise_incline_dumbbell_curl => 'كيرل بايسبس على مقعد مائل';

  @override
  String get exercise_overhead_triceps_extension => 'تمديد الترايسبس خلف الرأس';

  @override
  String get exercise_skull_crusher => 'كسارة الجمجمة بالبار (Skull Crusher)';

  @override
  String get exercise_cable_crunch => 'طحن البطن بالكيبل العالي';

  @override
  String get exerciseGuide => 'دليل التمرين';

  @override
  String get techniqueGuide => 'التقنية والتوجيه';

  @override
  String get setupInstructions => 'وضعية البداية والضبط';

  @override
  String get executionInstructions => 'التنفيذ والحركة';

  @override
  String get breathingInstructions => 'التنفس وضبط الضغط';

  @override
  String get commonMistakes => 'أخطاء شائعة يجب تجنبها';

  @override
  String get coachTip => 'نصيحة المدرب';

  @override
  String get targetMuscles => 'العضلات المستهدفة';

  @override
  String get primaryMuscles => 'الأساسية';

  @override
  String get secondaryMuscles => 'الثانوية';

  @override
  String get tempo => 'إيقاع الحركة';

  @override
  String get hypertrophyRange => 'نطاق التضخيم العضلي';

  @override
  String get strengthRange => 'نطاق زيادة القوة';

  @override
  String get viewGuide => 'عرض الدليل';

  @override
  String get findIdealProgram => 'اعثر على برنامجي المثالي';

  @override
  String get onboardingSubtitle =>
      'أجب عن 3 أسئلة سريعة لاقتراح البرنامج المناسب لمستواك وأهدافك';

  @override
  String get stepTrainingGoal => 'الخطوة 1: هدفك الرئيسي';

  @override
  String get goalHypertrophy => 'بناء العضلات (التضخيم)';

  @override
  String get goalHypertrophyDesc =>
      'التركيز على الحجم التدريبي والزيادة التدريجية لنمو العضلات.';

  @override
  String get goalStrength => 'زيادة القوة البدنية';

  @override
  String get goalStrengthDesc =>
      'أوزان ثقيلة على الحركات المركبة لتطوير القوة القصوى.';

  @override
  String get goalFitness => 'اللياقة العامة والصحة';

  @override
  String get goalFitnessDesc =>
      'برنامج متكامل للصحة، والتحمل، وقوة المفاصل وتحسين القوام.';

  @override
  String get stepWeeklyAvailability => 'الخطوة 2: عدد الأيام أسبوعياً';

  @override
  String daysPerWeek(int days) {
    return '$days أيام أسبوعياً';
  }

  @override
  String get stepExperienceLevel => 'الخطوة 3: مستوى الخبرة';

  @override
  String get levelBeginner => 'مبتدئ (أقل من سنة)';

  @override
  String get levelBeginnerDesc =>
      'إتقان المسار الحركي وبناء عادة التمرين والالتزام المنتظم.';

  @override
  String get levelIntermediate => 'متوسط (1 - 3 سنوات)';

  @override
  String get levelIntermediateDesc =>
      'إتقان الحركات الأساسية وجاهزية لزيادة الأحمال بشكل دوري.';

  @override
  String get levelAdvanced => 'متقدم / محترف (+3 سنوات)';

  @override
  String get levelAdvancedDesc =>
      'قدرة استيعاب عالية للحجم التدريبي وإدارة دقيقة للاستشفاء.';

  @override
  String get recommendedRoutineTitle => 'برنامجك التدريبي المقترح';

  @override
  String get startRecommendedRoutine => 'بدء هذا البرنامج';

  @override
  String routineMatchedReason(int days, String goal) {
    return 'بناءً على تفرغك لمدة $days أيام وهدف $goal، يوفر هذا البرنامج التردد والاستشفاء الأنسب لك.';
  }

  @override
  String get applyAndSave => 'حفظ في ملفي الشخصي';

  @override
  String get onboardingDone => 'تم تحديث الملف الشخصي بنجاح!';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get createRoutine => 'إنشاء روتين جديد';

  @override
  String get routineName => 'اسم الروتين';

  @override
  String get saveAsRoutine => 'حفظ كروتين';

  @override
  String get routineSaved => 'تم الحفظ في برامجك!';

  @override
  String get repeatWorkout => 'تكرار هذا التمرين';

  @override
  String get sessionDetails => 'ملخص التمرين';

  @override
  String get muscleDistribution => 'توزيع المجموعات العضلية';

  @override
  String get progressionHistory => 'تطور أقصى وزن (1RM)';

  @override
  String get themeMode => 'المظهر';

  @override
  String get themeDark => 'الوضع الداكن';

  @override
  String get themeLight => 'الوضع الفاتح';

  @override
  String get themeSystem => 'تلقائي (حسب النظام)';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get deleteProfile => 'حذف الملف الشخصي والبيانات';

  @override
  String get deleteProfileDesc =>
      'حذف ملفك الشخصي وسجلات التمارين والمقاييس الحيوية نهائياً.';

  @override
  String get deleteProfileConfirmTitle => 'حذف الملف الشخصي؟';

  @override
  String get deleteProfileConfirmMessage =>
      'هذا الإجراء لا يمكن التراجع عنه. سيتم حذف جميع جلسات التمارين والمجموعات وسجل الأوزان والبيانات الحيوية بشكل دائم.';

  @override
  String get deletePermanently => 'حذف نهائي';

  @override
  String get profileDeletedSuccess =>
      'تمت إعادة ضبط الملف الشخصي والبيانات بنجاح';

  @override
  String get customWorkoutTitle => 'تمرين مخصص';

  @override
  String get customWorkoutSubtitle =>
      'ابدأ جلسة حرة واختر التمارين التي تريدها';

  @override
  String get findIdealWorkoutTitle => 'اكتشف تمرينك المثالي';

  @override
  String get findIdealWorkoutSubtitle =>
      'أجب عن 3 أسئلة سريعة لاقتراح البرنامج الأنسب لك';

  @override
  String get yourProgram => 'برنامجك التدريبي';

  @override
  String get readyTemplates => 'نماذج الجلسات الجاهزة';

  @override
  String get oneHandedMode => 'إدخال سريع بيد واحدة';

  @override
  String get validateSet => 'تأكيد المجموعة';

  @override
  String get copyPrevious => 'نسخ السابق';

  @override
  String get tapToCopy => 'اضغط للنسخ';

  @override
  String get activeSet => 'المجموعة الحالية';

  @override
  String get quickAdjustWeight => 'الوزن';

  @override
  String get quickAdjustReps => 'التكرارات';

  @override
  String get exportSectionTitle => 'النسخ الاحتياطي وتصدير البيانات';

  @override
  String get exportCsvTitle => 'تصدير بتنسيق CSV (Excel / Strong / Hevy)';

  @override
  String get exportCsvSubtitle =>
      'ملف جدول بيانات متكامل متوافق مع Excel وتطبيقات التدريب';

  @override
  String get exportJsonTitle => 'نسخة احتياطية كاملة JSON';

  @override
  String get exportJsonSubtitle =>
      'أرشيف كامل لملفك الشخصي وجلساتك وتمارينك وسجلاتك';

  @override
  String get exportInProgress => 'جارٍ إعداد ملف التصدير...';

  @override
  String get rateOfPerceivedExertion => 'معدل الجهد المدرك (RPE / RIR)';

  @override
  String get rpeSubtitle =>
      'RPE 10 = الفشل العضلي (0 RIR) • RPE 8 = تكراران متبقيان';

  @override
  String get repsInReserve => 'RIR';

  @override
  String get clearRpe => 'مسح RPE';

  @override
  String get superset => 'مجموعة مركبة (Superset)';

  @override
  String get createSuperset => 'إنشاء مجموعة مركبة';

  @override
  String get unlinkSuperset => 'فصل من المجموعة المركبة';

  @override
  String get supersetLinked => 'تم ربط المجموعة المركبة!';

  @override
  String get supersetUnlinked => 'تم فصل التمرين من المجموعة المركبة';

  @override
  String get supersetLabel => 'مجموعة مركبة';

  @override
  String get linkWithNext => 'ربط مع التمرين التالي';

  @override
  String get weightProgression => 'متابعة وزن الجسم';

  @override
  String get weightProgressionSubtitle => 'منحنى تطور الوزن وسجل القياسات';

  @override
  String get logWeight => 'تسجيل وزن جديد';

  @override
  String get weightHistory => 'سجل الأوزان';

  @override
  String get noWeightHistory =>
      'لا توجد قياسات مسجلة بعد. سجّل وزنك لمتابعة تطور تكوين جسمك.';

  @override
  String get weightDelta => 'التغيير';

  @override
  String get sinceStart => 'منذ البداية';

  @override
  String get weighInDate => 'تاريخ القياس';

  @override
  String get weighInNotes => 'ملاحظات (اختياري)';

  @override
  String get weighInSaved => 'تم حفظ الوزن بنجاح';

  @override
  String get deleteWeighIn => 'حذف القياس';

  @override
  String get deleteWeighInConfirm => 'هل أنت متأكد من رغبتك في حذف هذا القياس؟';

  @override
  String get onboardingPreferencesTitle => 'اللغة والمظهر';

  @override
  String get onboardingPreferencesSubtitle =>
      'اختر لغة ومظهر التطبيق أو احتفظ بإعدادات جهازك';

  @override
  String get chooseLanguage => 'لغة التطبيق';

  @override
  String get chooseTheme => 'المظهر البصري';

  @override
  String get systemDefault => 'النظام (افتراضي)';

  @override
  String get importJsonTitle => 'استيراد نسخة احتياطية JSON';

  @override
  String get importJsonSubtitle =>
      'استعادة ملفك الشخصي وتمارينك المخصصة وسجل تدريباتك من ملف JSON';

  @override
  String get importConfirmTitle => 'استيراد نسخة احتياطية JSON؟';

  @override
  String get importConfirmMessage =>
      'اختر طريقة الاستعادة. الدمج يحتفظ بتمارينك الحالية ويضيف بيانات النسخة الاحتياطية، بينما الاستبدال يمسح السجل الحالي بالكامل.';

  @override
  String get importMergeOption => 'دمج مع البيانات الحالية (موصى به)';

  @override
  String get importOverwriteOption => 'استبدال السجل الحالي بالكامل';

  @override
  String get importFilePathHint =>
      'اختر نسخة احتياطية محلية أو الصق محتوى JSON أدناه';

  @override
  String get importPasteJsonLabel =>
      'محتوى JSON للنسخة الاحتياطية أو مسار الملف';

  @override
  String get importStartButton => 'بدء الاستيراد';

  @override
  String importSuccessMessage(int sessions, int sets) {
    return 'تم استيراد النسخة الاحتياطية بنجاح ($sessions تمارين، $sets مجموعات)!';
  }

  @override
  String importErrorMessage(String error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String get aiCoachCardTitle => 'المدرب الذكي — Google Gemini (مفتاحك الخاص)';

  @override
  String get aiCoachCardSubtitle =>
      'تحليل الزيادة التدريجية ومعدل الجهد والأرقام القياسية';

  @override
  String get aiCoachCardDescription =>
      'استخدم مفتاح Google AI Studio المجاني الخاص بك للحصول على توصيات تدريبية مخصصة دون أي اشتراك مدفوع.';

  @override
  String get aiCoachConfigureButton => 'إعداد مفتاح Gemini الخاص بي';

  @override
  String get aiKeySheetTitle => 'المدرب الذكي — مفتاح Google Gemini';

  @override
  String get aiKeySheetSubtitle => 'استخدم مفتاحك الخاص (BYOK) — مجاني 100%';

  @override
  String get aiKeyPrivacyCallout =>
      'يبقى مفتاحك على جهازك فقط، حيث يتم تشفيره في نظام الحماية الداخلي للهاتف ولا يتم إرساله لأي خادم خارجي.';

  @override
  String get aiKeyStepsTitle => 'كيفية الحصول على مفتاحك المجاني في 30 ثانية:';

  @override
  String get aiKeyStep1 =>
      'سجل الدخول بحساب Google الخاص بك في منصة AI Studio.';

  @override
  String get aiKeyStep2 =>
      'اضغط على \"Create API Key\" (لا يتطلب أي وسيلة دفع).';

  @override
  String get aiKeyStep3 => 'انسخ المفتاح والصقه في الحقل أدناه.';

  @override
  String get aiKeyGetFreeKeyButton =>
      'احصل على مفتاح مجاني من Google AI Studio';

  @override
  String get aiKeyInputLabel => 'مفتاح Google Gemini API (مثال: AIzaSy...)';

  @override
  String get aiKeyInputHint => 'الصق مفتاحك هنا';

  @override
  String get aiKeyPasteTooltip => 'لصق';

  @override
  String get aiKeyValidateAndSaveButton => 'التحقق والحفظ';

  @override
  String get aiKeyDeleteSavedButton => 'حذف المفتاح المحفوظ';

  @override
  String get aiKeyDeleteConfirmTitle => 'حذف مفتاح Gemini؟';

  @override
  String get aiKeyDeleteConfirmMessage =>
      'سيتم إيقاف ميزات التحليل الذكي للتمارين والأرقام القياسية.';

  @override
  String get aiKeyEmptyError => 'يرجى إدخال أو لصق مفتاح Gemini API الخاص بك.';

  @override
  String get aiKeySavedSuccess => 'تم التحقق من مفتاح Gemini وحفظه بأمان!';

  @override
  String get aiKeyDeletedSuccess => 'تم حذف المفتاح.';

  @override
  String get networkConnectionError =>
      'تعذر الاتصال بخوادم Google Gemini. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get aiTimeoutError =>
      'انتهت مهلة الانتظار أثناء الاتصال بخوادم Google Gemini. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get aiAnalysisDialogTitle => 'تحليل المعد البدني الذكي';

  @override
  String get aiAnalysisProgressiveOverloadTitle =>
      'الزيادة التدريجية للأحمال والشدة';

  @override
  String get aiAnalysisRecoveryRpeTitle =>
      'الاستشفاء والإجهاد العضلي (RPE/RIR)';

  @override
  String get aiAnalysisHighlightsTitle => 'نقاط القوة والإنجازات';

  @override
  String get aiAnalysisPlateausRisksTitle => 'نقاط الحذر ومخاطر ثبات المستوى';

  @override
  String get aiAnalysisNextCycleTitle => 'توصيات للدورة التدريبية القادمة';

  @override
  String get aiAnalysisCloseButton => 'إغلاق';

  @override
  String get aiAnalyzeSessionButton => 'تحليل التمرين مع المدرب الذكي Gemini';

  @override
  String get aiAnalyzingProgress => 'جارٍ تحليل التمرين بواسطة المدرب الذكي...';

  @override
  String get finishWorkoutTitle => 'إنهاء وتأكيد التمرين';

  @override
  String get finishWorkoutNotesHint =>
      'كيف كان أداؤك وشعورك في التمرين؟ (ملاحظات، الطاقة، مستوى الجهد...)';

  @override
  String lastWeighInDate(String date) {
    return 'آخر وزن: $date';
  }

  @override
  String singleWeighInHint(String weight) {
    return 'تم تسجيل وزن واحد ($weight كغ). أضف وزناً ثانياً لرسم منحنى التطور!';
  }

  @override
  String get finishWorkoutConfirmTitle => 'إنهاء التمرين؟';

  @override
  String get finishWorkoutIncompleteMessage =>
      'لا تزال هناك مجموعات لم تكتمل. هل أنت متأكد من رغبتك في إنهاء التمرين الآن؟';

  @override
  String get deleteExerciseConfirmTitle => 'حذف التمرين؟';

  @override
  String get deleteExerciseConfirmMessage =>
      'هل أنت متأكد من حذف هذا التمرين وكافة مجموعاته من هذه الجلسة؟';

  @override
  String get deleteSetConfirmTitle => 'حذف المجموعة؟';

  @override
  String get deleteSetConfirmMessage => 'هل أنت متأكد من حذف هذه المجموعة؟';

  @override
  String get backupBeforeDelete => 'تصدير نسخة احتياطية قبل الحذف';

  @override
  String get weightAndHeight => 'الوزن والطول';

  @override
  String get biometricsStepSubtitle =>
      'خصص مقاييس الحجم والوزن الأقصى لنتائج أدق';

  @override
  String get athleteHeightCm => 'الطول (سم)';

  @override
  String get athleteWeightKg => 'الوزن (كغ)';

  @override
  String get continueWorkout => 'متابعة التمرين';

  @override
  String beginnerRecommendationNote(int days) {
    return 'على الرغم من اختيارك $days أيام، نوصي بالبدء بـ 3 جلسات أسبوعياً لتحقيق أفضل تكيف عصبي عضلي دون إجهاد.';
  }

  @override
  String get langArabicDesc => 'واجهة وتدريبات باللغة العربية مع دعم RTL كامل';

  @override
  String get langEnglishDesc => 'واجهة وتدريبات ومقاييس باللغة الإنجليزية';

  @override
  String get langFrenchDesc => 'واجهة وتدريبات ومقاييس باللغة الفرنسية';

  @override
  String get systemDefaultDesc => 'يتبع إعدادات ولغة هاتفك تلقائياً';

  @override
  String get themeSystemDesc => 'يتبع المظهر الفاتح/الداكن لجهازك تلقائياً';

  @override
  String get themeDarkDesc => 'تباين داكن مثالي لصالة الألعاب الرياضية';

  @override
  String get themeLightDesc => 'تصميم أنيق وواضح';

  @override
  String get daysPerWeek3Desc =>
      'كامل الجسم 3 مرات أسبوعياً. مثالي للاستشفاء السريع وبناء قوة الأساس.';

  @override
  String get daysPerWeek4Desc =>
      'تقسيم علوي / سفلي 4 أيام. المعيار العلمي للتضخيم وحجم تدريبي متوازن.';

  @override
  String get daysPerWeek5Desc =>
      'دورة دفع / سحب / أرجل 5 أيام. أقصى تخصص وتحفيز للبناء العضلي.';

  @override
  String get aiAnalyzeProgramButton => 'تدقيق البرنامج بالذكاء الاصطناعي';

  @override
  String get aiProgramAuditTitle => 'تدقيق البرنامج الرياضي بالذكاء الاصطناعي';

  @override
  String get aiProgramAuditSubtitle =>
      'تقييم مخصص لبرنامجك بناءً على استشفائك، نقاط ضعفك وأهدافك الفردية.';

  @override
  String get aiFatigueQuestion => 'مستوى الطاقة والاستشفاء الحالي';

  @override
  String get aiFatigueFresh => 'نشيط ومستعد تماماً';

  @override
  String get aiFatigueModerate => 'تعب معتدل';

  @override
  String get aiFatigueExhausted => 'إرهاق شديد / صعوبة في الاستشفاء';

  @override
  String get aiWeakPointQuestion => 'المجموعة العضلية المستهدفة أو نقطة الضعف';

  @override
  String get aiFocusBalanced => 'متوازن (شامل)';

  @override
  String get aiFocusChest => 'الصدر';

  @override
  String get aiFocusBack => 'الظهر والسلسلة الخلفية';

  @override
  String get aiFocusLegs => 'الأرجل والمؤخرة';

  @override
  String get aiFocusShouldersArms => 'الأكتاف والذراعين';

  @override
  String get aiTimeConstraintQuestion => 'المدة المستهدفة للجلسة التدريبية';

  @override
  String get aiPainQuestion => 'آلام المفاصل أو الإصابات';

  @override
  String get aiPainNone => 'لا توجد أي آلام';

  @override
  String get aiPainShoulders => 'الأكتاف';

  @override
  String get aiPainLowerBack => 'أسفل الظهر';

  @override
  String get aiPainKnees => 'الركبتين';

  @override
  String get aiPainElbowsWrists => 'المرفقين / المعصمين';

  @override
  String get aiFreeTextLabel => 'ملاحظات وطلبات خاصة (نص حر)';

  @override
  String get aiFreeTextHint =>
      'مثال: أريد التركيز على الأكتاف الجانبية، وتجنب السكوات الثقيل بسبب ألم الركبة...';

  @override
  String get aiLaunchProgramAudit => 'بدء تحليل البرنامج بواسطة جيميني';

  @override
  String get aiProgramScoreLabel => 'درجة ملاءمة البرنامج';

  @override
  String get aiProgramModificationsTitle => 'التعديلات والبدائل الموصى بها';

  @override
  String get aiProgramInjuryTipsTitle =>
      'الوقاية الميكانيكية الحيوية وتفادي الإصابات';

  @override
  String get aiProgramPeriodizationTitle => 'التخطيط التدريبي والتدرج في الشدة';

  @override
  String get aiAnalyzeHistoryButton => 'تقرير التقدم بالذكاء الاصطناعي';

  @override
  String get aiHistoryAuditTitle => 'تقرير تقدم التدريب بالذكاء الاصطناعي';

  @override
  String get aiHistoryAuditSubtitle =>
      'تحليل شامل لزيادة الأحمال التدريجية، الحجم ومحطات الثبات عبر كافة جلساتك.';

  @override
  String get aiHistoryScoreLabel => 'درجة الانتظام والزيادة التدريجية';

  @override
  String get aiHistoryVolumeTrajectory => 'مسار الحجم التدريبي';

  @override
  String get aiHistoryOverloadAssessment => 'جودة الزيادة التدريجية في الأحمال';

  @override
  String get aiHistoryMuscleBalance => 'التوازن العضلي الإجمالي';

  @override
  String get aiHistoryPlateausTitle => 'تنبيهات ثبات الأوزان والإجهاد العصبي';

  @override
  String get aiHistoryMilestonesTitle => 'أهداف الدورة التدريبية القادمة';

  @override
  String get viewWorkoutHistory => 'عرض سجل التمارين';

  @override
  String get tabWorkouts => 'الجلسات';

  @override
  String get tabAiReports => 'تقارير المدرب الذكي';

  @override
  String get noAiReportsYet =>
      'لم يتم إنشاء أي تقرير بعد. ابدأ بتحليل برنامجك أو سجل تمارينك!';

  @override
  String get configureApiKeyPrompt =>
      'قم بإعداد مفتاح Gemini لتفعيل تحليلات المدرب الذكي.';

  @override
  String get aiGenerateRoutine => 'إنشاء بالذكاء الاصطناعي';

  @override
  String get aiRoutineGeneratorTitle => 'مولد البرامج التدريبية الذكي';

  @override
  String get aiRoutineGeneratorSubtitle =>
      'صف أهدافك والوقت المتاح والمعدات — وسيقوم جيميني بتصميم برنامج تدريبي متكامل داخل التطبيق.';

  @override
  String get aiPromptInputLabel => 'أهدافك ورغباتك (طلب حر)';

  @override
  String get aiPromptInputHint =>
      'مثال: حصة 45 دقيقة صدر وترايسبس بالدمبلز فقط، تجنب الضغط على أسفل الظهر...';

  @override
  String get aiGenerateRoutineButton => 'تصميم البرنامج بواسطة جيميني';

  @override
  String get aiSaveRoutineToDatabase => 'حفظ في تماريني';

  @override
  String get aiStartRoutineImmediately => 'بدء التمرين الآن';

  @override
  String get aiRoutineCreatedSuccess =>
      'تم حفظ البرنامج التدريبي بنجاح في قائمة تمارينك!';
}
