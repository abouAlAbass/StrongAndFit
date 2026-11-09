/// Model representing comprehensive biomechanical execution guidelines,
/// anatomical muscle targeting, coaching cues, and optional visual illustration asset.
class ExerciseGuide {
  final String slug;
  final String title;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> setupInstructions;
  final List<String> executionInstructions;
  final String breathingInstructions;
  final List<String> commonMistakes;
  final String coachTip;
  final String hypertrophyRepRange;
  final String strengthRepRange;
  final String tempo;
  final String? assetIllustrationPath;

  const ExerciseGuide({
    required this.slug,
    required this.title,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.setupInstructions,
    required this.executionInstructions,
    required this.breathingInstructions,
    required this.commonMistakes,
    required this.coachTip,
    this.hypertrophyRepRange = '8 - 12 reps (RPE 7-8)',
    this.strengthRepRange = '3 - 6 reps (RPE 8-9)',
    this.tempo = '3-0-1-0',
    this.assetIllustrationPath,
  });
}
