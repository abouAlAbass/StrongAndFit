import '../domain/models/exercise_guide.dart';

/// Comprehensive scientific exercise guidance catalog providing step-by-step
/// setup, kinematic execution cues, breathing patterns, common mistakes, and pro coaching tips.
///
/// Fully localized in French (fr), English (en), and Arabic (ar).
class ExerciseGuidesData {
  ExerciseGuidesData._();

  static ExerciseGuide getGuide(
    String slug,
    String languageCode, {
    String? displayName,
  }) {
    final lang = _normalizeLanguage(languageCode);
    final map = _guidesByLanguage[lang] ?? _guidesByLanguage['en']!;

    if (map.containsKey(slug)) {
      return map[slug]!;
    }

    // Fallback for custom or uncatalogued exercise
    return _buildFallbackGuide(slug, displayName ?? slug, lang);
  }

  static String _normalizeLanguage(String code) {
    if (code.startsWith('fr')) return 'fr';
    if (code.startsWith('ar')) return 'ar';
    return 'en';
  }

  static ExerciseGuide _buildFallbackGuide(
    String slug,
    String name,
    String lang,
  ) {
    switch (lang) {
      case 'fr':
        return ExerciseGuide(
          slug: slug,
          title: name,
          primaryMuscles: ['Muscle principal cibl\u00e9'],
          secondaryMuscles: ['Muscles stabilisateurs'],
          setupInstructions: [
            'R\u00e9glez le mat\u00e9riel \u00e0 votre morphologie avant de charger.',
            'Adoptez une posture stable : pieds ancr\u00e9s, cage thoracique ouverte, sangle abdominale verrouill\u00e9e.',
          ],
          executionInstructions: [
            'Effectuez une phase excentrique contr\u00f4l\u00e9e (2 \u00e0 3 secondes).',
            'Marquez un l\u00e9ger point d\'arr\u00eat en bas de mouvement.',
            'Poussez ou tirez de mani\u00e8re explosive sans \u00e0-coups.',
          ],
          breathingInstructions:
              'Inspirez sur la descente (excentrique), bloquez ou expirez \u00e0 l\'effort maximal (concentrique).',
          commonMistakes: [
            'Mettre trop lourd au d\u00e9triment de l\'amplitude compl\u00e8te.',
            'Utiliser l\'\u00e9lan et la vitesse plut\u00f4t que la tension musculaire continue.',
          ],
          coachTip:
              'Concentrez-vous sur la connexion esprit-muscle et contr\u00f4lez chaque millim\u00e8tre de la trajectoire.',
        );
      case 'ar':
        return ExerciseGuide(
          slug: slug,
          title: name,
          primaryMuscles: ['العضلة الأساسية'],
          secondaryMuscles: ['عضلات الدعم والتوازن'],
          setupInstructions: [
            'اضبط الأجهزة والمقعد بما يناسب طولك ومفاصلك قبل إضافة الأوزان.',
            'ثبّت قدميك جيداً على الأرض، وافتح القفص الصدري وشد عضلات البطن.',
          ],
          executionInstructions: [
            'انزل ببطء وتحكم تام لمدة ثانيتين إلى 3 ثوانٍ.',
            'توقف جزءاً من الثانية عند أقصى استطالة دون إرخاء العضلة.',
            'ادفع أو اسحب بقوة وتركيز عبر المدى الحركي الكامل.',
          ],
          breathingInstructions:
              'خذ نفساً عميقاً أثناء مرحلة الهبوط (الانبساط)، وازفر بقوة مع دفع الوزن (الانقباض).',
          commonMistakes: [
            'استخدام أوزان مفرطة تقلل من المدى الحركي الكامل.',
            'الاعتماد على الدفع والاهتزاز بدلاً من السيطرة العضلية المستمرة.',
          ],
          coachTip:
              'ركز على الاتصال العضلي العصبي وتحكّم في الوزن بدلاً من أن يدع الوزن يتحكم بك.',
        );
      default:
        return ExerciseGuide(
          slug: slug,
          title: name,
          primaryMuscles: ['Primary Target Muscle'],
          secondaryMuscles: ['Stabilizers & Synergists'],
          setupInstructions: [
            'Adjust equipment to your individual biomechanics before loading weight.',
            'Establish a solid base: feet firmly planted, chest tall, and core braced.',
          ],
          executionInstructions: [
            'Lower the resistance under full control (2 to 3-second eccentric phase).',
            'Pause momentarily at the deepest active range without losing tension.',
            'Drive concentrically with intent and smooth, continuous force.',
          ],
          breathingInstructions:
              'Inhale and brace during the eccentric descent; exhale through the sticking point.',
          commonMistakes: [
            'Sacrificing full active range of motion for excessive weight.',
            'Using ballistic momentum instead of isolated muscular tension.',
          ],
          coachTip:
              'Prioritize mind-muscle connection and control every inch of the bar path.',
        );
    }
  }

  // ===========================================================================
  // LOCALIZED GUIDES DICTIONARIES
  // ===========================================================================

  static final Map<String, Map<String, ExerciseGuide>> _guidesByLanguage = {
    'fr': _frenchGuides,
    'en': _englishGuides,
    'ar': _arabicGuides,
  };

  // ---------------------------------------------------------------------------
  // FRENCH GUIDES
  // ---------------------------------------------------------------------------
  static final Map<String, ExerciseGuide> _frenchGuides = {
    'bench_press': const ExerciseGuide(
      slug: 'bench_press',
      title: 'D\u00e9velopp\u00e9 couch\u00e9 \u00e0 la barre',
      primaryMuscles: ['Grand pectoral (moyen et inf\u00e9rieur)'],
      secondaryMuscles: [
        'Triceps brachial',
        'Delto\u00efde ant\u00e9rieur',
        'Dentel\u00e9 ant\u00e9rieur',
      ],
      setupInstructions: [
        'Allongez-vous avec les yeux align\u00e9s sous la barre.',
        'Pieds fermement ancr\u00e9s \u00e0 plat au sol pour maximiser le leg drive.',
        'Resserrez vos omoplates vers l\'arri\u00e8re et le bas (r\u00e9traction scapulaire) et maintenez une cambrure lombaire naturelle.',
        'Saisissez la barre avec une prise l\u00e9g\u00e8rement sup\u00e9rieure \u00e0 la largeur d\'\u00e9paules (avant-bras verticaux en bas).',
      ],
      executionInstructions: [
        'D\u00e9crochez la barre et stabilisez-la au-dessus de vos \u00e9paules.',
        'Descendez la barre de fa\u00e7on contr\u00f4l\u00e9e en trajectoire diagonale vers le bas de la poitrine (sternum).',
        'Gardez les coudes \u00e0 un angle de 45\u00b0 \u00e0 70\u00b0 par rapport au buste (ne pas \u00e9carter \u00e0 90\u00b0).',
        'Effleurez l\u00e9g\u00e8rement le torse, puis poussez en trajectoire arqu\u00e9e vers le haut et l\'arri\u00e8re au-dessus des \u00e9paules.',
      ],
      breathingInstructions:
          'Grande inspiration thoracique et verrouillage abdominal (man\u0153uvre de Valsalva) avant la descente ; expirez pass\u00e9 le point de blocage en fin de remont\u00e9e.',
      commonMistakes: [
        'Laisser les \u00e9paules partir vers l\'avant (perte de r\u00e9traction des omoplates en bas).',
        'Rebondir avec \u00e9nergie sur la cage thoracique.',
        'Coudes trop ouverts \u00e0 90\u00b0 provoquant un pincement acromial.',
        'D\u00e9coller les fessiers du banc pendant la pouss\u00e9e.',
      ],
      coachTip:
          'Pensez \u00e0 \u00ab plier la barre en deux \u00bb pour activer vos dorsaux et verrouiller vos coudes dans l\'angle parfait.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '3 - 6 reps (RPE 8-9)',
      tempo: '3-1-1-0',
    ),
    'squat': const ExerciseGuide(
      slug: 'squat',
      title: 'Squat \u00e0 la barre (Back Squat)',
      primaryMuscles: ['Quadriceps', 'Grand fessier'],
      secondaryMuscles: [
        'Ischio-jambiers',
        'Adducteurs',
        '\u00c9recteurs du rachis',
        'Abdominaux',
      ],
      setupInstructions: [
        'Placez la barre sur les trap\u00e8zes sup\u00e9rieurs (High Bar) ou l\u00e9g\u00e8rement plus bas sur les delto\u00efdes post\u00e9rieurs (Low Bar).',
        'Reculez de 2 ou 3 pas calcul\u00e9s, pieds \u00e0 largeur d\'\u00e9paules, pointes ouvertes \u00e0 15-30\u00b0.',
        'Ancrez les pieds avec le \u00ab tr\u00e9pied \u00bb (gros orteil, petit orteil, talon).',
        'Prenez une grande inspiration intra-abdominale \u00e0 360 degr\u00e9s.',
      ],
      executionInstructions: [
        'Initiez le mouvement en fl\u00e9chissant simultan\u00e9ment les genoux et les hanches.',
        'Ouvrez les genoux dans l\'alignement strict des orteils.',
        'Descendez jusqu\'\u00e0 ce que le pli de la hanche passe sous le haut du genou (profondeur parall\u00e8le valid\u00e9e).',
        'Poussez le sol \u00e0 travers le milieu du pied en gardant la cage thoracique haute et le buste solide.',
      ],
      breathingInstructions:
          'Inspiration profonde et gainage abdominal 360\u00b0 avant d\'entamer la descente ; retenez l\'air jusqu\'au franchissement de la parall\u00e8le, puis expirez en haut.',
      commonMistakes: [
        'Genoux qui rentrent vers l\'int\u00e9rieur (valgus dynamique du genou).',
        'Talons qui d\u00e9collent du sol par manque de mobilit\u00e9 de cheville.',
        'Buste qui s\'effondre vers l\'avant (Good Morning squat involontaire).',
        'Arr\u00eat \u00e0 mi-hauteur sans amplitude compl\u00e8te.',
      ],
      coachTip:
          'Vissez vos pieds dans le sol vers l\'ext\u00e9rieur comme si vous vouliez fendre le plancher pour stabiliser vos hanches.',
      hypertrophyRepRange: '6 - 10 reps (RPE 7-8)',
      strengthRepRange: '3 - 5 reps (RPE 8-9)',
      tempo: '3-0-1-0',
    ),
    'deadlift': const ExerciseGuide(
      slug: 'deadlift',
      title: 'Soulev\u00e9 de terre conventionnel',
      primaryMuscles: [
        'Cha\u00eene post\u00e9rieure (Ischio-jambiers, Fessiers)',
        '\u00c9recteurs du rachis',
      ],
      secondaryMuscles: [
        'Dorsaux',
        'Trap\u00e8zes',
        'Avant-bras / Poigne',
        'Quadriceps',
      ],
      setupInstructions: [
        'Placez-vous pieds \u00e0 largeur de hanches, la barre coupant vos lacets en deux (2-3 cm des tibias).',
        'Penchez-vous en charni\u00e8re de hanche sans plier excessivement les genoux et saisissez la barre \u00e0 l\'ext\u00e9rieur des tibias.',
        'Amenez les tibias au contact de la barre sans la faire rouler.',
        'Sortez la poitrine, engagez vos dorsaux en \u00ab rangeant vos \u00e9paules dans les poches arri\u00e8re \u00bb pour retirer le jeu de la barre (slack).',
      ],
      executionInstructions: [
        'Poussez le sol comme sur une presse \u00e0 cuisses, la barre fr\u00f4lant vos tibias.',
        'D\u00e8s que la barre franchit les genoux, avancez vigoureusement les hanches pour verrouiller les fessiers.',
        'Finissez debout bien droit, sans hyper-extension lombaire arri\u00e8re.',
        'Contr\u00f4lez la descente en charni\u00e8re de hanche avant de plier les genoux.',
      ],
      breathingInstructions:
          'Prenez votre pression intra-abdominale maximale en bas au d\u00e9part ; maintenez le blocage jusqu\'au verrouillage debout o\u00f9 vous expirez bross\u00e9.',
      commonMistakes: [
        'Dos rond d\u00e8s le d\u00e9part (perte de neutralit\u00e9 de la colonne).',
        'Barre trop \u00e9loign\u00e9e du corps augmentant le bras de levier lombaire.',
        'Tirer avec les bras pli\u00e9s (risque de d\u00e9chirure du tendon du biceps).',
        'Sur-cambrer en arri\u00e8re au verrouillage final.',
      ],
      coachTip:
          'Ne tirez pas la barre vers le haut : repoussez le sol loin de vous avec les talons.',
      hypertrophyRepRange: '5 - 8 reps (RPE 7-8)',
      strengthRepRange: '1 - 5 reps (RPE 8-9)',
      tempo: '2-1-1-0',
    ),
    'overhead_press': const ExerciseGuide(
      slug: 'overhead_press',
      title: 'D\u00e9velopp\u00e9 militaire \u00e0 la barre (OHP)',
      primaryMuscles: [
        'Delto\u00efde ant\u00e9rieur',
        'Delto\u00efde lat\u00e9ral',
      ],
      secondaryMuscles: [
        'Triceps brachial',
        'Trap\u00e8zes sup\u00e9rieurs',
        'Serratus',
        'Abdominaux',
      ],
      setupInstructions: [
        'Barre pos\u00e9e sur le haut des clavicules, coudes l\u00e9g\u00e8rement en avant de la barre.',
        'Prise de mains juste \u00e0 l\'ext\u00e9rieur des \u00e9paules, poignets verticaux.',
        'Pieds stables largeur d\'\u00e9paules, fessiers et quadriceps contract\u00e9s \u00e0 fond.',
      ],
      executionInstructions: [
        'Inclinez tr\u00e8s l\u00e9g\u00e8rement la t\u00eate en arri\u00e8re pour laisser passer la trajectoire verticale de la barre.',
        'Poussez la barre en ligne strictement droite vers le haut.',
        'D\u00e8s que la barre d\u00e9passe le sommet du cr\u00e2ne, engagez la t\u00eate \u00e0 travers la \u00ab fen\u00eatre \u00bb des bras.',
        'Verrouillez les coudes au-dessus de la t\u00eate en haussant l\u00e9g\u00e8rement les trap\u00e8zes pour stabiliser.',
      ],
      breathingInstructions:
          'Inspirez au niveau des clavicules, bloquez pendant la mont\u00e9e, expirez en haut au verrouillage complet.',
      commonMistakes: [
        'Cambrer excessivement le bas du dos pour compenser un manque de mobilit\u00e9 d\'\u00e9paule.',
        'Pousser la barre en arc de cercle vers l\'avant.',
        'Utiliser un \u00e9lan de jambes (qui transforme l\'exercice en Push Press).',
      ],
      coachTip:
          'Serrez les fessiers aussi fort que possible : ils forment la fondation in\u00e9branlable de votre d\u00e9velopp\u00e9.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '3 - 6 reps (RPE 8-9)',
      tempo: '2-0-1-0',
    ),
    'barbell_row': const ExerciseGuide(
      slug: 'barbell_row',
      title: 'Rowing barre buste pench\u00e9',
      primaryMuscles: ['Grand dorsal', 'Rhombo\u00efdes', 'Trap\u00e8ze moyen'],
      secondaryMuscles: [
        'Biceps brachial',
        'Delto\u00efde post\u00e9rieur',
        '\u00c9recteurs lombaires',
      ],
      setupInstructions: [
        'Pieds largeur d\'\u00e9paules, d\u00e9crochez la barre en prise pronation ou supination.',
        'Basculez le buste en charni\u00e8re de hanche \u00e0 environ 45 degr\u00e9s, dos parfaitement droit.',
        'Laissez pendre les bras \u00e0 la verticale, omoplates rel\u00e2ch\u00e9es vers le bas.',
      ],
      executionInstructions: [
        'Tirez avec les coudes vers l\'arri\u00e8re et vers les poches (pas vers le haut).',
        'Amenez la barre au contact du bas des c\u00f4tes ou du nombril.',
        'Resserrez fermement les omoplates l\'une contre l\'autre en fin de course.',
        'Descendez lentement en contr\u00f4lant l\'\u00e9tirement dorsal complet.',
      ],
      breathingInstructions:
          'Inspirez en position basse \u00e9tir\u00e9e ; expirez \u00e0 mesure que vous tirez la charge contre vous.',
      commonMistakes: [
        'Redresser le buste avec des secousses pour tricher avec l\'\u00e9lan.',
        'Tirer avec les poignets et les biceps plut\u00f4t qu\'avec les coudes et le dos.',
        'Arrondir la colonne lombaire sous la fatigue.',
      ],
      coachTip:
          'Imaginez que vos mains ne sont que des crochets : le mouvement provient exclusivement de vos coudes guid\u00e9s vers l\'arri\u00e8re.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '5 - 8 reps (RPE 8-9)',
      tempo: '2-1-1-0',
    ),
    'pull_up': const ExerciseGuide(
      slug: 'pull_up',
      title: 'Tractions en pronation (Pull-Up)',
      primaryMuscles: ['Grand dorsal', 'Grand rond'],
      secondaryMuscles: [
        'Biceps brachial',
        'Brachioradial',
        'Rhombo\u00efdes',
        'Trap\u00e8zes',
      ],
      setupInstructions: [
        'Suspendez-vous \u00e0 la barre avec une prise l\u00e9g\u00e8rement plus large que les \u00e9paules, paumes vers l\'avant (pronation).',
        'D\u00e9marrez bras enti\u00e8rement tendus (dead hang) pour \u00e9tirer la fibre musculaire.',
        'Activez vos omoplates vers le bas avant de tirer (scapular pull-up).',
      ],
      executionInstructions: [
        'Tirez votre poitrine vers la barre en envoyant les coudes vers le bas et l\'arri\u00e8re.',
        'Montez jusqu\'\u00e0 ce que le menton d\u00e9passe nettement la barre.',
        'Marquez une seconde de contraction isom\u00e9trique en haut.',
        'Descendez avec retenue jusqu\'\u00e0 l\'extension compl\u00e8te des coudes.',
      ],
      breathingInstructions:
          'Inspirez en bas dans la phase d\'\u00e9tirement ; expirez puissamment pendant la mont\u00e9e.',
      commonMistakes: [
        'Balancement excessif des jambes (kipping) sans contr\u00f4le strict.',
        'Ne pas descendre jusqu\'au bout (r\u00e9p\u00e9titions partielles).',
        'Enrouler les \u00e9paules vers l\'avant en haut du mouvement.',
      ],
      coachTip:
          'Pensez \u00e0 enfoncer vos coudes dans le sol pour propulser votre torse vers le haut.',
      hypertrophyRepRange: '6 - 10 reps au poids du corps ou lest\u00e9',
      strengthRepRange: '3 - 5 reps lest\u00e9es',
      tempo: '3-0-1-0',
    ),
    'incline_dumbbell_press': const ExerciseGuide(
      slug: 'incline_dumbbell_press',
      title: 'D\u00e9velopp\u00e9 inclin\u00e9 aux halt\u00e8res',
      primaryMuscles: ['Haut du grand pectoral (faisceau claviculaire)'],
      secondaryMuscles: ['Delto\u00efde ant\u00e9rieur', 'Triceps brachial'],
      setupInstructions: [
        'R\u00e9glez le banc sur une inclinaison de 30 degr\u00e9s (au-del\u00e0 de 45\u00b0, les \u00e9paules prennent trop le relais).',
        'Posez les halt\u00e8res sur les genoux, puis propulsez-les un par un avec les cuisses en vous allongeant.',
        'Omoplates verrouill\u00e9es dans le dossier, pieds solidement ancr\u00e9s au sol.',
      ],
      executionInstructions: [
        'Descendez les halt\u00e8res de mani\u00e8re fluide et contr\u00f4l\u00e9e de chaque c\u00f4t\u00e9 de la poitrine haute.',
        'Orientez les halt\u00e8res avec un angle l\u00e9g\u00e8rement oblique (45\u00b0) pour pr\u00e9server les \u00e9paules.',
        'Sentez un \u00e9tirement net sur le haut des pectoraux, puis repoussez vers le haut sans cogner les halt\u00e8res.',
      ],
      breathingInstructions:
          'Inspirez profondément \u00e0 la descente pour ouvrir la cage thoracique ; expirez en poussant.',
      commonMistakes: [
        'Inclinaison du banc trop \u00e9lev\u00e9e (60\u00b0) qui sollicite les delto\u00efdes plut\u00f4t que les pectoraux.',
        'Claquer les halt\u00e8res en haut, ce qui supprime la tension musculaire.',
        'Perdre la stabilit\u00e9 scapulaire au cours de la s\u00e9rie.',
      ],
      coachTip:
          'Arr\u00eatez les halt\u00e8res \u00e0 5 cm l\'un de l\'autre en haut pour maintenir une tension constante sur le haut des pectoraux.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
    ),
    'lateral_raise': const ExerciseGuide(
      slug: 'lateral_raise',
      title: '\u00c9l\u00e9vations lat\u00e9rales aux halt\u00e8res',
      primaryMuscles: ['Delto\u00efde lat\u00e9ral (faisceau moyen)'],
      secondaryMuscles: ['Trap\u00e8ze sup\u00e9rieur', 'Supraspinatus'],
      setupInstructions: [
        'Debout ou assis, buste l\u00e9g\u00e8rement inclin\u00e9 vers l\'avant (5-10 degr\u00e9s).',
        'Halt\u00e8res tenus devant les cuisses, coudes tr\u00e8s l\u00e9g\u00e8rement fl\u00e9chis.',
        'Sangle abdominale contract\u00e9e, \u00e9paules d\u00e9tendues vers le bas.',
      ],
      executionInstructions: [
        'Levez les bras vers l\'ext\u00e9rieur et l\u00e9g\u00e8rement vers l\'avant (plan scapulaire, environ 30\u00b0).',
        'Guidez le mouvement avec les coudes (le coude doit rester \u00e0 la m\u00eame hauteur que la main).',
        'Montez jusqu\'\u00e0 la hauteur des \u00e9paules, pas plus haut pour ne pas engager les trap\u00e8zes.',
        'Freinez la descente sur 3 secondes compl\u00e8tes.',
      ],
      breathingInstructions:
          'Inspirez avant le d\u00e9marrage ; expirez en \u00e9levant les bras, inspirez en contr\u00f4lant la redescente.',
      commonMistakes: [
        'Utiliser l\'\u00e9lan du bassin ou des genoux pour balancer les poids.',
        'Prendre trop lourd et monter les mains au-dessus des coudes.',
        'Haisser excessivement les trap\u00e8zes sup\u00e9rieurs vers les oreilles.',
      ],
      coachTip:
          'Pensez \u00e0 pousser les murs de la pi\u00e8ce avec vos coudes plut\u00f4t que de simplement lever les halt\u00e8res.',
      hypertrophyRepRange: '12 - 18 reps (RPE 8-9)',
      strengthRepRange: '10 - 12 reps',
      tempo: '2-0-1-2',
    ),
    'romanian_deadlift': const ExerciseGuide(
      slug: 'romanian_deadlift',
      title: 'Soulev\u00e9 de terre roumain (RDL)',
      primaryMuscles: ['Ischio-jambiers', 'Grand fessier'],
      secondaryMuscles: ['\u00c9recteurs du rachis', 'Dorsaux', 'Avant-bras'],
      setupInstructions: [
        'D\u00e9marrez debout avec la barre tenue \u00e0 bout de bras \u00e0 mi-cuisse.',
        'Pieds largeur de hanches, genoux d\u00e9verrouill\u00e9s avec un angle de 15 degr\u00e9s qui reste fixe.',
        'Poitrine fi\u00e8re, omoplates serr\u00e9es, barre coll\u00e9e aux cuisses.',
      ],
      executionInstructions: [
        'Poussez vos hanches en arri\u00e8re vers le mur derri\u00e8re vous (charni\u00e8re pure).',
        'Faites glisser la barre le long des cuisses et des tibias sans \u00e9loigner le poids.',
        'Descendez jusqu\'\u00e0 sentir l\'\u00e9tirement maximal des ischio-jambiers (mi-tibia en g\u00e9n\u00e9ral).',
        'Pressez le sol avec les talons et contractez puissamment les fessiers pour revenir \u00e0 la verticale.',
      ],
      breathingInstructions:
          'Grande inspiration thoracique avant d\'envoyer le bassin en arri\u00e8re ; expirez \u00e0 mi-remont\u00e9e lors de l\'extension de hanche.',
      commonMistakes: [
        'Plier les genoux comme sur un squat conventionnel.',
        'Arrondir le dos pour chercher \u00e0 toucher le sol avec la barre.',
        'Laisser la barre d\u00e9coller des jambes vers l\'avant.',
      ],
      coachTip:
          'Le RDL n\'est pas un mouvement de flexion vers le bas, mais un mouvement d\'envoi des fesses vers l\'arri\u00e8re.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
    ),
    'leg_press': const ExerciseGuide(
      slug: 'leg_press',
      title: 'Presse \u00e0 cuisses 45\u00b0',
      primaryMuscles: ['Quadriceps', 'Grand fessier'],
      secondaryMuscles: ['Adducteurs', 'Ischio-jambiers'],
      setupInstructions: [
        'Asseyez-vous avec le bas du dos et le sacrum coll\u00e9s en continu contre le dossier.',
        'Placez vos pieds \u00e0 largeur d\'\u00e9paules au centre du plateau.',
        'D\u00e9verrouillez les leviers de s\u00e9curit\u00e9 en gardant les genoux l\u00e9g\u00e8rement fl\u00e9chis.',
      ],
      executionInstructions: [
        'Descendez le plateau avec contr\u00f4le jusqu\'\u00e0 un angle de genou d\'au moins 90 degr\u00e9s.',
        'Gardez les genoux ouverts dans l\'axe de vos orteils.',
        'Stoppez la descente imm\u00e9diatement si votre bas du dos commence \u00e0 se d\u00e9coller du dossier.',
        'Repoussez le plateau \u00e0 travers l\'ensemble du pied sans jamais verrouiller les genoux en hyperextension.',
      ],
      breathingInstructions:
          'Inspirez \u00e0 la descente du plateau ; expirez pendant la pouss\u00e9e puissante.',
      commonMistakes: [
        'Verrouiller brutalement les articulations des genoux en haut (risque articulaire majeur).',
        'D\u00e9coller le bassin du si\u00e8ge (r\u00e9troversion du bassin destructrice pour les lombaires).',
        'Mettre les mains sur les genoux pour pousser.',
      ],
      coachTip:
          'Agrippez fermement les poign\u00e9es lat\u00e9rales pour vous plaquer activement dans le si\u00e8ge tout au long de la s\u00e9rie.',
      hypertrophyRepRange: '10 - 15 reps (RPE 8)',
      strengthRepRange: '6 - 10 reps',
      tempo: '3-0-1-0',
    ),
    'lat_pulldown': const ExerciseGuide(
      slug: 'lat_pulldown',
      title: 'Tirage vertical \u00e0 la poulie',
      primaryMuscles: ['Grand dorsal'],
      secondaryMuscles: ['Grand rond', 'Biceps brachial', 'Brachioradial'],
      setupInstructions: [
        'R\u00e9glez les boudins pour caler fermement le haut de vos cuisses.',
        'Saisissez la barre avec une prise pronation un peu plus large que les \u00e9paules.',
        'Inclinez le buste de 10 \u00e0 15 degr\u00e9s vers l\'arri\u00e8re en fixant la sangle abdominale.',
      ],
      executionInstructions: [
        'Initiez le tirage en abaissant vos omoplates.',
        'Conduisez la barre vers le haut de votre poitrine en tirant les coudes vers le bas et les c\u00f4tes.',
        'Effleurez la zone claviculaire, marquez 1 seconde de contraction maximale.',
        'Remontez en r\u00e9sistant jusqu\'\u00e0 l\'extension compl\u00e8te des bras.',
      ],
      breathingInstructions:
          'Inspirez lorsque la barre remonte en \u00e9tirant vos dorsaux ; expirez en tirant vers la poitrine.',
      commonMistakes: [
        'Se balancer excessivement en arri\u00e8re pour utiliser le poids du corps.',
        'Tirer la barre derri\u00e8re le cou (dangereux pour la coiffe des rotateurs).',
        'Remonter la barre \u00e0 toute vitesse sans contr\u00f4le.',
      ],
      coachTip:
          'Pensez \u00e0 rentrer vos coudes dans vos poches arri\u00e8re de pantalon pour engager pleinement le grand dorsal.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
    ),
    'barbell_curl': const ExerciseGuide(
      slug: 'barbell_curl',
      title: 'Curl biceps \u00e0 la barre',
      primaryMuscles: ['Biceps brachial (court et long chef)'],
      secondaryMuscles: ['Brachial ant\u00e9rieur', 'Brachioradial'],
      setupInstructions: [
        'Tenez la barre avec une prise supination (paumes vers le haut) largeur d\'\u00e9paules.',
        'Pieds stables, \u00e9paules basses et en arri\u00e8re, coudes coll\u00e9s aux flancs.',
      ],
      executionInstructions: [
        'Fl\u00e9chissez les bras en contractant les biceps pour monter la barre vers les \u00e9paules.',
        'Gardez les coudes strictement immobiles le long du torse.',
        'Pressez au sommet de la contraction pendant 1 seconde.',
        'Redescendez lentement jusqu\'\u00e0 extension compl\u00e8te.',
      ],
      breathingInstructions:
          'Inspirez \u00e0 la descente de la barre ; expirez en contractant les biceps vers le haut.',
      commonMistakes: [
        'Donner une impulsion avec les lombaires et le bassin.',
        'Avancer les coudes vers l\'avant, ce qui transf\u00e8re l\'effort sur les delto\u00efdes.',
      ],
      coachTip:
          'Collez vos \u00e9paules et vos fessiers contre un mur pour vous entra\u00eener avec une forme 100% stricte.',
      hypertrophyRepRange: '8 - 12 reps (RPE 8)',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
    ),
    'triceps_pushdown': const ExerciseGuide(
      slug: 'triceps_pushdown',
      title: 'Extension triceps \u00e0 la poulie haute',
      primaryMuscles: ['Triceps brachial (chef lat\u00e9ral et m\u00e9dial)'],
      secondaryMuscles: ['Triceps brachial (chef long)', 'Avant-bras'],
      setupInstructions: [
        'Fixez une barre droite ou une corde sur la poulie haute.',
        'Penchez l\u00e9g\u00e8rement le buste vers l\'avant et ancrez vos coudes le long de vos c\u00f4tes.',
      ],
      executionInstructions: [
        'D\u00e9pliez compl\u00e8tement les avant-bras vers le bas par une extension de coude pure.',
        'Verrouillez l\'articulation en bas en \u00e9cartant l\u00e9g\u00e8rement la corde ou en pressant la barre.',
        'Remontez avec contr\u00f4le jusqu\'\u00e0 un angle de 90\u00b0 aux coudes sans les d\u00e9coller du buste.',
      ],
      breathingInstructions:
          'Inspirez pendant que la barre remonte ; expirez vigoureusement en poussant vers le bas.',
      commonMistakes: [
        'Laisser les coudes monter et descendre au lieu de les garder fixes.',
        'Utiliser le poids de son buste pour \u00e9craser la poulie.',
      ],
      coachTip:
          'Imaginez que vos coudes sont viss\u00e9s dans vos hanches : seuls vos avant-bras doivent pivoter.',
      hypertrophyRepRange: '10 - 15 reps (RPE 8)',
      strengthRepRange: '8 - 10 reps',
      tempo: '2-1-1-0',
    ),
    'push_up': const ExerciseGuide(
      slug: 'push_up',
      title: 'Pompes classiques',
      primaryMuscles: ['Pectoraux', 'Triceps'],
      secondaryMuscles: [
        'Delto\u00efde ant\u00e9rieur',
        'Sangle abdominale (gainage)',
      ],
      setupInstructions: [
        'Mains pos\u00e9es au sol l\u00e9g\u00e8rement plus larges que les \u00e9paules.',
        'Corps align\u00e9 en planche parfaite de la nuque aux chevilles.',
      ],
      executionInstructions: [
        'Descendez le torse vers le sol en maintenant les coudes \u00e0 45 degr\u00e9s du corps.',
        'Effleurez le sol avec la poitrine sans cambrer.',
        'Repoussez fermement le sol pour revenir en extension compl\u00e8te.',
      ],
      breathingInstructions:
          'Inspirez \u00e0 la descente ; expirez en repoussant le sol.',
      commonMistakes: [
        'Bassin qui s\'affaisse vers le sol (manque de gainage).',
        '\u00c9carter les coudes \u00e0 90 degr\u00e9s fa\u00e7on T.',
      ],
      coachTip:
          'Serrez les fessiers et les abdominaux pour transformer votre corps en planche d\'acier.',
      hypertrophyRepRange: '12 - 25 reps (au poids du corps)',
      strengthRepRange: 'Lest\u00e9 8 - 12 reps',
      tempo: '2-0-1-0',
    ),
    'plank': const ExerciseGuide(
      slug: 'plank',
      title: 'Gainage ventral (Planche)',
      primaryMuscles: ['Grand droit de l\'abdomen', 'Transverse'],
      secondaryMuscles: ['Obliques', 'Fessiers', 'Quadriceps'],
      setupInstructions: [
        'En appui sur les avant-bras et la pointe des pieds.',
        'Coudes plac\u00e9s directement sous les \u00e9paules.',
      ],
      executionInstructions: [
        'Basculez l\u00e9g\u00e8rement le bassin en r\u00e9troversion pour effacer la cambrure lombaire.',
        'Contractez activement les abdominaux et les fessiers comme pour recevoir un coup.',
        'Maintenez la position sans bouger en respirant r\u00e9guli\u00e8rement.',
      ],
      breathingInstructions:
          'Respiration diaphragmatique r\u00e9guli\u00e8re et fluide sans rel\u00e2cher la sangle.',
      commonMistakes: [
        'Hanches trop hautes ou au contraire dos qui creuse vers le sol.',
        'Bloquer sa respiration en apn\u00e9e.',
      ],
      coachTip:
          'Tirez vos coudes vers vos pieds sans bouger pour multiplier par trois la tension sur vos abdominaux.',
      hypertrophyRepRange: '3 s\u00e9ries de 45 \u00e0 90 secondes',
      strengthRepRange: 'Lest\u00e9 3 s\u00e9ries de 30 \u00e0 45 s',
      tempo: 'Statique',
    ),
    'hanging_leg_raise': const ExerciseGuide(
      slug: 'hanging_leg_raise',
      title: 'Relev\u00e9 de jambes suspendu',
      primaryMuscles: ['Bas des abdominaux', 'Fl\u00e9chisseurs de hanche'],
      secondaryMuscles: ['Avant-bras / Poigne', 'Grand dorsal'],
      setupInstructions: [
        'Suspendez-vous \u00e0 une barre fixe avec les bras tendus.',
        'Stabilisez le balancement avant d\'amorcer la r\u00e9p\u00e9tition.',
      ],
      executionInstructions: [
        'Initiez le mouvement en enroulant le bassin vers le haut et l\'avant.',
        'Levez les jambes (ou les genoux fl\u00e9chis) jusqu\'\u00e0 l\'horizontale au minimum.',
        'Marquez 1 seconde de contraction en haut.',
        'Redescendez sans \u00e0-coup sans vous servir de l\'\u00e9lan de balancement.',
      ],
      breathingInstructions:
          'Expirez en enroulant le bassin vers le haut ; inspirez \u00e0 la redescente contr\u00f4l\u00e9e.',
      commonMistakes: [
        'Se balancer d\'avant en arri\u00e8re pour utiliser l\'inertie.',
        'Lever les jambes uniquement avec les fl\u00e9chisseurs sans enrouler le bassin.',
      ],
      coachTip:
          'Ce n\'est pas lever les pieds qui muscle les abdos, c\'est amener le bassin vers votre nombril.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '12 - 20 reps',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/hanging_leg_raise.svg',
    ),
    'dips': const ExerciseGuide(
      slug: 'dips',
      title: 'Dips aux barres parallèles',
      primaryMuscles: [
        'Grand pectoral (faisceau inférieur)',
        'Triceps brachial',
      ],
      secondaryMuscles: ['Deltoïde antérieur'],
      setupInstructions: [
        'Saisissez les barres parallèles en prise neutre, bras tendus et épaules basses.',
        'Inclinez légèrement le buste vers l\'avant (20-30°) pour cibler davantage les pectoraux, ou restez droit pour les triceps.',
      ],
      executionInstructions: [
        'Fléchissez les coudes avec contrôle jusqu\'à ce que vos épaules arrivent à hauteur des coudes (90°).',
        'Repoussez vigoureusement les poignées jusqu\'à l\'extension complète sans hausser les épaules.',
      ],
      breathingInstructions:
          'Inspirez pendant la descente ; expirez en poussant vers le haut.',
      commonMistakes: [
        'Descendre trop bas au-delà de sa mobilité scapulaire.',
        'Hausser les épaules vers les oreilles en bas du mouvement.',
      ],
      coachTip:
          'Maintenez les omoplates abaissées tout au long de la série pour protéger l\'articulation gléno-humérale.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '5 - 8 reps lestées',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dips.svg',
    ),
    'cable_fly': const ExerciseGuide(
      slug: 'cable_fly',
      title: 'Écartés à la poulie vis-à-vis',
      primaryMuscles: ['Grand pectoral (fibres sternales et internes)'],
      secondaryMuscles: ['Deltoïde antérieur', 'Biceps (stabilisation)'],
      setupInstructions: [
        'Réglez les deux poulies à hauteur d\'épaules ou légèrement au-dessus.',
        'Avancez d\'un pas pour créer une pré-tension, coudes légèrement fléchis.',
      ],
      executionInstructions: [
        'Ramenez les poignées l\'une vers l\'autre en dessinant un grand arc de cercle (comme pour enlacer un arbre).',
        'Contractez fortement les pectoraux pendant 1 seconde les mains jointes.',
        'Ouvrez les bras lentement jusqu\'à l\'étirement complet sans laisser partir les épaules.',
      ],
      breathingInstructions:
          'Inspirez à l\'ouverture thoracique ; expirez en resserrant les poignées.',
      commonMistakes: [
        'Transformer l\'écarté en développé en pliant trop les coudes.',
      ],
      coachTip:
          'Cherchez à faire se toucher l\'intérieur de vos coudes plutôt que vos mains pour maximiser la contraction pectorale.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '10 - 12 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/cable_fly.svg',
    ),
    'chin_up': const ExerciseGuide(
      slug: 'chin_up',
      title: 'Tractions en supination (Chin-Up)',
      primaryMuscles: ['Grand dorsal', 'Biceps brachial'],
      secondaryMuscles: ['Grand rond', 'Rhomboïdes', 'Sangle abdominale'],
      setupInstructions: [
        'Suspendez-vous à la barre fixe avec les paumes tournées vers vous (prise supination) à largeur d\'épaules.',
      ],
      executionInstructions: [
        'Abaissez les omoplates puis tirez votre poitrine vers la barre en gardant les coudes proches du corps.',
        'Passez le menton au-dessus de la barre, puis redescendez lentement jusqu\'à l\'extension complète.',
      ],
      breathingInstructions: 'Inspirez en bas ; expirez pendant la traction.',
      commonMistakes: [
        'Arrêter la descente à mi-chemin sans tendre les bras.',
        'Donner des coups de genoux pour monter.',
      ],
      coachTip:
          'Les tractions supination placent le biceps dans sa ligne de force idéale tout en étirant puissamment le grand dorsal.',
      hypertrophyRepRange: '6 - 12 reps',
      strengthRepRange: '3 - 6 reps lestées',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/chin_up.svg',
    ),
    'dumbbell_row': const ExerciseGuide(
      slug: 'dumbbell_row',
      title: 'Rowing haltère à un bras (Bûcheron)',
      primaryMuscles: ['Grand dorsal', 'Rhomboïdes'],
      secondaryMuscles: ['Trapèze moyen', 'Deltoïde postérieur', 'Biceps'],
      setupInstructions: [
        'Prenez appui avec une main et un genou sur un banc plat, ou la main sur le rack.',
        'Dos plat parallèle au sol, l\'haltère pendant à la verticale.',
      ],
      executionInstructions: [
        'Tirez l\'haltère en trajectoire courbe vers votre hanche (et non vers l\'épaule).',
        'Marquez un temps d\'arrêt en haut, puis étirez l\'omoplate vers le sol à la descente.',
      ],
      breathingInstructions:
          'Inspirez à l\'étirement bas ; expirez en tirant vers la hanche.',
      commonMistakes: [
        'Tourner excessivement le buste à chaque répétition.',
        'Tirer vers l\'aisselle avec le biceps.',
      ],
      coachTip:
          'Sciez vers l\'arrière en visant votre poche de pantalon avec votre coude.',
      hypertrophyRepRange: '8 - 12 reps par bras',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_row.svg',
    ),
    'seated_cable_row': const ExerciseGuide(
      slug: 'seated_cable_row',
      title: 'Tirage horizontal à la poulie basse',
      primaryMuscles: ['Milieu du dos (Rhomboïdes, Trapèzes)', 'Grand dorsal'],
      secondaryMuscles: ['Biceps', 'Érecteurs du rachis'],
      setupInstructions: [
        'Asseyez-vous pieds calés sur les cale-pieds, genoux légèrement fléchis.',
        'Buste droit, poitrine sortie, bras tendus devant vous.',
      ],
      executionInstructions: [
        'Tirez la poignée vers le bas du sternum / nombril en resserrant les omoplates.',
        'Maintenez la contraction 1 seconde sans basculer le buste en arrière.',
        'Accompagnez le retour de la charge avec contrôle.',
      ],
      breathingInstructions:
          'Inspirez bras tendus ; expirez en tirant la poignée au nombril.',
      commonMistakes: [
        'Faire du rameur avec le bas du dos d\'avant en arrière.',
      ],
      coachTip:
          'Initiez chaque répétition par le recul des épaules avant même de plier les coudes.',
      hypertrophyRepRange: '10 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/seated_cable_row.svg',
    ),
    'lunges': const ExerciseGuide(
      slug: 'lunges',
      title: 'Fentes aux haltères',
      primaryMuscles: ['Quadriceps', 'Grand fessier'],
      secondaryMuscles: [
        'Ischio-jambiers',
        'Moyen fessier (stabilisation)',
        'Mollets',
      ],
      setupInstructions: [
        'Debout, un haltère dans chaque main le long du corps.',
        'Regard fixe devant vous, sangle abdominale engagée.',
      ],
      executionInstructions: [
        'Faites un pas contrôlé vers l\'avant et fléchissez les deux genoux à 90 degrés.',
        'Le genou arrière frôle le sol sans rebondir.',
        'Poussez fort dans le talon du pied avant pour revenir ou enchaîner le pas suivant.',
      ],
      breathingInstructions:
          'Inspirez lors de la flexion ; expirez en poussant sur la jambe avant.',
      commonMistakes: [
        'Aligner les deux pieds sur un fil (perte d\'équilibre) au lieu de garder la largeur du bassin.',
        'Laisser le genou avant rentrer vers l\'intérieur.',
      ],
      coachTip:
          'Un pas plus court cible davantage les quadriceps ; un pas plus long et buste légèrement penché recrute plus les fessiers.',
      hypertrophyRepRange: '10 - 12 reps par jambe',
      strengthRepRange: '6 - 8 reps par jambe',
      tempo: '2-0-1-0',
      assetIllustrationPath: 'assets/illustrations/lunges.svg',
    ),
    'hip_thrust': const ExerciseGuide(
      slug: 'hip_thrust',
      title: 'Hip Thrust à la barre',
      primaryMuscles: ['Grand fessier'],
      secondaryMuscles: ['Ischio-jambiers', 'Quadriceps', 'Abdominaux'],
      setupInstructions: [
        'Adossez le bas de vos omoplates contre un banc stable, barre avec mousse placée au pli des hanches.',
        'Pieds à plat largeur d\'épaules, tibias strictement verticaux en position haute.',
      ],
      executionInstructions: [
        'Poussez dans les talons pour monter le bassin jusqu\'à l\'alignement genoux-hanches-épaules.',
        'Gardez le menton rentré vers le sternum et basculez le bassin en rétroversion en haut.',
        'Contractez les fessiers 1 à 2 secondes, puis redescendez sous contrôle.',
      ],
      breathingInstructions:
          'Inspirez en bas ; expirez et verrouillez les fessiers en haut.',
      commonMistakes: [
        'Cambrer les lombaires en jetant la tête en arrière.',
        'Pieds trop proches ou trop loin (les tibias doivent être à 90° en haut).',
      ],
      coachTip:
          'Gardez le regard fixé droit devant vous tout au long du mouvement pour neutraliser la colonne lombaire.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '5 - 8 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/hip_thrust.svg',
    ),
    'bulgarian_split_squat': const ExerciseGuide(
      slug: 'bulgarian_split_squat',
      title: 'Squat bulgare aux haltères',
      primaryMuscles: ['Quadriceps', 'Grand fessier'],
      secondaryMuscles: ['Moyen fessier', 'Adducteurs', 'Ischio-jambiers'],
      setupInstructions: [
        'Posez le coup de pied arrière sur un banc ou un rouleau, pied avant avancé d\'environ deux pas.',
        'Tenez deux haltères ou un seul côté opposé pour l\'équilibre.',
      ],
      executionInstructions: [
        'Descendez verticalement sur la jambe avant jusqu\'à l\'étirement profond de la hanche.',
        '80 à 90% du poids doit reposer sur la jambe avant.',
        'Repoussez le sol avec le pied avant sans vous aider de la jambe arrière.',
      ],
      breathingInstructions: 'Inspirez à la descente ; expirez à la remontée.',
      commonMistakes: ['Pousser avec le pied arrière posé sur le banc.'],
      coachTip:
          'Asseyez-vous au bord du banc jambes tendues devant vous : là où arrivent vos talons est la distance exacte de votre pied avant.',
      hypertrophyRepRange: '8 - 12 reps par jambe',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/bulgarian_split_squat.svg',
    ),
    'leg_extension': const ExerciseGuide(
      slug: 'leg_extension',
      title: 'Leg Extension à la machine',
      primaryMuscles: ['Quadriceps (Droit fémoral, Vastes)'],
      secondaryMuscles: [],
      setupInstructions: [
        'Alignez l\'axe de rotation de la machine exactement avec l\'articulation de vos genoux.',
        'Boudin posé sur le bas des tibias, fessiers plaqués au fond du siège.',
      ],
      executionInstructions: [
        'Tendez les jambes jusqu\'à la contraction complète des quadriceps.',
        'Maintenez 1 seconde d\'isométrie en haut en tirant les poignées.',
        'Redescendez lentement sans laisser retomber les plaques.',
      ],
      breathingInstructions:
          'Expirez lors de l\'extension ; inspirez à la flexion contrôlée.',
      commonMistakes: [
        'Décoller les fesses du siège en donnant des coups de reins.',
      ],
      coachTip:
          'Pointez les orteils vers le haut (dorsiflexion) pour maximiser la contraction du droit fémoral.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_extension.svg',
    ),
    'leg_curl': const ExerciseGuide(
      slug: 'leg_curl',
      title: 'Leg Curl ischio-jambiers',
      primaryMuscles: ['Ischio-jambiers'],
      secondaryMuscles: ['Gastrocnémiens (Mollets)'],
      setupInstructions: [
        'Ajustez le coussin juste au-dessus des tendons d\'Achille, genoux alignés sur le pivot.',
      ],
      executionInstructions: [
        'Fléchissez les genoux en ramenant les talons le plus près possible des fessiers.',
        'Contractez fort 1 seconde, puis retenez la phase excentrique sur 3 secondes.',
      ],
      breathingInstructions:
          'Expirez en pliant les jambes ; inspirez en les tendant.',
      commonMistakes: ['Soulever le bassin pour tricher avec le bas du dos.'],
      coachTip:
          'Le leg curl assis étire davantage les ischio-jambiers à la hanche et favorise une hypertrophie supérieure.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '6 - 10 reps',
      tempo: '3-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_curl.svg',
    ),
    'calf_raise': const ExerciseGuide(
      slug: 'calf_raise',
      title: 'Mollets debout (Standing Calf Raise)',
      primaryMuscles: ['Gastrocnémiens (Jumeaux)'],
      secondaryMuscles: ['Soléaire'],
      setupInstructions: [
        'Placez l\'avant des pieds sur la cale, talons dans le vide, genoux tendus (sans hyperextension).',
      ],
      executionInstructions: [
        'Descendez les talons au maximum et marquez 2 secondes d\'étirement en bas.',
        'Montez tout en haut sur la pointe des gros orteils et contractez 1 seconde.',
      ],
      breathingInstructions:
          'Inspirez à l\'étirement ; expirez en montant sur les pointes.',
      commonMistakes: [
        'Faire de petits rebonds rapides en utilisant l\'élasticité du tendon d\'Achille.',
      ],
      coachTip:
          'La pause de 2 secondes en bas annule le réflexe élastique du tendon et force le muscle du mollet à travailler.',
      hypertrophyRepRange: '12 - 20 reps',
      strengthRepRange: '8 - 12 reps',
      tempo: '2-2-1-1',
      assetIllustrationPath: 'assets/illustrations/calf_raise.svg',
    ),
    'dumbbell_shoulder_press': const ExerciseGuide(
      slug: 'dumbbell_shoulder_press',
      title: 'Développé épaules assis aux haltères',
      primaryMuscles: ['Deltoïde antérieur', 'Deltoïde latéral'],
      secondaryMuscles: ['Triceps brachial', 'Trapèzes supérieurs'],
      setupInstructions: [
        'Banc réglé à 75-80 degrés pour soutenir le dos tout en préservant l\'espace sous-acromial.',
        'Coudes avancés de 30 degrés dans le plan scapulaire.',
      ],
      executionInstructions: [
        'Poussez les haltères vers le haut jusqu\'à l\'extension des bras sans les entrechoquer.',
        'Descendez avec contrôle jusqu\'à ce que les haltères arrivent au niveau des oreilles / menton.',
      ],
      breathingInstructions:
          'Inspirez à la descente ; expirez pendant la poussée.',
      commonMistakes: ['Ouvrir les coudes à 90° complètement sur les côtés.'],
      coachTip:
          'Une légère inclinaison du dossier à 75° est beaucoup plus naturelle pour les épaules qu\'un dossier à 90° strict.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_shoulder_press.svg',
    ),
    'face_pull': const ExerciseGuide(
      slug: 'face_pull',
      title: 'Face Pull à la corde (Poulie haute)',
      primaryMuscles: [
        'Deltoïde postérieur',
        'Coiffe des rotateurs (Infra-épineux)',
      ],
      secondaryMuscles: ['Trapèzes moyens et inférieurs', 'Rhomboïdes'],
      setupInstructions: [
        'Réglez la poulie à hauteur du visage avec une corde, saisissez les extrémités pouces vers l\'arrière.',
      ],
      executionInstructions: [
        'Tirez le centre de la corde vers votre front / yeux en écartant les mains.',
        'Terminez en posture de double biceps de dos (rotation externe d\'épaule complète).',
      ],
      breathingInstructions:
          'Expirez en tirant vers le visage ; inspirez au retour.',
      commonMistakes: [
        'Mettre trop lourd et tirer vers le menton ou le torse.',
      ],
      coachTip:
          'Vos poignets doivent finir plus en arrière que vos coudes pour engager la rotation externe.',
      hypertrophyRepRange: '15 - 20 reps',
      strengthRepRange: '12 - 15 reps',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/face_pull.svg',
    ),
    'hammer_curl': const ExerciseGuide(
      slug: 'hammer_curl',
      title: 'Curl marteau aux haltères (Hammer Curl)',
      primaryMuscles: ['Brachioradial', 'Brachial antérieur'],
      secondaryMuscles: ['Biceps brachial (chef long)'],
      setupInstructions: [
        'Debout ou assis, haltères tenus en prise neutre (paumes face à face comme un marteau).',
      ],
      executionInstructions: [
        'Fléchissez les coudes en gardant la prise neutre du début à la fin.',
        'Contrôlez la descente sur 2 à 3 secondes sans balancer le buste.',
      ],
      breathingInstructions: 'Expirez à la montée ; inspirez à la descente.',
      commonMistakes: [
        'Balancer les épaules pour monter des charges trop lourdes.',
      ],
      coachTip:
          'Indispensable pour donner de l\'épaisseur au bras vu de face et renforcer les avant-bras.',
      hypertrophyRepRange: '10 - 14 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/hammer_curl.svg',
    ),
    'incline_dumbbell_curl': const ExerciseGuide(
      slug: 'incline_dumbbell_curl',
      title: 'Curl biceps incliné aux haltères',
      primaryMuscles: ['Biceps brachial (chef long)'],
      secondaryMuscles: ['Brachial antérieur'],
      setupInstructions: [
        'Allongez-vous sur un banc incliné à 45-60 degrés, bras pendant verticalement derrière la ligne du buste.',
      ],
      executionInstructions: [
        'Fléchissez les avant-bras en gardant les coudes fixes pointés vers le sol.',
        'Ressentez l\'étirement intense du chef long en position basse.',
      ],
      breathingInstructions:
          'Inspirez en bas ; expirez en montant les haltères.',
      commonMistakes: [
        'Avancer les coudes pendant la montée, ce qui annule la tension d\'étirement.',
      ],
      coachTip:
          'L\'hypertrophie en position étirée du curl incliné est l\'une des plus efficaces pour le pic du biceps.',
      hypertrophyRepRange: '10 - 12 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/incline_dumbbell_curl.svg',
    ),
    'overhead_triceps_extension': const ExerciseGuide(
      slug: 'overhead_triceps_extension',
      title: 'Extension triceps poulie au-dessus de la tête',
      primaryMuscles: ['Triceps brachial (chef long)'],
      secondaryMuscles: ['Chefs latéral et médial du triceps'],
      setupInstructions: [
        'Dos à la poulie, buste incliné à 45°, coudes levés près des oreilles.',
      ],
      executionInstructions: [
        'Laissez la corde étirer vos triceps derrière la nuque.',
        'Tendez complètement les bras vers l\'avant et le haut sans bouger les coudes.',
      ],
      breathingInstructions:
          'Inspirez à la flexion derrière la tête ; expirez à l\'extension.',
      commonMistakes: [
        'Cambrer excessivement le dos au lieu de gainer les abdos.',
      ],
      coachTip:
          'Le chef long du triceps ne s\'étire complètement que lorsque le bras est levé au-dessus de l\'épaule.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath:
          'assets/illustrations/overhead_triceps_extension.svg',
    ),
    'skull_crusher': const ExerciseGuide(
      slug: 'skull_crusher',
      title: 'Barre au front (EZ-Bar Skull Crusher)',
      primaryMuscles: ['Triceps brachial (3 chefs)'],
      secondaryMuscles: ['Avant-bras'],
      setupInstructions: [
        'Allongé sur un banc plat, tenez la barre EZ bras tendus légèrement inclinés vers l\'arrière de la tête.',
      ],
      executionInstructions: [
        'Pliez uniquement les coudes pour descendre la barre vers le front ou juste derrière le crâne.',
        'Gardez les coudes resserrés et poussez pour revenir en position haute.',
      ],
      breathingInstructions: 'Inspirez à la descente ; expirez à l\'extension.',
      commonMistakes: ['Écarter les coudes vers l\'extérieur.'],
      coachTip:
          'Descendre la barre légèrement derrière le sommet du crâne maintient une tension continue et soulage les coudes.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/skull_crusher.svg',
    ),
    'cable_crunch': const ExerciseGuide(
      slug: 'cable_crunch',
      title: 'Crunch abdominal à la poulie haute',
      primaryMuscles: ['Grand droit de l\'abdomen'],
      secondaryMuscles: ['Obliques'],
      setupInstructions: [
        'À genoux face ou dos à la poulie haute, tenez la corde de chaque côté de la tête.',
      ],
      executionInstructions: [
        'Enroulez la colonne vertébrale en amenant le sternum vers le bassin (sans asseoir les fesses sur les talons).',
        'Expirez tout l\'air en bas et remontez vertèbre par vertèbre.',
      ],
      breathingInstructions:
          'Inspirez en haut ; expirez complètement en enroulant le buste.',
      commonMistakes: [
        'Plier les hanches avec le dos plat au lieu d\'enrouler la colonne.',
      ],
      coachTip:
          'Gardez les hanches fixes dans l\'espace : seule votre cage thoracique doit s\'enrouler vers votre nombril.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '8 - 12 reps',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/cable_crunch.svg',
    ),
  };

  // ---------------------------------------------------------------------------
  // ENGLISH GUIDES
  // ---------------------------------------------------------------------------
  static final Map<String, ExerciseGuide> _englishGuides = {
    'bench_press': const ExerciseGuide(
      slug: 'bench_press',
      title: 'Barbell Bench Press',
      primaryMuscles: ['Pectoralis Major (Mid & Lower)'],
      secondaryMuscles: [
        'Triceps Brachii',
        'Anterior Deltoid',
        'Serratus Anterior',
      ],
      setupInstructions: [
        'Lie on the bench with eyes directly under the racked barbell.',
        'Plant feet firmly flat on the floor to engage leg drive.',
        'Retract and depress scapulae into the pad, creating a stable arch in your upper back.',
        'Grip slightly wider than shoulder-width so forearms remain vertical at the bottom.',
      ],
      executionInstructions: [
        'Unrack and hold the bar steady directly over your shoulders.',
        'Lower under strict control in a slight diagonal arc toward your mid-sternum.',
        'Tuck elbows at a 45\u00b0 to 70\u00b0 angle relative to your torso (avoid 90\u00b0 flaring).',
        'Touch the chest lightly, then press forcefully back up and slightly back over the shoulders.',
      ],
      breathingInstructions:
          'Deep belly breath and Valsalva brace before descent; exhale as you pass the sticking point near lockout.',
      commonMistakes: [
        'Flaring elbows out to 90 degrees, stressing rotator cuffs.',
        'Bouncing the bar violently off the sternum.',
        'Lifting hips and glutes off the bench during the push.',
      ],
      coachTip:
          'Try to "bend the bar" in half with your hands to ignite lat stability and lock the elbows in place.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '3 - 6 reps (RPE 8-9)',
      tempo: '3-1-1-0',
    ),
    'squat': const ExerciseGuide(
      slug: 'squat',
      title: 'Barbell Back Squat',
      primaryMuscles: ['Quadriceps', 'Gluteus Maximus'],
      secondaryMuscles: ['Hamstrings', 'Adductors', 'Erector Spinae', 'Core'],
      setupInstructions: [
        'Rest bar across upper traps (High Bar) or rear delts (Low Bar).',
        'Step back 2-3 controlled paces, feet shoulder-width apart, toes flared 15-30\u00b0.',
        'Grip the floor with a 3-point foot tripod (big toe, pinky toe, heel).',
        'Take a full 360-degree intra-abdominal breath and brace hard.',
      ],
      executionInstructions: [
        'Break at knees and hips simultaneously under full control.',
        'Track knees directly over the line of your toes.',
        'Descend until the hip crease breaks parallel with the top of the knees.',
        'Drive through mid-foot with a proud chest to return to standing.',
      ],
      breathingInstructions:
          'Inhale deep into your gut and brace before descending; hold pressure through the hole and exhale past the sticking point.',
      commonMistakes: [
        'Knees caving inward (dynamic valgus collapse).',
        'Heels lifting off the floor due to tight ankles.',
        'Rounding lower back into a "butt wink" at the bottom.',
      ],
      coachTip:
          'Screw your feet outward into the floor to open up the hips and generate instant torque.',
      hypertrophyRepRange: '6 - 10 reps (RPE 7-8)',
      strengthRepRange: '3 - 5 reps (RPE 8-9)',
      tempo: '3-0-1-0',
    ),
    'deadlift': const ExerciseGuide(
      slug: 'deadlift',
      title: 'Barbell Deadlift (Conventional)',
      primaryMuscles: [
        'Posterior Chain (Glutes, Hamstrings)',
        'Erector Spinae',
      ],
      secondaryMuscles: ['Lats', 'Trapezius', 'Forearms / Grip', 'Quadriceps'],
      setupInstructions: [
        'Stand with feet hip-width apart, bar cutting directly over mid-foot (1 inch from shins).',
        'Hinge at the hips and grip the bar just outside your legs.',
        'Bring shins forward to touch the bar without moving it.',
        'Pull chest up and pull the "slack" out of the barbell until it clicks.',
      ],
      executionInstructions: [
        'Push the floor away through your heels like a leg press.',
        'Keep the bar scraping in close contact with shins and thighs.',
        'Once past knees, forcefully snap your hips forward to lock out tall.',
        'Stand proud without hyperextending your lumbar spine at the top.',
      ],
      breathingInstructions:
          'Take maximum intra-abdominal air at the floor setup; maintain brace until standing tall, then breathe out.',
      commonMistakes: [
        'Rounding the lower back off the floor.',
        'Letting the bar drift forward away from the body.',
        'Jerking the bar violently without taking the slack out first.',
      ],
      coachTip:
          'Don\'t think about pulling the bar up; think about driving the floor into the basement.',
      hypertrophyRepRange: '5 - 8 reps (RPE 7-8)',
      strengthRepRange: '1 - 5 reps (RPE 8-9)',
      tempo: '2-1-1-0',
    ),
    'overhead_press': const ExerciseGuide(
      slug: 'overhead_press',
      title: 'Barbell Overhead Press (OHP)',
      primaryMuscles: ['Anterior & Lateral Deltoids'],
      secondaryMuscles: ['Triceps', 'Upper Traps', 'Serratus', 'Core'],
      setupInstructions: [
        'Rest bar across upper clavicles, forearms vertical with elbows slightly in front.',
        'Feet shoulder-width apart, glutes and quads squeezed rock-solid.',
      ],
      executionInstructions: [
        'Tilt head slightly back so bar clears chin in a straight vertical line.',
        'Press bar straight up.',
        'Once bar passes forehead, push head back forward through the arm "window".',
        'Lock elbows out overhead with slight trap shrug for joint stability.',
      ],
      breathingInstructions:
          'Inhale at the collarbones, hold brace during press, exhale at top lockout.',
      commonMistakes: [
        'Excessively leaning back and hyperextending lumbar spine.',
        'Bending knees to initiate momentum (turning it into a push press).',
      ],
      coachTip:
          'Squeeze your glutes like you\'re holding a coin between them; it creates an unshakeable platform.',
      hypertrophyRepRange: '8 - 12 reps (RPE 7-8)',
      strengthRepRange: '3 - 6 reps (RPE 8-9)',
      tempo: '2-0-1-0',
    ),
    'barbell_row': const ExerciseGuide(
      slug: 'barbell_row',
      title: 'Bent-Over Barbell Row',
      primaryMuscles: ['Latissimus Dorsi', 'Rhomboids', 'Mid Traps'],
      secondaryMuscles: ['Biceps', 'Rear Deltoids', 'Lower Back'],
      setupInstructions: [
        'Hinge forward at roughly 45 degrees with a flat, rigid spine.',
        'Grip bar slightly wider than knees, arms hanging straight down.',
      ],
      executionInstructions: [
        'Pull elbows back toward your hips and lower ribcage.',
        'Touch the bar to your upper abdomen / navel.',
        'Squeeze shoulder blades together forcefully at the peak.',
        'Lower with control for a full stretch without losing torso posture.',
      ],
      breathingInstructions:
          'Inhale on the stretch; exhale as you pull into your ribcage.',
      commonMistakes: [
        'Using jerky body swing to heave the weight up.',
        'Pulling to neck instead of abdomen.',
      ],
      coachTip:
          'Treat your hands like hooks; initiate and drive solely with your elbows.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '5 - 8 reps',
      tempo: '2-1-1-0',
    ),
    'pull_up': const ExerciseGuide(
      slug: 'pull_up',
      title: 'Overhand Pull-Up',
      primaryMuscles: ['Latissimus Dorsi', 'Teres Major'],
      secondaryMuscles: ['Biceps', 'Brachialis', 'Rhomboids'],
      setupInstructions: [
        'Overhand pronated grip, slightly wider than shoulder-width.',
        'Hang completely with arms extended to full dead hang.',
      ],
      executionInstructions: [
        'Depress shoulder blades down and back.',
        'Drive elbows down and back toward your ribs.',
        'Pull until chin completely clears the bar.',
        'Lower with eccentric control back to dead hang.',
      ],
      breathingInstructions:
          'Inhale at bottom stretch; exhale forcefully on the way up.',
      commonMistakes: [
        'Kicking legs or kipping without strict control.',
        'Doing half reps without full elbow extension.',
      ],
      coachTip: 'Imagine pulling your elbows down into your back pockets.',
      hypertrophyRepRange: '6 - 10 reps',
      strengthRepRange: '3 - 5 weighted reps',
      tempo: '3-0-1-0',
    ),
    'incline_dumbbell_press': const ExerciseGuide(
      slug: 'incline_dumbbell_press',
      title: 'Incline Dumbbell Press',
      primaryMuscles: ['Upper Chest (Clavicular Head)'],
      secondaryMuscles: ['Front Deltoids', 'Triceps'],
      setupInstructions: [
        'Set bench angle to 30 degrees.',
        'Kick dumbbells up with knees onto your chest as you lie back.',
        'Pin shoulder blades into the bench with a steady base of support.',
      ],
      executionInstructions: [
        'Lower dumbbells with elbows angled at roughly 45 degrees.',
        'Feel a deep stretch across upper pectorals.',
        'Press upward in a smooth convergent arc without clacking dumbbells together.',
      ],
      breathingInstructions: 'Inhale on descent; exhale pushing up.',
      commonMistakes: [
        'Setting bench too steep (> 45\u00b0), shifting work to shoulders.',
        'Bouncing weights at bottom.',
      ],
      coachTip:
          'Keep dumbbells 2-3 inches apart at the top to keep constant tension on the chest fibers.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
    ),
    'lateral_raise': const ExerciseGuide(
      slug: 'lateral_raise',
      title: 'Dumbbell Lateral Raise',
      primaryMuscles: ['Lateral Deltoid (Side Delt)'],
      secondaryMuscles: ['Upper Traps', 'Supraspinatus'],
      setupInstructions: [
        'Slight 10-degree forward torso lean.',
        'Dumbbells held in front with a soft bend in elbows.',
      ],
      executionInstructions: [
        'Raise arms outward in the scapular plane (30\u00b0 forward).',
        'Lead with the elbows rather than the wrists.',
        'Stop at shoulder height and control the 3-second negative.',
      ],
      breathingInstructions:
          'Inhale before lift; exhale raising up, inhale lowering.',
      commonMistakes: [
        'Swinging torso and bouncing knees to generate momentum.',
        'Lifting wrists higher than elbows.',
      ],
      coachTip:
          'Pour out two pitchers of water at the top to maximally target the side delt.',
      hypertrophyRepRange: '12 - 18 reps',
      strengthRepRange: '10 - 12 reps',
      tempo: '2-0-1-2',
    ),
    'romanian_deadlift': const ExerciseGuide(
      slug: 'romanian_deadlift',
      title: 'Romanian Deadlift (RDL)',
      primaryMuscles: ['Hamstrings', 'Glutes'],
      secondaryMuscles: ['Lower Back', 'Upper Back'],
      setupInstructions: [
        'Start standing tall with bar at thigh level.',
        'Feet hip-width, knees soft with a slight unlock.',
      ],
      executionInstructions: [
        'Push hips backward toward the wall behind you.',
        'Keep bar in tight contact with legs all the way down.',
        'Descend until hamstrings are fully loaded (usually mid-shin).',
        'Drive hips forward to return tall.',
      ],
      breathingInstructions:
          'Inhale and brace before hip hinge; exhale snapping hips forward.',
      commonMistakes: [
        'Bending knees into a squat.',
        'Letting bar drift away from shins.',
      ],
      coachTip:
          'It\'s not a forward bend; it\'s reaching your hips as far backward as humanly possible.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
    ),
    'leg_press': const ExerciseGuide(
      slug: 'leg_press',
      title: '45\u00b0 Incline Leg Press',
      primaryMuscles: ['Quadriceps', 'Glutes'],
      secondaryMuscles: ['Adductors', 'Hamstrings'],
      setupInstructions: [
        'Tailbone and spine firmly pressed into backrest.',
        'Feet shoulder-width on center plate.',
      ],
      executionInstructions: [
        'Lower sled slowly to at least 90-degree knee bend.',
        'Press smoothly through whole foot without locking knees.',
      ],
      breathingInstructions: 'Inhale on descent; exhale pressing sled up.',
      commonMistakes: [
        'Allowing lower back to curl off pad.',
        'Hyper-extending and jamming knees at lockout.',
      ],
      coachTip:
          'Pull yourself down into the seat by grabbing the side handles tightly.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '6 - 10 reps',
      tempo: '3-0-1-0',
    ),
    'lat_pulldown': const ExerciseGuide(
      slug: 'lat_pulldown',
      title: 'Cable Lat Pulldown',
      primaryMuscles: ['Latissimus Dorsi'],
      secondaryMuscles: ['Biceps', 'Rear Delts'],
      setupInstructions: [
        'Lock thighs snugly under roller pads.',
        'Wide overhand grip with slight 15\u00b0 torso lean.',
      ],
      executionInstructions: [
        'Pull bar down to upper clavicle by driving elbows down.',
        'Hold 1-second squeeze at the chest.',
        'Return under control to full overhead stretch.',
      ],
      breathingInstructions: 'Inhale reaching up; exhale pulling down.',
      commonMistakes: ['Excessive swinging backwards.'],
      coachTip:
          'Think about pulling your elbows straight into your back pockets.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
    ),
    'barbell_curl': const ExerciseGuide(
      slug: 'barbell_curl',
      title: 'Barbell Bicep Curl',
      primaryMuscles: ['Biceps Brachii'],
      secondaryMuscles: ['Brachialis', 'Forearms'],
      setupInstructions: [
        'Underhand supinated grip shoulder-width apart.',
        'Elbows locked at your ribcage sides.',
      ],
      executionInstructions: [
        'Curl bar upward using only elbow flexion.',
        'Squeeze biceps at the top for 1 second.',
        'Lower slowly to full extension.',
      ],
      breathingInstructions: 'Inhale lowering; exhale curling up.',
      commonMistakes: ['Swinging torso or thrusting hips.'],
      coachTip:
          'Keep your elbows glued to your ribs throughout the entire set.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
    ),
    'triceps_pushdown': const ExerciseGuide(
      slug: 'triceps_pushdown',
      title: 'Cable Triceps Pushdown',
      primaryMuscles: ['Triceps Brachii'],
      secondaryMuscles: ['Forearms'],
      setupInstructions: [
        'High cable with bar or rope.',
        'Torso hinged slightly forward, elbows pinned to sides.',
      ],
      executionInstructions: [
        'Extend forearms straight down until full elbow lockout.',
        'Control back up to 90 degrees.',
      ],
      breathingInstructions: 'Inhale on the way up; exhale pushing down.',
      commonMistakes: ['Allowing elbows to flare and drift forward.'],
      coachTip:
          'Imagine your elbows are pinned on hinges attached to your sides.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '2-1-1-0',
    ),
    'push_up': const ExerciseGuide(
      slug: 'push_up',
      title: 'Push-Up',
      primaryMuscles: ['Pectorals', 'Triceps'],
      secondaryMuscles: ['Anterior Deltoids', 'Core'],
      setupInstructions: ['Hands just outside shoulders, rigid plank posture.'],
      executionInstructions: [
        'Lower chest to graze floor with elbows at 45 degrees.',
        'Push floor away back to lockout.',
      ],
      breathingInstructions: 'Inhale descending; exhale pushing up.',
      commonMistakes: ['Sagging lower back or flared elbows.'],
      coachTip: 'Keep glutes squeezed tight to maintain a solid plank.',
      hypertrophyRepRange: '12 - 25 reps',
      strengthRepRange: 'Weighted 8 - 12 reps',
      tempo: '2-0-1-0',
    ),
    'plank': const ExerciseGuide(
      slug: 'plank',
      title: 'Forearm Plank',
      primaryMuscles: ['Rectus Abdominis', 'Transverse Abdominis'],
      secondaryMuscles: ['Glutes', 'Obliques'],
      setupInstructions: [
        'Forearms parallel on floor, elbows under shoulders.',
      ],
      executionInstructions: [
        'Tuck pelvis into posterior tilt to flatten lower back.',
        'Hold with max tension while breathing steadily.',
      ],
      breathingInstructions:
          'Steady diaphragmatic breathing without dropping tension.',
      commonMistakes: ['Hips sagging or hiking too high.'],
      coachTip:
          'Actively pull your elbows toward your toes to spike core activation.',
      hypertrophyRepRange: '3 sets of 45-90 seconds',
      strengthRepRange: 'Weighted 3 sets of 30-45s',
      tempo: 'Static',
    ),
    'hanging_leg_raise': const ExerciseGuide(
      slug: 'hanging_leg_raise',
      title: 'Hanging Leg Raise',
      primaryMuscles: ['Lower Abdominals'],
      secondaryMuscles: ['Hip Flexors', 'Grip'],
      setupInstructions: [
        'Hang with overhand grip from pull-up bar, eliminate swing.',
      ],
      executionInstructions: [
        'Curl pelvis upward toward your ribs.',
        'Lift legs to at least 90 degrees.',
        'Lower under complete control.',
      ],
      breathingInstructions: 'Exhale lifting legs; inhale lowering down.',
      commonMistakes: ['Swinging for momentum.'],
      coachTip: 'Focus on curling your pelvis up, not just lifting your feet.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '12 - 20 reps',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/hanging_leg_raise.svg',
    ),
    'dips': const ExerciseGuide(
      slug: 'dips',
      title: 'Chest & Triceps Parallel Bar Dips',
      primaryMuscles: ['Lower Pectoralis Major', 'Triceps Brachii'],
      secondaryMuscles: ['Anterior Deltoid'],
      setupInstructions: [
        'Support yourself on parallel bars with depressed shoulders and braced core.',
        'Lean torso 20-30° forward for chest emphasis, or stay upright for triceps.',
      ],
      executionInstructions: [
        'Lower under control until shoulders reach elbow level (90° flexion).',
        'Press forcefully back to full lockout while keeping shoulders down.',
      ],
      breathingInstructions: 'Inhale descending; exhale pressing up.',
      commonMistakes: [
        'Shrugging shoulders toward ears or dropping below active mobility.',
      ],
      coachTip:
          'Keep your shoulder blades actively depressed throughout the entire movement.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '5 - 8 weighted reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dips.svg',
    ),
    'cable_fly': const ExerciseGuide(
      slug: 'cable_fly',
      title: 'Standing Cable Chest Fly',
      primaryMuscles: ['Pectoralis Major (Sternal Fibers)'],
      secondaryMuscles: ['Anterior Deltoid'],
      setupInstructions: [
        'Set pulleys at shoulder height, step forward into a stable staggered stance.',
      ],
      executionInstructions: [
        'Bring handles together in a wide hugging arc with slightly bent, fixed elbows.',
        'Squeeze inner chest for 1 full second before returning slowly.',
      ],
      breathingInstructions:
          'Inhale on the stretch; exhale squeezing handles together.',
      commonMistakes: ['Bending elbows into a press instead of a wide arc.'],
      coachTip:
          'Focus on driving the insides of your elbows toward each other.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '10 - 12 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/cable_fly.svg',
    ),
    'chin_up': const ExerciseGuide(
      slug: 'chin_up',
      title: 'Underhand Chin-Up',
      primaryMuscles: ['Latissimus Dorsi', 'Biceps Brachii'],
      secondaryMuscles: ['Teres Major', 'Rhomboids', 'Core'],
      setupInstructions: [
        'Grip bar shoulder-width apart with palms facing toward you (supinated).',
      ],
      executionInstructions: [
        'Depress scapulae and pull chest to the bar while driving elbows down.',
        'Clear the bar with your chin and lower slowly to a full dead hang.',
      ],
      breathingInstructions: 'Inhale at bottom; exhale pulling up.',
      commonMistakes: ['Cutting range of motion short at the bottom.'],
      coachTip:
          'Supinated grip places the biceps in their strongest line of pull while deeply stretching the lats.',
      hypertrophyRepRange: '6 - 12 reps',
      strengthRepRange: '3 - 6 weighted reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/chin_up.svg',
    ),
    'dumbbell_row': const ExerciseGuide(
      slug: 'dumbbell_row',
      title: 'One-Arm Dumbbell Row',
      primaryMuscles: ['Latissimus Dorsi', 'Rhomboids'],
      secondaryMuscles: ['Mid Traps', 'Rear Deltoid', 'Biceps'],
      setupInstructions: [
        'Brace non-working hand on bench or rack with torso flat and stable.',
      ],
      executionInstructions: [
        'Row the dumbbell in an arc back toward your hip crease.',
        'Pause at the top and lower to a full scapular stretch.',
      ],
      breathingInstructions: 'Inhale lowering; exhale rowing toward hip.',
      commonMistakes: [
        'Pulling straight up to the shoulder instead of back to the hip.',
      ],
      coachTip: 'Think about sawing the weight back toward your back pocket.',
      hypertrophyRepRange: '8 - 12 reps per arm',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_row.svg',
    ),
    'seated_cable_row': const ExerciseGuide(
      slug: 'seated_cable_row',
      title: 'Seated Cable Row',
      primaryMuscles: ['Mid Back (Rhomboids, Traps)', 'Latissimus Dorsi'],
      secondaryMuscles: ['Biceps', 'Erector Spinae'],
      setupInstructions: [
        'Sit tall with feet braced on platform and knees slightly bent.',
      ],
      executionInstructions: [
        'Retract shoulder blades and pull handle to lower sternum / navel.',
        'Hold peak contraction for 1 second, then return under control.',
      ],
      breathingInstructions:
          'Inhale reaching forward; exhale rowing into abdomen.',
      commonMistakes: ['Swinging lower back excessively back and forth.'],
      coachTip:
          'Initiate every rep by squeezing your shoulder blades together before bending the elbows.',
      hypertrophyRepRange: '10 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/seated_cable_row.svg',
    ),
    'lunges': const ExerciseGuide(
      slug: 'lunges',
      title: 'Dumbbell Walking Lunges',
      primaryMuscles: ['Quadriceps', 'Gluteus Maximus'],
      secondaryMuscles: ['Hamstrings', 'Gluteus Medius', 'Calves'],
      setupInstructions: [
        'Stand tall holding dumbbells at your sides with core braced.',
      ],
      executionInstructions: [
        'Step forward hip-width apart and lower until both knees reach 90 degrees.',
        'Drive through the front heel to step into the next repetition.',
      ],
      breathingInstructions: 'Inhale descending; exhale driving up.',
      commonMistakes: [
        'Walking on a tightrope line or letting front knee cave inward.',
      ],
      coachTip:
          'A shorter stride emphasizes quads; a slightly longer stride with forward torso lean targets glutes.',
      hypertrophyRepRange: '10 - 12 reps per leg',
      strengthRepRange: '6 - 8 reps per leg',
      tempo: '2-0-1-0',
      assetIllustrationPath: 'assets/illustrations/lunges.svg',
    ),
    'hip_thrust': const ExerciseGuide(
      slug: 'hip_thrust',
      title: 'Barbell Hip Thrust',
      primaryMuscles: ['Gluteus Maximus'],
      secondaryMuscles: ['Hamstrings', 'Quadriceps', 'Core'],
      setupInstructions: [
        'Rest lower scapulae against a stable bench with padded barbell over hip crease.',
        'Position feet so shins are strictly vertical at the top lockout.',
      ],
      executionInstructions: [
        'Drive through heels to extend hips until torso is parallel to the floor.',
        'Keep chin tucked and squeeze glutes with posterior pelvic tilt for 1-2 seconds.',
      ],
      breathingInstructions: 'Inhale lowering; exhale locking hips at the top.',
      commonMistakes: [
        'Hyperextending lower back instead of extending at the hips.',
      ],
      coachTip:
          'Keep your eyes locked on a spot straight ahead to prevent lumbar hyperextension.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '5 - 8 reps',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/hip_thrust.svg',
    ),
    'bulgarian_split_squat': const ExerciseGuide(
      slug: 'bulgarian_split_squat',
      title: 'Bulgarian Split Squat',
      primaryMuscles: ['Quadriceps', 'Gluteus Maximus'],
      secondaryMuscles: ['Gluteus Medius', 'Adductors'],
      setupInstructions: [
        'Elevate rear instep on a bench or roller pad, front foot two paces ahead.',
      ],
      executionInstructions: [
        'Lower vertically on the front leg until deep hip and knee flexion.',
        'Drive through the front mid-foot to return to standing.',
      ],
      breathingInstructions: 'Inhale descending; exhale driving up.',
      commonMistakes: ['Pushing excessively off the back foot.'],
      coachTip: 'Keep 85-90% of your weight loaded on the front working leg.',
      hypertrophyRepRange: '8 - 12 reps per leg',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/bulgarian_split_squat.svg',
    ),
    'leg_extension': const ExerciseGuide(
      slug: 'leg_extension',
      title: 'Seated Leg Extension',
      primaryMuscles: ['Quadriceps (Rectus Femoris & Vasti)'],
      secondaryMuscles: [],
      setupInstructions: [
        'Align machine pivot point with your knee joint, pad resting on lower shins.',
      ],
      executionInstructions: [
        'Extend knees completely and hold peak contraction for 1 second.',
        'Lower slowly over 3 seconds without slamming the weight stack.',
      ],
      breathingInstructions: 'Exhale extending; inhale lowering.',
      commonMistakes: ['Lifting hips off the seat pad.'],
      coachTip:
          'Pull yourself firmly into the seat using the side handles and flex toes up.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_extension.svg',
    ),
    'leg_curl': const ExerciseGuide(
      slug: 'leg_curl',
      title: 'Hamstring Leg Curl',
      primaryMuscles: ['Hamstrings'],
      secondaryMuscles: ['Gastrocnemius'],
      setupInstructions: [
        'Align knee joint with machine axis, pad positioned just above Achilles tendon.',
      ],
      executionInstructions: [
        'Curl heels all the way back toward glutes and hold 1 second.',
        'Control the eccentric return over 3 full seconds.',
      ],
      breathingInstructions: 'Exhale curling; inhale extending.',
      commonMistakes: ['Hips rising off the pad to cheat the weight.'],
      coachTip:
          'Control the negative phase to maximize hamstring hypertrophy and tendon resilience.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '6 - 10 reps',
      tempo: '3-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_curl.svg',
    ),
    'calf_raise': const ExerciseGuide(
      slug: 'calf_raise',
      title: 'Standing Calf Raise',
      primaryMuscles: ['Gastrocnemius'],
      secondaryMuscles: ['Soleus'],
      setupInstructions: [
        'Place balls of feet on platform edge with knees straight but unlocked.',
      ],
      executionInstructions: [
        'Lower heels into a full 2-second stretch at the bottom.',
        'Drive all the way up onto the big toe and pause 1 second at the top.',
      ],
      breathingInstructions: 'Inhale at bottom stretch; exhale rising up.',
      commonMistakes: [
        'Bouncing rapidly at the bottom using Achilles tendon recoil.',
      ],
      coachTip:
          'Pause 2 seconds at the bottom of every rep to eliminate elastic bounce.',
      hypertrophyRepRange: '12 - 20 reps',
      strengthRepRange: '8 - 12 reps',
      tempo: '2-2-1-1',
      assetIllustrationPath: 'assets/illustrations/calf_raise.svg',
    ),
    'dumbbell_shoulder_press': const ExerciseGuide(
      slug: 'dumbbell_shoulder_press',
      title: 'Seated Dumbbell Shoulder Press',
      primaryMuscles: ['Anterior Deltoid', 'Lateral Deltoid'],
      secondaryMuscles: ['Triceps Brachii', 'Upper Traps'],
      setupInstructions: [
        'Set bench backrest to 75-80 degrees, elbows angled 30° forward in the scapular plane.',
      ],
      executionInstructions: [
        'Press dumbbells overhead to full extension without clanking them together.',
        'Lower under control until dumbbells reach ear / chin level.',
      ],
      breathingInstructions: 'Inhale lowering; exhale pressing up.',
      commonMistakes: ['Flaring elbows straight out at 90 degrees.'],
      coachTip:
          'A 75-degree incline is far friendlier on the shoulder joint than a strict 90-degree upright seat.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_shoulder_press.svg',
    ),
    'face_pull': const ExerciseGuide(
      slug: 'face_pull',
      title: 'Cable Face Pull',
      primaryMuscles: ['Rear Deltoids', 'External Rotators (Infraspinatus)'],
      secondaryMuscles: ['Mid & Lower Traps', 'Rhomboids'],
      setupInstructions: [
        'Set pulley at upper chest/head height with rope attachment.',
      ],
      executionInstructions: [
        'Pull rope toward forehead while pulling handles apart and rotating thumbs back.',
        'Hold a 1-second rear double-biceps pose at peak contraction.',
      ],
      breathingInstructions: 'Exhale pulling toward face; inhale extending.',
      commonMistakes: ['Going too heavy and pulling down toward chest.'],
      coachTip:
          'Finish with your wrists behind your elbows to engage true external rotation.',
      hypertrophyRepRange: '15 - 20 reps',
      strengthRepRange: '12 - 15 reps',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/face_pull.svg',
    ),
    'hammer_curl': const ExerciseGuide(
      slug: 'hammer_curl',
      title: 'Dumbbell Hammer Curl',
      primaryMuscles: ['Brachioradialis', 'Brachialis'],
      secondaryMuscles: ['Biceps Brachii'],
      setupInstructions: [
        'Stand tall holding dumbbells with a neutral (palms facing each other) grip.',
      ],
      executionInstructions: [
        'Curl weights up keeping elbows pinned to your ribs and palms neutral.',
        'Squeeze at the top and lower slowly.',
      ],
      breathingInstructions: 'Exhale curling up; inhale lowering.',
      commonMistakes: [
        'Swinging shoulders and torso to lift heavier dumbbells.',
      ],
      coachTip:
          'Hammer curls build dense brachialis and forearm thickness that widens the arm from the front.',
      hypertrophyRepRange: '10 - 14 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/hammer_curl.svg',
    ),
    'incline_dumbbell_curl': const ExerciseGuide(
      slug: 'incline_dumbbell_curl',
      title: 'Incline Dumbbell Curl',
      primaryMuscles: ['Biceps Brachii (Long Head)'],
      secondaryMuscles: ['Brachialis'],
      setupInstructions: [
        'Lie back on a 45-60° incline bench with arms hanging straight down behind your torso line.',
      ],
      executionInstructions: [
        'Curl dumbbells upward while keeping elbows pointing strictly at the floor.',
        'Lower all the way down into a full long-head bicep stretch.',
      ],
      breathingInstructions: 'Inhale lowering; exhale curling.',
      commonMistakes: ['Letting elbows drift forward during the curl.'],
      coachTip:
          'Stretch-mediated hypertrophy on the incline curl preferentially targets the biceps peak.',
      hypertrophyRepRange: '10 - 12 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/incline_dumbbell_curl.svg',
    ),
    'overhead_triceps_extension': const ExerciseGuide(
      slug: 'overhead_triceps_extension',
      title: 'Overhead Cable Triceps Extension',
      primaryMuscles: ['Triceps Brachii (Long Head)'],
      secondaryMuscles: ['Lateral & Medial Triceps Heads'],
      setupInstructions: [
        'Face away from pulley in a split stance, elbows raised overhead.',
      ],
      executionInstructions: [
        'Allow rope to stretch triceps deeply behind your head.',
        'Extend forearms overhead to full lockout while keeping elbows stationary.',
      ],
      breathingInstructions:
          'Inhale on the stretch; exhale extending overhead.',
      commonMistakes: [
        'Arching lower back excessively instead of bracing abs.',
      ],
      coachTip:
          'Overhead extensions place the long head of the triceps in maximal stretch for superior growth.',
      hypertrophyRepRange: '10 - 15 reps',
      strengthRepRange: '8 - 10 reps',
      tempo: '3-1-1-0',
      assetIllustrationPath:
          'assets/illustrations/overhead_triceps_extension.svg',
    ),
    'skull_crusher': const ExerciseGuide(
      slug: 'skull_crusher',
      title: 'EZ-Bar Skull Crusher',
      primaryMuscles: ['Triceps Brachii (All 3 Heads)'],
      secondaryMuscles: ['Forearms'],
      setupInstructions: [
        'Lie on flat bench holding EZ-bar with arms angled slightly back toward crown of head.',
      ],
      executionInstructions: [
        'Hinge only at the elbows to lower the bar toward forehead or just behind the head.',
        'Extend elbows forcefully back to starting angle.',
      ],
      breathingInstructions: 'Inhale lowering; exhale extending.',
      commonMistakes: ['Flaring elbows wide out to the sides.'],
      coachTip:
          'Angling upper arms 15° back toward the wall behind you keeps continuous tension on the triceps.',
      hypertrophyRepRange: '8 - 12 reps',
      strengthRepRange: '6 - 8 reps',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/skull_crusher.svg',
    ),
    'cable_crunch': const ExerciseGuide(
      slug: 'cable_crunch',
      title: 'Kneeling Cable Crunch',
      primaryMuscles: ['Rectus Abdominis'],
      secondaryMuscles: ['Obliques'],
      setupInstructions: [
        'Kneel below high pulley holding rope attachment beside your temples.',
      ],
      executionInstructions: [
        'Flex your spine to curl your ribcage down toward your pelvis while keeping hips stationary.',
        'Exhale fully at peak contraction and uncurl vertebra by vertebra.',
      ],
      breathingInstructions: 'Inhale at top; exhale forcefully curling down.',
      commonMistakes: [
        'Sitting hips back onto heels instead of flexing the spine.',
      ],
      coachTip:
          'Lock your hips in place—all movement must come from curling your sternum toward your belly button.',
      hypertrophyRepRange: '12 - 15 reps',
      strengthRepRange: '8 - 12 reps',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/cable_crunch.svg',
    ),
  };

  // ---------------------------------------------------------------------------
  // ARABIC GUIDES
  // ---------------------------------------------------------------------------
  static final Map<String, ExerciseGuide> _arabicGuides = {
    'bench_press': const ExerciseGuide(
      slug: 'bench_press',
      title: 'بنش برس مستوي بالبار',
      primaryMuscles: ['عضلات الصدر (الوسطى والسفلية)'],
      secondaryMuscles: ['الترايسبس', 'الكتف الأمامي', 'العضلة المنشارية'],
      setupInstructions: [
        'استلقِ على المقعد بحيث تكون عيناك تحت البار مباشرة.',
        'ثبت قدميك جيداً ومسطحة على الأرض للاستفادة من قوة الدفع.',
        'ضم لوحي الكتف للخلف والأسفل مع قوس طبيعي خفيف في أسفل الظهر.',
        'أمسك البار بمسافة أعرض قليلاً من الكتفين لتكون السواعد عمودية.',
      ],
      executionInstructions: [
        'ارفع البار وثبته فوق مستوى الكتفين مباشرة.',
        'انزل بالبار بهدوء في مسار مائل خفيف نحو منتصف وأسفل الصدر.',
        'حافظ على زاوية الكوعين بين 45 و 70 درجة (لا تفتح الكوعين بزاوية 90 درجة).',
        'المس الصدر بخفة ثم ادفع بقوة للأعلى وللخلف قليلاً فوق الكتفين.',
      ],
      breathingInstructions:
          'خذ نفساً عميقاً في البطن والصدر واحبسه قبل النزول، وازفر بعد تجاوز أصعب نقطة عند الصعود.',
      commonMistakes: [
        'فتح الكوعين بزاوية 90 درجة مما يسبب ضغطاً خطيراً على مفصل الكتف.',
        'ارتطام البار بالصدر بقوة لارتداده بالسرعة.',
        'رفع المؤخرة عن المقعد أثناء الدفع بالأوزان الثقيلة.',
      ],
      coachTip:
          'تخيل أنك تحاول ثني البار إلى نصفين بيديك لتفعيل الظهر وتثبيت الكوعين في الزاوية المثالية.',
      hypertrophyRepRange: '8 - 12 تكرار (مستوى الجهد 7-8)',
      strengthRepRange: '3 - 6 تكرارات (مستوى الجهد 8-9)',
      tempo: '3-1-1-0',
    ),
    'squat': const ExerciseGuide(
      slug: 'squat',
      title: 'سكوات خلفي بالبار (Back Squat)',
      primaryMuscles: [
        'عضلات الفخذ الأمامية (الكوادس)',
        'عضلات المؤخرة (الجلوتس)',
      ],
      secondaryMuscles: ['الفخذ الخلفي', 'عضلات الجذع والبطن', 'أسفل الظهر'],
      setupInstructions: [
        'ضع البار على عضلات الترابيز العلوية أو أخفض قليلاً على الكتف الخلفي.',
        'تراجع خطوتين أو 3 خطوات محسوبة، واجعل القدمين باتساع الكتفين مع زاوية 20-30 درجة للخارج.',
        'ثبت القدمين كالمثلث (إصبع الإبهام، الإصبع الصغير، والكعب).',
        'خذ نفساً بطنياً عميقاً واحبسه لحماية العمود الفقري.',
      ],
      executionInstructions: [
        'ابدأ النزول بثني الركبتين والوركين في وقت واحد وبتحكم كامل.',
        'وجّه الركبتين في نفس اتجاه أصابع القدمين بالضبط.',
        'انزل حتى ينكسر مستوى الورك تحت مستوى أعلى الركبة (العمق الصحيح).',
        'ادفع الأرض بقوة من منتصف القدم مع إبقاء الصدر مرفوعاً للأعلى.',
      ],
      breathingInstructions:
          'تنفس بعمق واشد عضلات بطنك 360 درجة قبل الهبوط، وازفر بعد الصعود وتجاوز منتصف الحركة.',
      commonMistakes: [
        'دخول الركبتين للداخل أثناء الدفع.',
        'ارتفاع الكعبين عن الأرض بسبب قلة مرونة الكاحل.',
        'انحناء الظهر الشديد للأمام وفقدان الاستقامة.',
      ],
      coachTip:
          'تخيل أنك تدير قدميك للخارج لفتح الأرض بين قدميك لتوليد قوة ثبات هائلة في الحوض.',
      hypertrophyRepRange: '6 - 10 تكرارات',
      strengthRepRange: '3 - 5 تكرارات',
      tempo: '3-0-1-0',
    ),
    'deadlift': const ExerciseGuide(
      slug: 'deadlift',
      title: 'ديدليفت بالبار (النمط الكلاسيكي)',
      primaryMuscles: [
        'السلسلة الخلفية (الفخذ الخلفي، الجلوتس)',
        'عضلات الظهر الممتدة',
      ],
      secondaryMuscles: [
        'المجنص (اللاتس)',
        'الترابيز',
        'القبضة والساعد',
        'الكوادس',
      ],
      setupInstructions: [
        'قف بمسافة اتساع الحوض بين القدمين، بحيث يمر البار فوق منتصف مشط القدم.',
        'انحنِ من مفصل الحوض وأمسك البار من خارج مستوى الساقين مباشرة.',
        'قرّب ساقيك حتى تلمسا البار دون تحريكه من مكانه.',
        'ارفع صدرك للأعلى وشد الظهر لسحب الفراغ الميكانيكي من البار قبل الانطلاق.',
      ],
      executionInstructions: [
        'ادفع الأرض بقدميك كما لو كنت تدفع جهاز دفع الأرجل.',
        'حافظ على ملاصقة البار للساقين والفخذين طوال المسار.',
        'بمجرد تجاوز الركبتين، ادفع الحوض للأمام بقوة للوصول للوقوف الكامل.',
        'قف باستقامة كاملة دون إمالة الظهر للخلف بشكل مفرط.',
      ],
      breathingInstructions:
          'احبس النفس والضغط البطني عند الانطلاق من الأرض، وازفر عند الوقوف الكامل.',
      commonMistakes: [
        'تقوس أسفل الظهر عند الانطلاق من الأرض.',
        'ابتعاد البار عن الساقين مما يضاعف العبء على الفقرات القطنية.',
        'سحب البار بذراعين مثنيتين (خطر على أوتار البايسبس).',
      ],
      coachTip:
          'لا تفكر في سحب البار لأعلى، بل فكّر في دفع كوكب الأرض بعيداً عنك بقدميك.',
      hypertrophyRepRange: '5 - 8 تكرارات',
      strengthRepRange: '1 - 5 تكرارات',
      tempo: '2-1-1-0',
    ),
    'overhead_press': const ExerciseGuide(
      slug: 'overhead_press',
      title: 'ضغط كتف عسكري بالبار (OHP)',
      primaryMuscles: ['الكتف الأمامي والجانبي'],
      secondaryMuscles: ['الترايسبس', 'أعلى الترابيز', 'عضلات البطن'],
      setupInstructions: [
        'استند بالبار على عظام الترقوة مع سواعد عمودية وكوعين أمام البار قليلاً.',
        'قدمان باتساع الكتفين مع عصر الجلوتس والبطن بقوة لتثبيت الجذع.',
      ],
      executionInstructions: [
        'أمل رأسك قليلاً للخلف ليمر البار عمودياً دون اصطدام بالذقن.',
        'ادفع البار لأعلى في خط مستقيم تماماً.',
        'بمجرد تجاوز البار للجبهة، مرر الرأس للأمام بين الذراعين.',
        'اقفل الكوعين في الأعلى مع رفع خفيف للترابيز لتأمين المفصل.',
      ],
      breathingInstructions:
          'استنشق عند الصدر، احبس النفس أثناء الدفع، وازفر في القفل بالأعلى.',
      commonMistakes: [
        'تقوس مفرط في أسفل الظهر لتعويض نقص مرونة الكتفين.',
        'استخدام دفع الركبتين لتحويله إلى Push Press بدلاً من تمرين عسكري نقي.',
      ],
      coachTip:
          'شد عضلات المؤخرة بأقصى قوة أثناء الدفع لمنع الظهر من الانحناء نهائياً.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '3 - 6 تكرارات',
      tempo: '2-0-1-0',
    ),
    'barbell_row': const ExerciseGuide(
      slug: 'barbell_row',
      title: 'سحب بار منحني (بنت أوفر)',
      primaryMuscles: ['المجنص (اللاتس)', 'عضلات الظهر الأوسط', 'الرومبويدز'],
      secondaryMuscles: ['البايسبس', 'الكتف الخلفي', 'عضلات أسفل الظهر'],
      setupInstructions: [
        'انحنِ بجذعك للأمام بزاوية تقارب 45 درجة مع ظهر مستقيم كالمسطرة.',
        'أمسك البار بقبضة أعرض قليلاً من الركبتين ودع الذراعين تتدليان عمودياً.',
      ],
      executionInstructions: [
        'اسحب بكوعيك للخلف باتجاه الحوض وأسفل القفص الصدري.',
        'المس السرة أو أسفل الصدر بالبار مع عصر عضلات الظهر بقوة لمدة ثانية.',
        'انزل بالبار ببطء وتحكم حتى تستطيل ألياف الظهر تماماً.',
      ],
      breathingInstructions:
          'استنشق في وضعية التمدد بالأسفل، وازفر أثناء السحب وعصر الظهر.',
      commonMistakes: [
        'الاهتزاز بالجذع للأعلى لخداع الوزن بالدفع الحركي.',
        'السحب باتجاه الرقبة بدلاً من الحوض والبطن.',
      ],
      coachTip:
          'تخيل يديك مجرد خطافين، وأن القوة والسحب ينبعان بالكامل من كوعيك.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '5 - 8 تكرارات',
      tempo: '2-1-1-0',
    ),
    'pull_up': const ExerciseGuide(
      slug: 'pull_up',
      title: 'تمرين العقلة قبضة واسعة',
      primaryMuscles: ['عضلات المجنص (اللاتس)'],
      secondaryMuscles: ['البايسبس', 'الكتف الخلفي', 'الساعد'],
      setupInstructions: [
        'أمسك العارضة بقبضة واسعة والراحتان للأمام، وتعلّق بالكامل لامتداد الظهر.',
      ],
      executionInstructions: [
        'اخفض لوحي الكتف لأسفل أولاً.',
        'اسحب صدرك للأعلى باتجاه البار بدفع الكوعين للأسفل.',
        'استمر حتى يتجاوز ذقنك مستوى العارضة بالكامل.',
        'انزل ببطء وتحكم للتعلق الكامل من جديد.',
      ],
      breathingInstructions:
          'استنشق بالأسفل، وازفر بقوة أثناء سحب جسمك للأعلى.',
      commonMistakes: [
        'التأرجح بالقدمين واستخدام الاندفاع (الكيپينغ).',
        'عدم النزول للامتداد الكامل للكوعين.',
      ],
      coachTip: 'تخيل أنك تدفع كوعيك لأسفل في جيوب بنطالك الخلفية.',
      hypertrophyRepRange: '6 - 10 تكرارات',
      strengthRepRange: '3 - 5 تكرارات بوزن إضافي',
      tempo: '3-0-1-0',
    ),
    'incline_dumbbell_press': const ExerciseGuide(
      slug: 'incline_dumbbell_press',
      title: 'بنش برس مائل بالدامبلز',
      primaryMuscles: ['الصدر العلوي'],
      secondaryMuscles: ['الكتف الأمامي', 'الترايسبس'],
      setupInstructions: [
        'اضبط المقعد على زاوية 30 درجة (لتفادي تحويل الجهد للكتف).',
        'ارفع الدامبلز بركبتيك نحو الصدر وأنت تستلقي للخلف وثبت ظهرك جيداً.',
      ],
      executionInstructions: [
        'انزل بالدامبلز بزاوية كوع 45 درجة حتى تشعر بإطالة الصدر العلوي.',
        'ادفع للأعلى في مسار قوسي ناعم دون اصطدام الدامبلز.',
      ],
      breathingInstructions: 'شهيق أثناء النزول وزفير أثناء الدفع للأعلى.',
      commonMistakes: [
        'رفع زاوية المقعد لأكثر من 45 درجة مما يركز التمرين على الكتف.',
        'صدم الدامبلز ببعضهما في الأعلى مما يلغي الشد العضلي.',
      ],
      coachTip:
          'أبقِ مسافة 5 سم بين الدامبلز في الأعلى للحفاظ على الشد المستمر.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '3-1-1-0',
    ),
    'lateral_raise': const ExerciseGuide(
      slug: 'lateral_raise',
      title: 'رفرفة جانبية بالدامبلز',
      primaryMuscles: ['عضلة الكتف الجانبي'],
      secondaryMuscles: ['أعلى الترابيز'],
      setupInstructions: [
        'أمل جذعك للأمام بزاوية خفيفة جداً (10 درجات).',
        'أمسك الدامبلز أمام فخذيك مع ثنية خفيفة جداً في الكوعين.',
      ],
      executionInstructions: [
        'ارفع ذراعيك للجانبين والأمام قليلاً (في مستوى لوح الكتف).',
        'قد الحركة بالكوعين واصعد لمستوى الكتف فقط.',
        'قاوم النزول ببطء لمدة 3 ثوانٍ كاملة.',
      ],
      breathingInstructions: 'شهيق قبل البداية، وزفير عند رفع الذراعين.',
      commonMistakes: [
        'التأرجح بالظهر واستخدام قوة الاندفاع.',
        'رفع المعصم أعلى من الكوع.',
      ],
      coachTip: 'تخيل أنك تدفع جدران الغرفة بكوعيك بدلاً من مجرد رفع الوزن.',
      hypertrophyRepRange: '12 - 18 تكرار',
      strengthRepRange: '10 - 12 تكرار',
      tempo: '2-0-1-2',
    ),
    'romanian_deadlift': const ExerciseGuide(
      slug: 'romanian_deadlift',
      title: 'ديدليفت روماني (RDL)',
      primaryMuscles: ['الفخذ الخلفي (الهامسترنج)', 'الجلوتس'],
      secondaryMuscles: ['أسفل الظهر', 'أعلى الظهر'],
      setupInstructions: [
        'ابدأ بالوقوف مستقيماً والبار ممسوك على الفخذين.',
        'اجعل الركبتين مرنتين بزاوية ثني طفيفة ثابتة.',
      ],
      executionInstructions: [
        'ادفع حوضك للخلف كأنك تلمس جداراً خلفك.',
        'دع البار ينزلق ملاصقاً تماماً للفخذين والساقين.',
        'انزل حتى تشعر بتمدد قوي في الفخذ الخلفي ثم ارجع بدفع الحوض للأمام.',
      ],
      breathingInstructions:
          'شهيق عند دفع الحوض للخلف، وزفير عند العودة للأمام.',
      commonMistakes: [
        'ثني الركبتين وتحويله إلى سكوات.',
        'ابتعاد البار عن الساقين.',
      ],
      coachTip:
          'الحركة ليست انحناء للأسفل، بل هي دفع المؤخرة إلى أقصى حد للخلف.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '3-1-1-0',
    ),
    'leg_press': const ExerciseGuide(
      slug: 'leg_press',
      title: 'دفع الأرجل بالجهاز 45 درجة',
      primaryMuscles: ['الفخذ الأمامي', 'الجلوتس'],
      secondaryMuscles: ['الفخذ الداخلي', 'الخلفيات'],
      setupInstructions: [
        'ألصق ظهرك ومؤخرتك تماماً بمسند المقعد.',
        'ضع قدميك باتساع الكتفين على منتصف اللوح.',
      ],
      executionInstructions: [
        'انزل باللوح بتحكم لزاوية 90 درجة بالركبتين دون أن يرتفع حوضك عن المقعد.',
        'ادفع بقوة بكامل القدم دون قفل الركبتين بقسوة.',
      ],
      breathingInstructions: 'شهيق عند نزول اللوح وزفير مع الدفع.',
      commonMistakes: [
        'قفل الركبتين بحركة مفرطة وخطيرة بالأعلى.',
        'ارتفاع أسفل الظهر عن المسند.',
      ],
      coachTip: 'أمسك المقابض الجانبية بقوة لشد جسمك وتثبيته في المقعد.',
      hypertrophyRepRange: '10 - 15 تكرار',
      strengthRepRange: '6 - 10 تكرارات',
      tempo: '3-0-1-0',
    ),
    'lat_pulldown': const ExerciseGuide(
      slug: 'lat_pulldown',
      title: 'سحب عالي بالكيبل',
      primaryMuscles: ['المجنص (اللاتس)'],
      secondaryMuscles: ['البايسبس', 'الكتف الخلفي'],
      setupInstructions: [
        'ثبت فخذيك بإحكام تحت المساند الإسفنجية.',
        'أمسك البار بقبضة واسعة وأمل جذعك 15 درجة للخلف.',
      ],
      executionInstructions: [
        'اسحب البار باتجاه أعلى الصدر بدفع الكوعين للأسفل.',
        'اثبت ثانية واحدة مع عصر عضلات الظهر ثم اصعد بتحكم.',
      ],
      breathingInstructions: 'شهيق عند صعود البار، وزفير أثناء السحب.',
      commonMistakes: ['التأرجح المفرط بالجذع للخلف.'],
      coachTip: 'فكر في توجيه كوعيك مباشرة نحو جيوبك الخلفية.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-1-1-0',
    ),
    'barbell_curl': const ExerciseGuide(
      slug: 'barbell_curl',
      title: 'كيرل بايسبس بالبار',
      primaryMuscles: ['البايسبس'],
      secondaryMuscles: ['الساعد'],
      setupInstructions: [
        'أمسك البار من تحت باتساع الكتفين وثبت كوعيك بجانبي الجذع.',
      ],
      executionInstructions: [
        'ارفع البار بثني الكوعين فقط واثبت ثانية في أعلى نقطة.',
        'انزل ببطء حتى الامتداد الكامل للذراعين.',
      ],
      breathingInstructions: 'شهيق أثناء النزول وزفير عند الرفع.',
      commonMistakes: ['أرجحة الظهر والحوض لدفع الوزن.'],
      coachTip: 'ألصق كوعيك بجانبيك كأنهما مثبتان ببراغي.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-1-1-0',
    ),
    'triceps_pushdown': const ExerciseGuide(
      slug: 'triceps_pushdown',
      title: 'ضغط ترايسبس بالكيبل',
      primaryMuscles: ['الترايسبس'],
      secondaryMuscles: ['الساعد'],
      setupInstructions: [
        'استخدم بكرة الكيبل العالية مع الحبل أو البار المستقيم.',
        'أمل جسمك قليلاً للأمام وثبت كوعيك في مكانهما.',
      ],
      executionInstructions: [
        'افرد ذراعيك للأسفل تماماً حتى انقباض الترايسبس بالكامل.',
        'ارجع بتحكم حتى زاوية 90 درجة.',
      ],
      breathingInstructions: 'شهيق عند الصعود وزفير عند الضغط للأسفل.',
      commonMistakes: ['تحريك الكوعين للأمام والخلف أثناء الحركة.'],
      coachTip: 'تخيل أن كوعيك مثبتان على محور يدور فقط دون أن يتحرك من مكانه.',
      hypertrophyRepRange: '10 - 15 تكرار',
      strengthRepRange: '8 - 10 تكرارات',
      tempo: '2-1-1-0',
    ),
    'push_up': const ExerciseGuide(
      slug: 'push_up',
      title: 'تمرين الضغط الكلاسيكي',
      primaryMuscles: ['الصدر', 'الترايسبس'],
      secondaryMuscles: ['الكتف الأمامي', 'عضلات الجذع'],
      setupInstructions: [
        'ضع يديك على الأرض أوسع قليلاً من الكتفين وجسمك كالمسطرة.',
      ],
      executionInstructions: [
        'انزل بالصدر حتى يقترب من الأرض مع زاوية كوع 45 درجة.',
        'ادفع الأرض بقوة للعودة للاستقامة الكاملة.',
      ],
      breathingInstructions: 'شهيق عند الهبوط وزفير عند الدفع للأعلى.',
      commonMistakes: ['ارتخاء الحوض وسقوطه باتجاه الأرض.'],
      coachTip: 'شد عضلات البطن والمؤخرة ليكون جسمك كلوح خشبي صلب.',
      hypertrophyRepRange: '12 - 25 تكرار',
      strengthRepRange: 'بوزن إضافي 8 - 12 تكرار',
      tempo: '2-0-1-0',
    ),
    'plank': const ExerciseGuide(
      slug: 'plank',
      title: 'تمرين البلانك (الاستقرار الجذعي)',
      primaryMuscles: ['عضلات البطن العميقة والمستقيمة'],
      secondaryMuscles: ['الجلوتس', 'عضلات الظهر'],
      setupInstructions: [
        'استند على الساعدين وأطراف أصابع القدمين مع كوعين تحت الكتفين.',
      ],
      executionInstructions: [
        'اضبط الحوض لإلغاء أي تقوس في أسفل الظهر.',
        'شد عضلات البطن والمؤخرة بأقصى قوة وحافظ على الوضعية بثبات.',
      ],
      breathingInstructions: 'تنفس هادئ ومنتظم دون إرخاء عضلات البطن.',
      commonMistakes: ['رفع الحوض عالياً أو تركه يسقط للأسفل.'],
      coachTip: 'اسحب كوعيك باتجاه أصابع قدميك دون حركة لتضاعف تفعيل البطن.',
      hypertrophyRepRange: '3 جولات من 45 إلى 90 ثانية',
      strengthRepRange: 'بوزن 3 جولات 30-45 ثانية',
      tempo: 'ثابت',
    ),
    'hanging_leg_raise': const ExerciseGuide(
      slug: 'hanging_leg_raise',
      title: 'رفع الأرجل معلقاً',
      primaryMuscles: ['أسفل البطن'],
      secondaryMuscles: ['عضلات الحوض', 'القبضة'],
      setupInstructions: ['تعلق على العارضة بذراعين ممدودتين وثبّت التأرجح.'],
      executionInstructions: [
        'ابدأ بلف الحوض للأعلى وللأمام لرفع الساقين.',
        'ارفع حتى مستوى أفقي على الأقل واثبت ثانية.',
        'انزل ببطء وتحكم دون استخدام الاندفاع.',
      ],
      breathingInstructions: 'زفير عند الرفع وشهيق عند النزول.',
      commonMistakes: ['التأرجح بالجسد للأمام والخلف.'],
      coachTip:
          'السر في التمرين ليس مجرد رفع القدمين، بل تدوير الحوض للأعلى نحو سرتك.',
      hypertrophyRepRange: '10 - 15 تكرار',
      strengthRepRange: '12 - 20 تكرار',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/hanging_leg_raise.svg',
    ),
    'dips': const ExerciseGuide(
      slug: 'dips',
      title: 'تمرين المتوازي للصدر والترايسبس (Dips)',
      primaryMuscles: ['الصدر السفلي', 'الترايسبس'],
      secondaryMuscles: ['الكتف الأمامي'],
      setupInstructions: [
        'ارتكز على قضبان المتوازي بذراعين ممدودتين مع خفض الأكتاف للأسفل.',
        'أمل الجذع للأمام قليلاً (20-30 درجة) لاستهداف الصدر أو ابقَ مستقيماً للترايسبس.',
      ],
      executionInstructions: [
        'انزل بتحكم حتى يصل الكتف لمستوى الكوع (زاوية 90 درجة).',
        'ادفع بقوة للأعلى حتى استقامة الذراعين دون رفع الكتفين نحو الأذنين.',
      ],
      breathingInstructions: 'شهيق أثناء النزول وزفير عند الدفع للأعلى.',
      commonMistakes: ['النزول المفرط فوق مرونة الكتف أو رفع الأكتاف للأعلى.'],
      coachTip:
          'حافظ على ثبات لوحي الكتف للأسفل طوال المجموعة لحماية مفصل الكتف.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '5 - 8 تكرارات بوزن إضافي',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dips.svg',
    ),
    'cable_fly': const ExerciseGuide(
      slug: 'cable_fly',
      title: 'تفتيح صدر بالكيبل',
      primaryMuscles: ['عضلات الصدر (الألياف الوسطى والداخلية)'],
      secondaryMuscles: ['الكتف الأمامي'],
      setupInstructions: [
        'اضبط البكرتين بمستوى الكتف وتقدم خطوة للأمام لتحقيق التوازن والشد المبدئي.',
      ],
      executionInstructions: [
        'اجمع المقبضين أمام صدرك في مسار قوسي واسع مع ثبات زاوية الكوع.',
        'اعصر عضلة الصدر لثانية كاملة ثم ارجع ببطء.',
      ],
      breathingInstructions: 'شهيق عند فتح الذراعين وزفير عند ضمهما.',
      commonMistakes: [
        'ثني الكوعين كثيراً وتحويل التمرين إلى ضغط بدلاً من التفتيح.',
      ],
      coachTip:
          'ركز على تقريب الكوعين من بعضهما لتفعيل ألياف الصدر بأقصى درجة.',
      hypertrophyRepRange: '12 - 15 تكرار',
      strengthRepRange: '10 - 12 تكرار',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/cable_fly.svg',
    ),
    'chin_up': const ExerciseGuide(
      slug: 'chin_up',
      title: 'عقلة قبضة معكوسة (Chin-Up)',
      primaryMuscles: ['المجنص (اللاتس)', 'البايسبس'],
      secondaryMuscles: ['وسط الظهر', 'الجذع'],
      setupInstructions: [
        'أمسك البار بقبضة باتساع الكتفين بحيث تكون راحتا اليدين باتجاه وجهك.',
      ],
      executionInstructions: [
        'اخفض لوحي الكتف واسحب صدرك نحو البار مع إبقاء الكوعين قريبين من الجسم.',
        'تجاوز البار بذقنك ثم انزل ببطء حتى الامتداد الكامل للذراعين.',
      ],
      breathingInstructions: 'شهيق في الأسفل وزفير أثناء السحب للأعلى.',
      commonMistakes: ['عدم النزول الكامل في نهاية كل تكرار.'],
      coachTip:
          'القبضة المعكوسة تمنحك أقوى تفعيل مشترك للظهر والبايسبس مع مدى حركي كبير.',
      hypertrophyRepRange: '6 - 12 تكرار',
      strengthRepRange: '3 - 6 تكرارات بوزن إضافي',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/chin_up.svg',
    ),
    'dumbbell_row': const ExerciseGuide(
      slug: 'dumbbell_row',
      title: 'سحب دامبل فردي للظهر (منشار)',
      primaryMuscles: ['المجنص (اللاتس)', 'وسط الظهر'],
      secondaryMuscles: ['الكتف الخلفي', 'البايسبس'],
      setupInstructions: [
        'ارتكز بيدك على مقعد مع الحفاظ على استقامة الظهر موازياً للأرض.',
      ],
      executionInstructions: [
        'اسحب الدامبل في مسار قوسي باتجاه مفصل الحوض وليس باتجاه الكتف.',
        'اثبت في الأعلى لنصف ثانية ثم أنزل الوزن بتحكم لإطالة الظهر.',
      ],
      breathingInstructions: 'شهيق عند النزول وزفير عند السحب نحو الحوض.',
      commonMistakes: ['لف الجذع المفرط أو السحب بالبايسبس نحو الكتف.'],
      coachTip: 'وجّه كوعك للخلف نحو جيب بنطالك الخلفي لعزل عضلة المجنص.',
      hypertrophyRepRange: '8 - 12 تكرار لكل ذراع',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-1-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_row.svg',
    ),
    'seated_cable_row': const ExerciseGuide(
      slug: 'seated_cable_row',
      title: 'سحب أرضي جالس بالكيبل',
      primaryMuscles: ['وسط الظهر (الرومبويدز والترابيز)', 'المجنص'],
      secondaryMuscles: ['البايسبس', 'أسفل الظهر'],
      setupInstructions: [
        'اجلس بظهر مستقيم وقدمين ثابتتين على المسند مع ثنية خفيفة في الركبتين.',
      ],
      executionInstructions: [
        'اسحب المقبض باتجاه السرة مع ضم لوحي الكتف بقوة للخلف.',
        'اثبت ثانية واحدة ثم ارجع للأمام بتحكم دون تقويس أسفل الظهر.',
      ],
      breathingInstructions: 'شهيق عند مد الذراعين وزفير عند السحب للبطن.',
      commonMistakes: ['التأرجح بالظهر للأمام والخلف لرفع الوزن.'],
      coachTip: 'ابدأ الحركة بإرجاع الكتفين للخلف قبل ثني الكوعين.',
      hypertrophyRepRange: '10 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/seated_cable_row.svg',
    ),
    'lunges': const ExerciseGuide(
      slug: 'lunges',
      title: 'طعن المشي بالدامبلز (Lunges)',
      primaryMuscles: ['الفخذ الأمامي (الكوادس)', 'الجلوتس'],
      secondaryMuscles: ['الفخذ الخلفي', 'عضلات التوازن بالحوض'],
      setupInstructions: [
        'قف مستقيماً ممسكاً بالدامبلز بجانبي جسمك مع شد البطن.',
      ],
      executionInstructions: [
        'اخطُ للأمام واثنِ الركبتين لزاوية 90 درجة حتى تقترب الركبة الخلفية من الأرض.',
        'ادفع بكعب القدم الأمامية للنهوض والانتقال للخطوة التالية.',
      ],
      breathingInstructions: 'شهيق أثناء النزول وزفير عند الدفع للأعلى.',
      commonMistakes: ['انحراف الركبة الأمامية للداخل أثناء الصعود.'],
      coachTip:
          'الخطوة القصيرة تركز على الفخذ الأمامي، والخطوة الأوسع مع ميل بسيط تستهدف الجلوتس.',
      hypertrophyRepRange: '10 - 12 تكرار لكل رجل',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-0-1-0',
      assetIllustrationPath: 'assets/illustrations/lunges.svg',
    ),
    'hip_thrust': const ExerciseGuide(
      slug: 'hip_thrust',
      title: 'دفع الحوض بالبار (Hip Thrust)',
      primaryMuscles: ['عضلات المؤخرة (الجلوتس)'],
      secondaryMuscles: ['الفخذ الخلفي', 'عضلات الجذع'],
      setupInstructions: [
        'أسند أسفل لوحي الكتف على مقعد ثابت وضع البار المبطن فوق الحوض.',
        'اضبط مكان القدمين بحيث تكون الساقان عموديتين تماماً في أعلى نقطة.',
      ],
      executionInstructions: [
        'ادفع الأرض بالكعبين لرفع الحوض حتى يصبح الجسم في خط أفقي واحد.',
        'أبقِ الذقن مضموماً للصدر واعصر الجلوتس لمدة ثانية إلى ثانيتين في الأعلى.',
      ],
      breathingInstructions: 'شهيق عند النزول وزفير مع عصر العضلة في الأعلى.',
      commonMistakes: ['تقويس أسفل الظهر وإرجاع الرأس للخلف.'],
      coachTip:
          'ثبت نظرك للأمام طوال الحركة لحماية أسفل الظهر وعزل الجلوتس بالكامل.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '5 - 8 تكرارات',
      tempo: '2-1-1-1',
      assetIllustrationPath: 'assets/illustrations/hip_thrust.svg',
    ),
    'bulgarian_split_squat': const ExerciseGuide(
      slug: 'bulgarian_split_squat',
      title: 'سكوات بلغاري بالدامبلز',
      primaryMuscles: ['الفخذ الأمامي', 'الجلوتس'],
      secondaryMuscles: ['العضلات الضامة', 'توازن الحوض'],
      setupInstructions: [
        'ضع مشط القدم الخلفية على مقعد خلفك وتقدم بالقدم الأمامية خطوتين.',
      ],
      executionInstructions: [
        'انزل عمودياً على الرجل الأمامية بعمق كامل وتحكم.',
        'ادفع الأرض بالقدم الأمامية للعودة للأعلى مع إبقاء 85% من الوزن على الرجل الأمامية.',
      ],
      breathingInstructions: 'شهيق أثناء النزول وزفير عند الدفع للأعلى.',
      commonMistakes: ['الاعتماد على الرجل الخلفية في الدفع.'],
      coachTip:
          'الرجل الخلفية للتوازن فقط؛ اجعل كل التركيز والضغط على كعب ومنتصف القدم الأمامية.',
      hypertrophyRepRange: '8 - 12 تكرار لكل رجل',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/bulgarian_split_squat.svg',
    ),
    'leg_extension': const ExerciseGuide(
      slug: 'leg_extension',
      title: 'رفرفة أرجل أمامي بالجهاز',
      primaryMuscles: ['عضلات الفخذ الأمامية بالكامل'],
      secondaryMuscles: [],
      setupInstructions: [
        'اضبط مسند الظهر ليكون مفصل الركبة بمحاذاة محور دوران الجهاز تماماً.',
      ],
      executionInstructions: [
        'افرد الساقين بالكامل للأعلى واثبت ثانية واحدة مع عصر الفخذ الأمامي.',
        'انزل ببطء خلال 3 ثوانٍ دون ترك الأوزان ترتطم.',
      ],
      breathingInstructions: 'زفير عند فرد الرجلين وشهيق عند النزول.',
      commonMistakes: ['رفع الحوض عن المقعد أثناء التمرين.'],
      coachTip:
          'امسك المقابض الجانبية بقوة لتثبيت الحوض، وارفع أطراف الأصابع للأعلى لزيادة الانقباض.',
      hypertrophyRepRange: '12 - 15 تكرار',
      strengthRepRange: '8 - 10 تكرارات',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_extension.svg',
    ),
    'leg_curl': const ExerciseGuide(
      slug: 'leg_curl',
      title: 'ثني الأرجل الخلفي بالجهاز',
      primaryMuscles: ['الفخذ الخلفي (الهامسترنج)'],
      secondaryMuscles: ['السمانة'],
      setupInstructions: [
        'اضبط الوسادة فوق كعب القدم مباشرة مع محاذاة الركبة لمفصل الجهاز.',
      ],
      executionInstructions: [
        'اثنِ ركبتيك لأقصى مدى ممكن مع عصر الخلفيات لثانية واحدة.',
        'قاوم الوزن أثناء العودة ببطء لمدة 3 ثوانٍ.',
      ],
      breathingInstructions: 'زفير عند الثني وشهيق عند الفرد.',
      commonMistakes: ['تحريك الحوض وأسفل الظهر لرفع الوزن.'],
      coachTip:
          'التركيز على النزول البطيء يضاعف البناء العضلي ويحمي أوتار الركبة.',
      hypertrophyRepRange: '10 - 15 تكرار',
      strengthRepRange: '6 - 10 تكرارات',
      tempo: '3-0-1-1',
      assetIllustrationPath: 'assets/illustrations/leg_curl.svg',
    ),
    'calf_raise': const ExerciseGuide(
      slug: 'calf_raise',
      title: 'رفع السمانة واقفاً',
      primaryMuscles: ['عضلة السمانة (Gastrocnemius)'],
      secondaryMuscles: ['العضلة النعلية (Soleus)'],
      setupInstructions: [
        'ضع مقدمة القدم على الحافة مع إبقاء الركبتين مفرودتين دون قفل مفرط.',
      ],
      executionInstructions: [
        'انزل بالكعبين لأقصى تمدد بالأسفل وتوقف لمدة ثانيتين كاملتين.',
        'اصعد لأقصى ارتفاع على مشط القدم واعصر السمانة لثانية في الأعلى.',
      ],
      breathingInstructions: 'شهيق في التمدد بالأسفل وزفير عند الصعود.',
      commonMistakes: ['الأداء السريع والارتداد بوتر أكيلس دون توقف بالأسفل.'],
      coachTip:
          'التوقف ثانيتين في الأسفل يلغي الارتداد المطاطي للوتر ويجبر عضلة السمانة على العمل الفعلي.',
      hypertrophyRepRange: '12 - 20 تكرار',
      strengthRepRange: '8 - 12 تكرار',
      tempo: '2-2-1-1',
      assetIllustrationPath: 'assets/illustrations/calf_raise.svg',
    ),
    'dumbbell_shoulder_press': const ExerciseGuide(
      slug: 'dumbbell_shoulder_press',
      title: 'ضغط أكتاف جالس بالدامبلز',
      primaryMuscles: ['الكتف الأمامي والجانبي'],
      secondaryMuscles: ['الترايسبس', 'أعلى الترابيز'],
      setupInstructions: [
        'اضبط مسند المقعد على زاوية 75-80 درجة وقدم الكوعين للأمام قليلاً بزاوية 30 درجة.',
      ],
      executionInstructions: [
        'ادفع الدامبلز للأعلى حتى استقامة الذراعين دون صدمهما ببعضهما.',
        'انزل بتحكم حتى مستوى الأذنين.',
      ],
      breathingInstructions: 'شهيق عند النزول وزفير أثناء الدفع للأعلى.',
      commonMistakes: ['فتح الكوعين للخارج بزاوية 90 درجة كاملة.'],
      coachTip:
          'تقديم الكوعين 30 درجة للأمام يحمي مفصل الكتف ويمنحك قوة دفع أعلى.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/dumbbell_shoulder_press.svg',
    ),
    'face_pull': const ExerciseGuide(
      slug: 'face_pull',
      title: 'سحب الحبل للوجه (Face Pull)',
      primaryMuscles: ['الكتف الخلفي', 'عضلات الكفة المدورة للكتف'],
      secondaryMuscles: ['الترابيز الأوسط والسفلي'],
      setupInstructions: ['اضبط البكرة بمستوى الوجه وأمسك طرفي الحبل.'],
      executionInstructions: [
        'اسحب الحبل نحو الجبهة مع فتح اليدين للخارج وتدوير الكتف للخلف.',
        'اثبت ثانية واحدة في أقصى انقباض خلفي ثم ارجع ببطء.',
      ],
      breathingInstructions: 'زفير عند السحب للوجه وشهيق عند العودة.',
      commonMistakes: ['وضع وزن ثقيل جداً والسحب نحو الصدر بدلاً من الجبهة.'],
      coachTip:
          'اجعل معصميك ينتهيان خلف مستوى كوعيك لتفعيل الدوران الخارجي للكتف.',
      hypertrophyRepRange: '15 - 20 تكرار',
      strengthRepRange: '12 - 15 تكرار',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/face_pull.svg',
    ),
    'hammer_curl': const ExerciseGuide(
      slug: 'hammer_curl',
      title: 'كيرل مطرقة بالدامبلز (Hammer Curl)',
      primaryMuscles: ['عضلة الساعد العضدية (Brachioradialis)', 'البراكياليس'],
      secondaryMuscles: ['البايسبس'],
      setupInstructions: [
        'قف مستقيماً وأمسك الدامبلز بقبضة محايدة (الراحتان متقابلتان كالمطرقة).',
      ],
      executionInstructions: [
        'ارفع الوزن بثني الكوع فقط مع ثبات القبضة المحايدة.',
        'انزل ببطء وتحكم لمدة ثانيتين إلى 3 ثوانٍ.',
      ],
      breathingInstructions: 'زفير عند الرفع وشهيق عند النزول.',
      commonMistakes: ['التأرجح بالكتفين والجذع لرفع الوزن.'],
      coachTip: 'تمرين المطرقة أساسي لزيادة سماكة الذراع وقوة الساعد.',
      hypertrophyRepRange: '10 - 14 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '2-0-1-1',
      assetIllustrationPath: 'assets/illustrations/hammer_curl.svg',
    ),
    'incline_dumbbell_curl': const ExerciseGuide(
      slug: 'incline_dumbbell_curl',
      title: 'كيرل بايسبس على مقعد مائل',
      primaryMuscles: ['الرأس الطويل للبايسبس'],
      secondaryMuscles: ['الساعد'],
      setupInstructions: [
        'استلقِ على مقعد مائل بزاوية 45-60 درجة ودع ذراعيك تتدليان عمودياً خلف خط الجسم.',
      ],
      executionInstructions: [
        'اثنِ كوعيك لرفع الدامبلز مع إبقاء الكوع ثابتاً يشير للأرض.',
        'انزل بالكامل للشعور بأقصى استطالة في البايسبس.',
      ],
      breathingInstructions: 'شهيق عند النزول وزفير عند الرفع.',
      commonMistakes: ['تقديم الكوعين للأمام أثناء الرفع.'],
      coachTip:
          'الإطالة القصوى على المقعد المائل تستهدف قمة عضلة البايسبس بفعالية فائقة.',
      hypertrophyRepRange: '10 - 12 تكرار',
      strengthRepRange: '8 - 10 تكرارات',
      tempo: '3-1-1-0',
      assetIllustrationPath: 'assets/illustrations/incline_dumbbell_curl.svg',
    ),
    'overhead_triceps_extension': const ExerciseGuide(
      slug: 'overhead_triceps_extension',
      title: 'تمديد الترايسبس خلف الرأس بالكيبل',
      primaryMuscles: ['الرأس الطويل للترايسبس'],
      secondaryMuscles: ['الرأس الجانبي والداخلي للترايسبس'],
      setupInstructions: [
        'قف معطياً ظهرك للكيبل وارفع الكوعين بجانب الرأس مع شد البطن.',
      ],
      executionInstructions: [
        'دع الحبل ينزل خلف الرأس لإطالة الترايسبس بالكامل.',
        'افرد الساعدين للأعلى والأمام مع ثبات الكوعين تماماً.',
      ],
      breathingInstructions: 'شهيق خلف الرأس وزفير عند الفرد.',
      commonMistakes: ['تقويس الظهر بدلاً من تثبيت الجذع.'],
      coachTip:
          'رفع الذراع فوق الرأس هو الطريقة الوحيدة لإطالة الرأس الطويل للترايسبس بالكامل.',
      hypertrophyRepRange: '10 - 15 تكرار',
      strengthRepRange: '8 - 10 تكرارات',
      tempo: '3-1-1-0',
      assetIllustrationPath:
          'assets/illustrations/overhead_triceps_extension.svg',
    ),
    'skull_crusher': const ExerciseGuide(
      slug: 'skull_crusher',
      title: 'كسارة الجمجمة بالبار المتعرج (Skull Crusher)',
      primaryMuscles: ['الترايسبس بجميع رؤوسها'],
      secondaryMuscles: ['الساعد'],
      setupInstructions: [
        'استلقِ على مقعد مستوٍ وأمسك البار المتعرج بذراعين مائلتين قليلاً للخلف.',
      ],
      executionInstructions: [
        'اثنِ الكوعين فقط للنزول بالبار نحو الجبهة أو خلف أعلى الرأس قليلاً.',
        'ادفع بقوة للعودة لنقطة البداية مع الحفاظ على تقارب الكوعين.',
      ],
      breathingInstructions: 'شهيق عند النزول وزفير عند الفرد.',
      commonMistakes: ['فتح الكوعين للخارج أثناء النزول.'],
      coachTip:
          'النزول بالبار خلف الرأس قليلاً يحافظ على الشد المستمر ويريح مفصل الكوع.',
      hypertrophyRepRange: '8 - 12 تكرار',
      strengthRepRange: '6 - 8 تكرارات',
      tempo: '3-0-1-0',
      assetIllustrationPath: 'assets/illustrations/skull_crusher.svg',
    ),
    'cable_crunch': const ExerciseGuide(
      slug: 'cable_crunch',
      title: 'طحن البطن بالكيبل العالي',
      primaryMuscles: ['عضلات البطن المستقيمة'],
      secondaryMuscles: ['العضلات المائلة (الأوبليكس)'],
      setupInstructions: [
        'اركع على ركبتيك تحت البكرة العالية وأمسك الحبل بجانب رأسك.',
      ],
      executionInstructions: [
        'لف العمود الفقري لتقريب القفص الصدري من الحوض مع ثبات الفخذين.',
        'افرغ الهواء بالكامل في الأسفل ثم عد للأعلى ببطء فقرة تلو الأخرى.',
      ],
      breathingInstructions: 'شهيق في الأعلى وزفير عميق عند عصر البطن للأسفل.',
      commonMistakes: [
        'الجلوس بالمؤخرة على الكعبين بدلاً من ثني العمود الفقري.',
      ],
      coachTip:
          'ثبت مفصل الحوض في مكانه؛ الحركة تأتي فقط من تقريب الصدر نحو السرة.',
      hypertrophyRepRange: '12 - 15 تكرار',
      strengthRepRange: '8 - 12 تكرار',
      tempo: '2-0-1-2',
      assetIllustrationPath: 'assets/illustrations/cable_crunch.svg',
    ),
  };
}
