// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Strong Track';

  @override
  String get sets => 'Séries';

  @override
  String get set => 'Série';

  @override
  String get reps => 'Répétitions';

  @override
  String get weight => 'Poids';

  @override
  String get weightKg => 'Poids (kg)';

  @override
  String get height => 'Taille';

  @override
  String get heightCm => 'Taille (cm)';

  @override
  String get rpe => 'RPE';

  @override
  String get restTimer => 'Chronomètre de repos';

  @override
  String get addExercise => 'Ajouter un exercice';

  @override
  String get finishWorkout => 'Terminer la séance';

  @override
  String get startWorkout => 'Démarrer la séance';

  @override
  String get cancelWorkout => 'Annuler la séance';

  @override
  String get history => 'Historique';

  @override
  String get workoutHistory => 'Historique des séances';

  @override
  String get templates => 'Modèles';

  @override
  String get settings => 'Paramètres';

  @override
  String get exercises => 'Exercices';

  @override
  String get searchExercises => 'Rechercher des exercices...';

  @override
  String get customExercise => 'Exercice personnalisé';

  @override
  String get previous => 'Précédent';

  @override
  String get notes => 'Remarques';

  @override
  String get duration => 'Durée';

  @override
  String get completed => 'Terminé';

  @override
  String get emptyHistory =>
      'Aucun entraînement enregistré pour le moment. Commencez dès aujourd\'hui !';

  @override
  String get emptyTemplates => 'Aucun modèle d\'entraînement trouvé.';

  @override
  String get discardDialogTitle => 'Abandonner la séance ?';

  @override
  String get discardDialogMessage =>
      'Êtes-vous sûr de vouloir abandonner cette séance ? Tout le progrès sera perdu.';

  @override
  String get discard => 'Abandonner';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get navWorkout => 'Entraînement';

  @override
  String get navHistory => 'Historique';

  @override
  String get navExercises => 'Exercices';

  @override
  String get navProfile => 'Profil';

  @override
  String get quickStart => 'Démarrage rapide';

  @override
  String get quickStartSubtitle => 'Démarrer une séance libre vide';

  @override
  String get routines => 'Programmes recommandés';

  @override
  String get startRoutine => 'Lancer le programme';

  @override
  String templateExercisesCount(int count) {
    return '$count exercices';
  }

  @override
  String get ongoingWorkout => 'Séance active en cours';

  @override
  String get resumeWorkout => 'Reprendre la séance';

  @override
  String get templateFullBodyTitle => 'Full Body (Corps entier)';

  @override
  String get templateFullBodyDesc =>
      'Programme équilibré ciblant les grands mouvements polyarticulaires. Idéal 3-4 jours/semaine.';

  @override
  String get templateUpperTitle => 'Haut du corps (Upper Body)';

  @override
  String get templateUpperDesc =>
      'Force et hypertrophie pour pectoraux, dos, épaules et bras.';

  @override
  String get templateLowerTitle => 'Bas du corps & Tronc';

  @override
  String get templateLowerDesc =>
      'Quadriceps, ischios, fessiers et stabilité des abdominaux.';

  @override
  String get templatePushTitle => 'Séance Push (Pectoraux, Épaules, Triceps)';

  @override
  String get templatePushDesc =>
      'Développés lourds et travail des faisceaux latéraux des deltoïdes.';

  @override
  String get templatePullTitle => 'Séance Pull (Dos, Biceps, Soulevé)';

  @override
  String get templatePullDesc =>
      'Développement de la chaîne postérieure avec soulevés, tirages et curls.';

  @override
  String get profile => 'Profil Athlète';

  @override
  String get editProfile => 'Modifier le profil & mensurations';

  @override
  String get athleteName => 'Nom de l\'athlète';

  @override
  String get weeklyGoal => 'Objectif hebdomadaire';

  @override
  String workoutsPerWeek(int count) {
    return '$count séances / semaine';
  }

  @override
  String get experienceLevel => 'Niveau d\'expérience';

  @override
  String get beginner => 'Débutant';

  @override
  String get intermediate => 'Intermédiaire';

  @override
  String get advanced => 'Avancé (Pro)';

  @override
  String get consistencyScore => 'Régularité de la semaine';

  @override
  String workoutsDoneThisWeek(int completed, int goal) {
    return '$completed sur $goal séances complétées';
  }

  @override
  String get bmiLabel => 'Indice de Masse Corporelle (IMC)';

  @override
  String get totalWorkouts => 'Séances terminées';

  @override
  String get totalVolumeLifted => 'Volume total (kg)';

  @override
  String get appSettings => 'Paramètres & Langue';

  @override
  String get languageSelection => 'Langue de l\'application';

  @override
  String get readyToLift => 'PRÊT À SOULEVER !';

  @override
  String get resting => 'REPOS EN COURS';

  @override
  String get timerPaused => 'EN PAUSE';

  @override
  String get quickPresets => 'Préréglages rapides';

  @override
  String get autoStartOnSet => 'Démarrage auto après chaque série';

  @override
  String get tapToAdjust => 'Appuyer pour ajuster le chrono';

  @override
  String get tapToStartNextSet => 'Appuyer pour la série suivante';

  @override
  String get timerReady => 'PRÊT';

  @override
  String get restBetweenSets => 'Entre les séries';

  @override
  String get restBetweenExercises => 'Entre les exercices';

  @override
  String nextExercise(String name) {
    return 'Suivant : $name';
  }

  @override
  String get restNotificationTitle => 'Repos terminé';

  @override
  String get restNotificationBody => 'C\'est l\'heure de la série suivante 💪';

  @override
  String get restNotificationsSetting => 'Alerte écran verrouillé';

  @override
  String get restVibrationSetting => 'Vibration';

  @override
  String get exerciseRest => 'Repos pour cet exercice';

  @override
  String useDefaultRest(String duration) {
    return 'Par défaut ($duration)';
  }

  @override
  String get restSettings => 'Réglages du repos';

  @override
  String get skip => 'Passer';

  @override
  String get restGuide =>
      'Force 2–5 min · Hypertrophie 60–90 s · Endurance 30–60 s';

  @override
  String get plateCalculator => 'Calculateur de disques';

  @override
  String get warmupCalculator => 'Séries d\'échauffement';

  @override
  String get personalRecord => 'PR';

  @override
  String get newPrAchieved => 'Nouveau Record Personnel ! 🏆';

  @override
  String get estimatedOneRepMax => '1RM estimé';

  @override
  String get barWeight => 'Poids de la barre';

  @override
  String get perSide => 'Par côté';

  @override
  String get muscleGroupChest => 'Poitrine';

  @override
  String get muscleGroupBack => 'Dos';

  @override
  String get muscleGroupLegs => 'Jambes';

  @override
  String get muscleGroupShoulders => 'Épaules';

  @override
  String get muscleGroupArms => 'Bras';

  @override
  String get muscleGroupCore => 'Abdominaux / Tronc';

  @override
  String get equipmentBarbell => 'Barre';

  @override
  String get equipmentDumbbell => 'Haltère';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentBodyweight => 'Poids du corps';

  @override
  String get equipmentCables => 'Câbles';

  @override
  String get setTypeNormal => 'Normal';

  @override
  String get setTypeWarmup => 'Échauffement';

  @override
  String get setTypeDropset => 'Série dégressive';

  @override
  String get setTypeFailure => 'Échec musculaire';

  @override
  String get exercise_bench_press => 'Développé couché à la barre';

  @override
  String get exercise_incline_dumbbell_press =>
      'Développé incliné aux haltères';

  @override
  String get exercise_push_up => 'Pompes';

  @override
  String get exercise_deadlift => 'Soulevé de terre';

  @override
  String get exercise_barbell_row => 'Rowing barre buste penché';

  @override
  String get exercise_pull_up => 'Tractions pronation';

  @override
  String get exercise_lat_pulldown => 'Tirage vertical à la poulie';

  @override
  String get exercise_squat => 'Squat à la barre';

  @override
  String get exercise_leg_press => 'Presse à cuisses';

  @override
  String get exercise_romanian_deadlift => 'Soulevé de terre roumain';

  @override
  String get exercise_overhead_press => 'Développé militaire à la barre';

  @override
  String get exercise_lateral_raise => 'Élévations latérales aux haltères';

  @override
  String get exercise_barbell_curl => 'Curl biceps à la barre';

  @override
  String get exercise_triceps_pushdown => 'Extension triceps à la poulie';

  @override
  String get exercise_plank => 'Gainage ventral (Planche)';

  @override
  String get exercise_hanging_leg_raise => 'Relevé de jambes suspendu';

  @override
  String get exercise_dips => 'Dips (Pectoraux / Triceps)';

  @override
  String get exercise_cable_fly => 'Écartés à la poulie vis-à-vis';

  @override
  String get exercise_chin_up => 'Tractions supination (Chin-Up)';

  @override
  String get exercise_dumbbell_row => 'Rowing haltère à un bras';

  @override
  String get exercise_seated_cable_row => 'Tirage horizontal à la poulie';

  @override
  String get exercise_lunges => 'Fentes marchées aux haltères';

  @override
  String get exercise_hip_thrust => 'Hip Thrust à la barre';

  @override
  String get exercise_bulgarian_split_squat => 'Squat bulgare aux haltères';

  @override
  String get exercise_leg_extension => 'Leg Extension à la machine';

  @override
  String get exercise_leg_curl => 'Leg Curl ischio-jambiers';

  @override
  String get exercise_calf_raise => 'Mollets debout à la machine';

  @override
  String get exercise_dumbbell_shoulder_press =>
      'Développé épaules aux haltères';

  @override
  String get exercise_face_pull => 'Face Pull à la poulie haute';

  @override
  String get exercise_hammer_curl => 'Curl marteau aux haltères';

  @override
  String get exercise_incline_dumbbell_curl =>
      'Curl biceps incliné aux haltères';

  @override
  String get exercise_overhead_triceps_extension =>
      'Extension triceps au-dessus de la tête';

  @override
  String get exercise_skull_crusher => 'Barre au front (Skull Crusher)';

  @override
  String get exercise_cable_crunch => 'Crunch abdominal à la poulie haute';

  @override
  String get exerciseGuide => 'Guide d\'exercice';

  @override
  String get techniqueGuide => 'Technique & Conseils';

  @override
  String get setupInstructions => 'Mise en place';

  @override
  String get executionInstructions => 'Exécution & Mouvement';

  @override
  String get breathingInstructions => 'Respiration';

  @override
  String get commonMistakes => 'Erreurs fréquentes';

  @override
  String get coachTip => 'Conseil du coach';

  @override
  String get targetMuscles => 'Muscles ciblés';

  @override
  String get primaryMuscles => 'Principaux';

  @override
  String get secondaryMuscles => 'Secondaires';

  @override
  String get tempo => 'Tempo';

  @override
  String get hypertrophyRange => 'Rep-range hypertrophie';

  @override
  String get strengthRange => 'Rep-range force';

  @override
  String get viewGuide => 'Voir le guide';

  @override
  String get findIdealProgram => 'Trouver mon programme idéal';

  @override
  String get onboardingSubtitle =>
      'Répondez à 3 questions pour trouver la routine adaptée à votre niveau et vos objectifs';

  @override
  String get stepTrainingGoal => 'Étape 1 : Votre objectif principal';

  @override
  String get goalHypertrophy => 'Prise de muscle (Hypertrophie)';

  @override
  String get goalHypertrophyDesc =>
      'Maximiser le volume et la surcharge progressive pour développer la masse musculaire.';

  @override
  String get goalStrength => 'Gain de force athlétique';

  @override
  String get goalStrengthDesc =>
      'Charges lourdes sur les mouvements polyarticulaires pour la force maximale.';

  @override
  String get goalFitness => 'Remise en forme & Santé';

  @override
  String get goalFitnessDesc =>
      'Programme complet pour la santé, l\'endurance et l\'équilibre musculaire.';

  @override
  String get stepWeeklyAvailability => 'Étape 2 : Jours par semaine';

  @override
  String daysPerWeek(int days) {
    return '$days jours par semaine';
  }

  @override
  String get stepExperienceLevel => 'Étape 3 : Niveau d\'expérience';

  @override
  String get levelBeginner => 'Débutant (< 1 an)';

  @override
  String get levelBeginnerDesc =>
      'Apprentissage des trajectoires motrices, régularité et progression rapide.';

  @override
  String get levelIntermediate => 'Intermédiaire (1 - 3 ans)';

  @override
  String get levelIntermediateDesc =>
      'Maîtrise des mouvements polyarticulaires, prêt pour une surcharge structurée.';

  @override
  String get levelAdvanced => 'Avancé / Pro (3+ ans)';

  @override
  String get levelAdvancedDesc =>
      'Grande capacité de volume, gestion fine de la fatigue et du RPE.';

  @override
  String get recommendedRoutineTitle => 'Votre routine recommandée';

  @override
  String get startRecommendedRoutine => 'Démarrer ce programme';

  @override
  String routineMatchedReason(int days, String goal) {
    return 'Selon vos $days jours et votre objectif de $goal, ce programme offre la fréquence et la récupération optimales.';
  }

  @override
  String get applyAndSave => 'Enregistrer dans mon profil';

  @override
  String get onboardingDone => 'Profil mis à jour !';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get createRoutine => 'Créer un programme';

  @override
  String get routineName => 'Nom du programme';

  @override
  String get saveAsRoutine => 'Enregistrer comme programme';

  @override
  String get routineSaved => 'Enregistré dans vos programmes !';

  @override
  String get repeatWorkout => 'Relancer cette séance';

  @override
  String get sessionDetails => 'Détails de la séance';

  @override
  String get muscleDistribution => 'Répartition musculaire';

  @override
  String get progressionHistory => 'Progression du 1RM';

  @override
  String get themeMode => 'Mode d\'affichage';

  @override
  String get themeDark => 'Mode Sombre';

  @override
  String get themeLight => 'Mode Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get dangerZone => 'Zone de danger';

  @override
  String get deleteProfile => 'Supprimer le profil et les données';

  @override
  String get deleteProfileDesc =>
      'Efface définitivement votre profil d\'athlète, l\'historique d\'entraînement et les données biométriques.';

  @override
  String get deleteProfileConfirmTitle => 'Supprimer le profil ?';

  @override
  String get deleteProfileConfirmMessage =>
      'Cette action est irréversible. Toutes vos séances d\'entraînement, séries, historique de volume et données biométriques seront définitivement effacés.';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get profileDeletedSuccess =>
      'Profil et données d\'athlète réinitialisés';

  @override
  String get customWorkoutTitle => 'Séance personnalisée';

  @override
  String get customWorkoutSubtitle =>
      'Démarrer une séance libre et ajouter vos exercices';

  @override
  String get findIdealWorkoutTitle => 'Trouver votre séance idéale';

  @override
  String get findIdealWorkoutSubtitle =>
      'Répondez à 3 questions rapides pour trouver la séance qui vous correspond';

  @override
  String get yourProgram => 'Votre programme';

  @override
  String get readyTemplates => 'Séances types & modèles';

  @override
  String get oneHandedMode => 'Saisie rapide à 1 main';

  @override
  String get validateSet => 'Valider la série';

  @override
  String get copyPrevious => 'Copier précédent';

  @override
  String get tapToCopy => 'Toucher pour copier';

  @override
  String get activeSet => 'Série active';

  @override
  String get quickAdjustWeight => 'Charge';

  @override
  String get quickAdjustReps => 'Répétitions';

  @override
  String get exportSectionTitle => 'Sauvegarde & Export de données';

  @override
  String get exportCsvTitle => 'Exporter en CSV (Excel / Strong / Hevy)';

  @override
  String get exportCsvSubtitle =>
      'Fichier tabulaire complet pour Excel, Google Sheets ou d\'autres applications';

  @override
  String get exportJsonTitle => 'Sauvegarde complète JSON';

  @override
  String get exportJsonSubtitle =>
      'Archive intégrale de votre profil, historique, exercices et séries';

  @override
  String get exportInProgress => 'Génération du fichier d\'export...';

  @override
  String get rateOfPerceivedExertion => 'Effort perçu (RPE / RIR)';

  @override
  String get rpeSubtitle =>
      'RPE 10 = Échec postural (0 RIR) • RPE 8 = 2 reps en réserve';

  @override
  String get repsInReserve => 'RIR';

  @override
  String get clearRpe => 'Effacer RPE';

  @override
  String get superset => 'Superset';

  @override
  String get createSuperset => 'Créer un superset';

  @override
  String get unlinkSuperset => 'Dissocier du superset';

  @override
  String get supersetLinked => 'Superset associé !';

  @override
  String get supersetUnlinked => 'Exercice dissocié du superset';

  @override
  String get supersetLabel => 'SUPERSET';

  @override
  String get linkWithNext => 'Lier avec l\'exercice suivant';

  @override
  String get weightProgression => 'Suivi du poids';

  @override
  String get weightProgressionSubtitle =>
      'Évolution corporelle & historique des pesées';

  @override
  String get logWeight => 'Nouvelle pesée';

  @override
  String get weightHistory => 'Historique des pesées';

  @override
  String get noWeightHistory =>
      'Aucune pesée enregistrée. Notez votre poids pour suivre votre progression.';

  @override
  String get weightDelta => 'Évolution';

  @override
  String get sinceStart => 'depuis le début';

  @override
  String get weighInDate => 'Date de la pesée';

  @override
  String get weighInNotes => 'Notes (facultatif)';

  @override
  String get weighInSaved => 'Pesée enregistrée avec succès';

  @override
  String get deleteWeighIn => 'Supprimer la pesée';

  @override
  String get deleteWeighInConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette pesée ?';

  @override
  String get onboardingPreferencesTitle => 'Langue & Apparence';

  @override
  String get onboardingPreferencesSubtitle =>
      'Choisissez vos préférences d\'affichage ou conservez celles de votre système';

  @override
  String get chooseLanguage => 'Langue de l\'application';

  @override
  String get chooseTheme => 'Thème visuel';

  @override
  String get systemDefault => 'Système (Par défaut)';

  @override
  String get importJsonTitle => 'Importer une sauvegarde JSON';

  @override
  String get importJsonSubtitle =>
      'Restaurer votre profil, vos exercices personnalisés et votre historique depuis un fichier JSON';

  @override
  String get importConfirmTitle => 'Importer une sauvegarde JSON ?';

  @override
  String get importConfirmMessage =>
      'Choisissez le mode de restauration. La fusion conserve vos séances actuelles et ajoute celles de la sauvegarde. L\'écrasement remplace tout l\'historique actuel.';

  @override
  String get importMergeOption =>
      'Fusionner avec les données actuelles (Recommandé)';

  @override
  String get importOverwriteOption => 'Écraser l\'historique existant';

  @override
  String get importFilePathHint =>
      'Sélectionnez une sauvegarde locale ou collez le contenu JSON ci-dessous';

  @override
  String get importPasteJsonLabel =>
      'Contenu JSON de sauvegarde ou chemin du fichier';

  @override
  String get importStartButton => 'Lancer l\'importation';

  @override
  String importSuccessMessage(int sessions, int sets) {
    return 'Sauvegarde importée avec succès ($sessions séances, $sets séries) !';
  }

  @override
  String importErrorMessage(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String get aiCoachCardTitle => 'Coach IA — Google Gemini (BYOK)';

  @override
  String get aiCoachCardSubtitle =>
      'Analyse de surcharge progressive, RPE et records';

  @override
  String get aiCoachCardDescription =>
      'Utilisez votre propre clé d\'API Google AI Studio pour obtenir des recommandations d\'entraînement personnalisées et sans abonnement payant.';

  @override
  String get aiCoachConfigureButton => 'Configurer ma clé Gemini';

  @override
  String get aiKeySheetTitle => 'Coach IA — Clé Google Gemini';

  @override
  String get aiKeySheetSubtitle => 'Bring Your Own Key (BYOK) — 100% Gratuit';

  @override
  String get aiKeyPrivacyCallout =>
      'Votre clé reste sur votre appareil. Elle est chiffrée dans le Keystore Android / Keychain iOS et n\'est jamais transmise à un serveur tiers.';

  @override
  String get aiKeyStepsTitle =>
      'Comment obtenir votre clé gratuite en 30 secondes :';

  @override
  String get aiKeyStep1 =>
      'Connectez-vous avec votre compte Google sur AI Studio.';

  @override
  String get aiKeyStep2 =>
      'Cliquez sur \"Create API Key\" (aucun moyen de paiement requis).';

  @override
  String get aiKeyStep3 =>
      'Copiez la clé et collez-la dans le champ ci-dessous.';

  @override
  String get aiKeyGetFreeKeyButton =>
      'Obtenir une clé gratuite sur Google AI Studio';

  @override
  String get aiKeyInputLabel => 'Clé d\'API Google Gemini (ex: AIzaSy...)';

  @override
  String get aiKeyInputHint => 'Collez votre clé ici';

  @override
  String get aiKeyPasteTooltip => 'Coller';

  @override
  String get aiKeyValidateAndSaveButton => 'Valider et Sauvegarder';

  @override
  String get aiKeyDeleteSavedButton => 'Supprimer la clé enregistrée';

  @override
  String get aiKeyDeleteConfirmTitle => 'Supprimer la clé Gemini ?';

  @override
  String get aiKeyDeleteConfirmMessage =>
      'Les fonctionnalités d\'analyse automatique de séances et de records seront désactivées.';

  @override
  String get aiKeyEmptyError =>
      'Veuillez saisir ou coller votre clé API Gemini.';

  @override
  String get aiKeySavedSuccess =>
      'Clé Gemini validée et enregistrée de façon sécurisée !';

  @override
  String get aiKeyDeletedSuccess => 'Clé supprimée.';

  @override
  String get networkConnectionError =>
      'Impossible de contacter les serveurs Google Gemini. Vérifiez votre connexion Internet.';

  @override
  String get aiTimeoutError =>
      'Délai d\'attente dépassé lors de la communication avec Google Gemini. Vérifiez votre connexion Internet.';

  @override
  String get aiAnalysisDialogTitle => 'Analyse Préparateur Physique';

  @override
  String get aiAnalysisProgressiveOverloadTitle =>
      'Surcharge Progressive & Intensité';

  @override
  String get aiAnalysisRecoveryRpeTitle => 'Récupération & Fatigue (RPE/RIR)';

  @override
  String get aiAnalysisHighlightsTitle => 'Points Forts & Accomplissements';

  @override
  String get aiAnalysisPlateausRisksTitle => 'Points de Vigilance & Risques';

  @override
  String get aiAnalysisNextCycleTitle =>
      'Recommandations pour le prochain cycle';

  @override
  String get aiAnalysisCloseButton => 'Fermer';

  @override
  String get aiAnalyzeSessionButton => 'Analyser avec le Coach IA Gemini';

  @override
  String get aiAnalyzingProgress => 'Analyse par le Coach IA en cours...';

  @override
  String get finishWorkoutTitle => 'Valider la séance';

  @override
  String get finishWorkoutNotesHint =>
      'Comment s\'est passée la séance ? (Sensations, RPE, énergie...)';

  @override
  String lastWeighInDate(String date) {
    return 'Dernière pesée : $date';
  }

  @override
  String singleWeighInHint(String weight) {
    return '1 pesée enregistrée ($weight kg). Ajoutez une 2ème pesée pour tracer votre courbe d\'évolution !';
  }

  @override
  String get finishWorkoutConfirmTitle => 'Terminer la séance ?';

  @override
  String get finishWorkoutIncompleteMessage =>
      'Il vous reste des séries non complétées. Souhaitez-vous vraiment terminer la séance maintenant ?';

  @override
  String get deleteExerciseConfirmTitle => 'Supprimer l\'exercice ?';

  @override
  String get deleteExerciseConfirmMessage =>
      'Voulez-vous supprimer cet exercice et toutes ses séries de la séance ?';

  @override
  String get deleteSetConfirmTitle => 'Supprimer la série ?';

  @override
  String get deleteSetConfirmMessage => 'Voulez-vous supprimer cette série ?';

  @override
  String get backupBeforeDelete => 'Exporter une sauvegarde avant de supprimer';

  @override
  String get weightAndHeight => 'Poids & Taille';

  @override
  String get biometricsStepSubtitle =>
      'Personnalisez vos métriques de volume et de 1RM';

  @override
  String get athleteHeightCm => 'Taille (cm)';

  @override
  String get athleteWeightKg => 'Poids (kg)';

  @override
  String get continueWorkout => 'Continuer la séance';

  @override
  String beginnerRecommendationNote(int days) {
    return 'Bien que vous ayez sélectionné $days jours, nous recommandons de débuter par 3 séances par semaine pour optimiser votre récupération neuromusculaire.';
  }
}
