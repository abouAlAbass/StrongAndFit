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
    ),
  };
}
