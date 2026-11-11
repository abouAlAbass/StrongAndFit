import 'dart:async';
import 'package:flutter/material.dart';

/// Prototype/Showcase screen comparing 3 visual exercise explanation approaches
/// across 3 foundational movements in native Dark Mode.
///
/// 100% self-contained in a single file for easy A/B testing or removal.
class ExerciseDisplayShowcaseScreen extends StatefulWidget {
  const ExerciseDisplayShowcaseScreen({super.key});

  @override
  State<ExerciseDisplayShowcaseScreen> createState() =>
      _ExerciseDisplayShowcaseScreenState();
}

enum _DisplayMethod { all, methodA, methodB, methodC }

enum _MuscleRegion {
  pectorals,
  anteriorDelts,
  triceps,
  lats,
  traps,
  biceps,
  rearDelts,
}

class _ShowcaseExercise {
  final String id;
  final String titleFr;
  final String titleEn;
  final String startImageUrl;
  final String endImageUrl;
  final List<String> primaryLabels;
  final List<String> secondaryLabels;
  final Set<_MuscleRegion> primaryRegions;
  final Set<_MuscleRegion> secondaryRegions;
  final String setupCue;
  final String trajectoryCue;
  final String tempoCue;

  const _ShowcaseExercise({
    required this.id,
    required this.titleFr,
    required this.titleEn,
    required this.startImageUrl,
    required this.endImageUrl,
    required this.primaryLabels,
    required this.secondaryLabels,
    required this.primaryRegions,
    required this.secondaryRegions,
    required this.setupCue,
    required this.trajectoryCue,
    required this.tempoCue,
  });
}

const List<_ShowcaseExercise> _showcaseExercises = [
  _ShowcaseExercise(
    id: 'bench_press',
    titleFr: 'Développé couché',
    titleEn: 'Barbell Bench Press',
    startImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press_-_Medium_Grip/0.jpg',
    endImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bench_Press_-_Medium_Grip/1.jpg',
    primaryLabels: ['Pectoraux'],
    secondaryLabels: ['Deltoïde antérieur', 'Triceps'],
    primaryRegions: {_MuscleRegion.pectorals},
    secondaryRegions: {_MuscleRegion.anteriorDelts, _MuscleRegion.triceps},
    setupCue:
        'Omoplates rétractées et abaissées, pieds ancrés au sol, prise légèrement plus large que les épaules.',
    trajectoryCue:
        'Descente contrôlée vers le bas du sternum (coudes ~45°), poussée explosive vers l\'arrière au-dessus des épaules.',
    tempoCue:
        'Tempo 3-1-1-0 • Inspirez à la descente, bloquez en bas, expirez après le point critique.',
  ),
  _ShowcaseExercise(
    id: 'bent_over_row',
    titleFr: 'Rowing buste penché',
    titleEn: 'Barbell Bent-Over Row',
    startImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bent_Over_Row/0.jpg',
    endImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Barbell_Bent_Over_Row/1.jpg',
    primaryLabels: ['Grand dorsal', 'Trapèzes'],
    secondaryLabels: ['Biceps', 'Arrière d\'épaule'],
    primaryRegions: {_MuscleRegion.lats, _MuscleRegion.traps},
    secondaryRegions: {_MuscleRegion.biceps, _MuscleRegion.rearDelts},
    setupCue:
        'Buste incliné à ~45°, colonne neutre, abdominaux gainés, genoux légèrement fléchis.',
    trajectoryCue:
        'Tirez la barre vers le nombril en guidant par les coudes et en resserrant les omoplates en haut.',
    tempoCue:
        'Tempo 2-1-2-1 • Expirez au tirage, marquez 1s de contraction, retenez la descente.',
  ),
  _ShowcaseExercise(
    id: 'cable_fly',
    titleFr: 'Écarté à la poulie',
    titleEn: 'Cable Fly (Crossover)',
    startImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crossover/0.jpg',
    endImageUrl:
        'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/Cable_Crossover/1.jpg',
    primaryLabels: ['Pectoraux (isolation)'],
    secondaryLabels: [],
    primaryRegions: {_MuscleRegion.pectorals},
    secondaryRegions: {},
    setupCue:
        'Un pied avancé pour la stabilité, buste légèrement penché, coudes verrouillés à ~15° de flexion.',
    trajectoryCue:
        'Décrivez un grand arc circulaire en ramenant les poignées devant le bas des pectoraux sans plier davantage les coudes.',
    tempoCue:
        'Tempo 3-0-1-2 • Tension continue, squeeze maximal de 2s mains jointes.',
  ),
];

class _ExerciseDisplayShowcaseScreenState
    extends State<ExerciseDisplayShowcaseScreen> {
  int _selectedExerciseIndex = 0;
  _DisplayMethod _selectedMethod = _DisplayMethod.all;

  _ShowcaseExercise get _currentExercise =>
      _showcaseExercises[_selectedExerciseIndex];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF387BFF),
          surface: Color(0xFF1A1D24),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF16181D),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Labo Visuel Exercices',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'Prototype comparatif — Méthodes A, B & C',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
          children: [
            // 1. Exercise Selector Chips
            const Text(
              '1. Choisir un exercice test',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_showcaseExercises.length, (idx) {
                final ex = _showcaseExercises[idx];
                final isSelected = idx == _selectedExerciseIndex;
                return ChoiceChip(
                  label: Text(ex.titleFr),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => _selectedExerciseIndex = idx),
                  selectedColor: const Color(0xFF00E5FF).withAlpha(38),
                  backgroundColor: const Color(0xFF1E222A),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF00E5FF)
                        : const Color(0xFF2D3340),
                    width: isSelected ? 1.4 : 0.8,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF00E5FF)
                        : Colors.white70,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // 2. Method Tabs / Segmented Control
            const Text(
              '2. Mode d\'affichage',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<_DisplayMethod>(
              showSelectedIcon: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF387BFF).withAlpha(65);
                  }
                  return const Color(0xFF1E222A);
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF00E5FF);
                  }
                  return Colors.white70;
                }),
                side: WidgetStateProperty.all(
                  const BorderSide(color: Color(0xFF2D3340), width: 0.9),
                ),
              ),
              segments: const [
                ButtonSegment(
                  value: _DisplayMethod.all,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Tout', style: TextStyle(fontSize: 12)),
                  ),
                ),
                ButtonSegment(
                  value: _DisplayMethod.methodA,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('A · Diptyque', style: TextStyle(fontSize: 12)),
                  ),
                ),
                ButtonSegment(
                  value: _DisplayMethod.methodB,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('B · Anatomie', style: TextStyle(fontSize: 12)),
                  ),
                ),
                ButtonSegment(
                  value: _DisplayMethod.methodC,
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('C · Hybride', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
              selected: {_selectedMethod},
              onSelectionChanged: (set) {
                setState(() => _selectedMethod = set.first);
              },
            ),
            const SizedBox(height: 20),

            // 3. Render Selected Visualization(s)
            if (_selectedMethod == _DisplayMethod.all ||
                _selectedMethod == _DisplayMethod.methodA) ...[
              _MethodATwoPhaseDiptychCard(
                key: ValueKey('methodA_${_currentExercise.id}'),
                exercise: _currentExercise,
              ),
              const SizedBox(height: 18),
            ],
            if (_selectedMethod == _DisplayMethod.all ||
                _selectedMethod == _DisplayMethod.methodB) ...[
              _MethodBAnatomicalVectorCard(
                key: ValueKey('methodB_${_currentExercise.id}'),
                exercise: _currentExercise,
              ),
              const SizedBox(height: 18),
            ],
            if (_selectedMethod == _DisplayMethod.all ||
                _selectedMethod == _DisplayMethod.methodC) ...[
              _MethodCHybridProCard(
                key: ValueKey('methodC_${_currentExercise.id}'),
                exercise: _currentExercise,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// MÉTHODE A : Diptyque animé 2 phases (Start <-> End)
// =============================================================================
class _MethodATwoPhaseDiptychCard extends StatefulWidget {
  final _ShowcaseExercise exercise;

  const _MethodATwoPhaseDiptychCard({super.key, required this.exercise});

  @override
  State<_MethodATwoPhaseDiptychCard> createState() =>
      _MethodATwoPhaseDiptychCardState();
}

class _MethodATwoPhaseDiptychCardState
    extends State<_MethodATwoPhaseDiptychCard> {
  Timer? _timer;
  bool _isContractionPhase = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startCycleTimer();
  }

  void _startCycleTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (mounted && !_isPaused) {
        setState(() => _isContractionPhase = !_isContractionPhase);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeUrl = _isContractionPhase
        ? widget.exercise.endImageUrl
        : widget.exercise.startImageUrl;
    final badgeColor = _isContractionPhase
        ? const Color(0xFF10B981)
        : const Color(0xFF00E5FF);
    final phaseLabel = _isContractionPhase
        ? 'PHASE 2 : CONTRACTION'
        : 'PHASE 1 : DÉPART';

    return _ShowcaseCardShell(
      methodTag: 'MÉTHODE A',
      title: 'Diptyque animé 2 phases (Start ↔ End)',
      subtitle: 'Alternance automatique 1.2s • Source free-exercise-db',
      accentColor: const Color(0xFF00E5FF),
      trailing: IconButton(
        icon: Icon(
          _isPaused ? Icons.play_circle_fill : Icons.pause_circle_filled,
          color: const Color(0xFF00E5FF),
          size: 26,
        ),
        tooltip: _isPaused ? 'Reprendre' : 'Pause',
        onPressed: () => setState(() => _isPaused = !_isPaused),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 220,
              width: double.infinity,
              color: const Color(0xFF0F1115),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _OfflineSafeExerciseImage(
                      key: ValueKey(activeUrl),
                      url: activeUrl,
                      exerciseTitle: widget.exercise.titleFr,
                      isContraction: _isContractionPhase,
                    ),
                  ),
                  // Top-left dynamic phase badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212).withAlpha(215),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor, width: 1.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: badgeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            phaseLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: badgeColor,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom-right phase step dots
                  Positioned(
                    bottom: 10,
                    right: 12,
                    child: Row(
                      children: [
                        _phaseDot(active: !_isContractionPhase),
                        const SizedBox(width: 5),
                        _phaseDot(active: _isContractionPhase),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phaseDot({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 18 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF00E5FF) : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// =============================================================================
// MÉTHODE B : Schéma anatomique vectoriel dynamique (CustomPainter)
// =============================================================================
class _MethodBAnatomicalVectorCard extends StatefulWidget {
  final _ShowcaseExercise exercise;

  const _MethodBAnatomicalVectorCard({super.key, required this.exercise});

  @override
  State<_MethodBAnatomicalVectorCard> createState() =>
      _MethodBAnatomicalVectorCardState();
}

class _MethodBAnatomicalVectorCardState
    extends State<_MethodBAnatomicalVectorCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShowcaseCardShell(
      methodTag: 'MÉTHODE B',
      title: 'Schéma anatomique vectoriel (CustomPainter)',
      subtitle: '100 % hors-ligne • Pulsation dynamique des groupes ciblés',
      accentColor: const Color(0xFF387BFF),
      child: Column(
        children: [
          Container(
            height: 235,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1115),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF252A36), width: 0.9),
            ),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, _) {
                final pulse = 0.60 + (_pulseController.value * 0.40);
                return CustomPaint(
                  painter: _AnatomicalSilhouettePainter(
                    primaryRegions: widget.exercise.primaryRegions,
                    secondaryRegions: widget.exercise.secondaryRegions,
                    pulseIntensity: pulse,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendChip(
                color: const Color(0xFF00E5FF),
                label: 'Primaire : ${widget.exercise.primaryLabels.join(', ')}',
              ),
              if (widget.exercise.secondaryLabels.isNotEmpty) ...[
                const SizedBox(width: 10),
                _legendChip(
                  color: const Color(0xFF387BFF).withValues(alpha: 0.50),
                  label:
                      'Secondaire : ${widget.exercise.secondaryLabels.join(', ')}',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendChip({required Color color, required String label}) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2430),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2E3545), width: 0.7),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnatomicalSilhouettePainter extends CustomPainter {
  final Set<_MuscleRegion> primaryRegions;
  final Set<_MuscleRegion> secondaryRegions;
  final double pulseIntensity;

  const _AnatomicalSilhouettePainter({
    required this.primaryRegions,
    required this.secondaryRegions,
    required this.pulseIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw subtle blueprint grid background
    final gridPaint = Paint()
      ..color = const Color(0xFF1C212B)
      ..strokeWidth = 0.7;
    const gridStep = 24.0;
    for (double x = 0; x < size.width; x += gridStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw Front Silhouette (Left) & Back Silhouette (Right)
    final frontCenterX = size.width * 0.27;
    final backCenterX = size.width * 0.73;

    _drawLabels(canvas, frontCenterX, backCenterX, size.height);
    _drawBodyFrame(canvas, frontCenterX, size.height);
    _drawBodyFrame(canvas, backCenterX, size.height);

    // Front muscle overlays
    _paintFrontMuscles(canvas, frontCenterX, size.height);
    // Back muscle overlays
    _paintBackMuscles(canvas, backCenterX, size.height);
  }

  void _drawLabels(Canvas canvas, double frontX, double backX, double height) {
    void paintTag(String text, double cx) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
            letterSpacing: 1.1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx - tp.width / 2, height - 20));
    }

    paintTag('FACE (AVANT)', frontX);
    paintTag('DOS (ARRIÈRE)', backX);
  }

  void _drawBodyFrame(Canvas canvas, double cx, double height) {
    final bodyFill = Paint()
      ..color = const Color(0xFF191D26)
      ..style = PaintingStyle.fill;
    final bodyStroke = Paint()
      ..color = const Color(0xFF333B4D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Head
    canvas.drawCircle(Offset(cx, height * 0.13), 13, bodyFill);
    canvas.drawCircle(Offset(cx, height * 0.13), 13, bodyStroke);

    // Torso & Shoulders
    final torso = Path()
      ..moveTo(cx - 10, height * 0.20)
      ..lineTo(cx - 38, height * 0.26)
      ..lineTo(cx - 44, height * 0.50) // Left forearm outer
      ..lineTo(cx - 34, height * 0.51)
      ..lineTo(cx - 28, height * 0.35)
      ..lineTo(cx - 22, height * 0.62) // Waist left
      ..lineTo(cx - 24, height * 0.85) // Leg left
      ..lineTo(cx - 6, height * 0.85)
      ..lineTo(cx, height * 0.67)
      ..lineTo(cx + 6, height * 0.85) // Leg right
      ..lineTo(cx + 24, height * 0.85)
      ..lineTo(cx + 22, height * 0.62) // Waist right
      ..lineTo(cx + 28, height * 0.35)
      ..lineTo(cx + 34, height * 0.51)
      ..lineTo(cx + 44, height * 0.50) // Right forearm outer
      ..lineTo(cx + 38, height * 0.26)
      ..lineTo(cx + 10, height * 0.20)
      ..close();

    canvas.drawPath(torso, bodyFill);
    canvas.drawPath(torso, bodyStroke);
  }

  Paint? _paintForRegion(_MuscleRegion region) {
    final isPrimary = primaryRegions.contains(region);
    final isSecondary = secondaryRegions.contains(region);
    if (!isPrimary && !isSecondary) return null;

    if (isPrimary) {
      return Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: pulseIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3.5);
    }
    return Paint()
      ..color = const Color(
        0xFF387BFF,
      ).withValues(alpha: 0.50 * pulseIntensity);
  }

  void _paintFrontMuscles(Canvas canvas, double cx, double height) {
    // 1. Pectoraux (left & right chest)
    final pecPaint = _paintForRegion(_MuscleRegion.pectorals);
    if (pecPaint != null) {
      final leftPec = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 24, height * 0.26, 21, 18),
        const Radius.circular(6),
      );
      final rightPec = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 3, height * 0.26, 21, 18),
        const Radius.circular(6),
      );
      canvas.drawRRect(leftPec, pecPaint);
      canvas.drawRRect(rightPec, pecPaint);
    }

    // 2. Deltoïdes antérieurs
    final deltPaint = _paintForRegion(_MuscleRegion.anteriorDelts);
    if (deltPaint != null) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - 31, height * 0.28),
          width: 13,
          height: 15,
        ),
        deltPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + 31, height * 0.28),
          width: 13,
          height: 15,
        ),
        deltPaint,
      );
    }

    // 3. Biceps
    final bicepsPaint = _paintForRegion(_MuscleRegion.biceps);
    if (bicepsPaint != null) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - 35, height * 0.39),
          width: 10,
          height: 20,
        ),
        bicepsPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + 35, height * 0.39),
          width: 10,
          height: 20,
        ),
        bicepsPaint,
      );
    }
  }

  void _paintBackMuscles(Canvas canvas, double cx, double height) {
    // 1. Trapèzes (diamond shape upper back)
    final trapsPaint = _paintForRegion(_MuscleRegion.traps);
    if (trapsPaint != null) {
      final traps = Path()
        ..moveTo(cx, height * 0.20)
        ..lineTo(cx - 20, height * 0.27)
        ..lineTo(cx, height * 0.42)
        ..lineTo(cx + 20, height * 0.27)
        ..close();
      canvas.drawPath(traps, trapsPaint);
    }

    // 2. Grand dorsal (Lats V-taper)
    final latsPaint = _paintForRegion(_MuscleRegion.lats);
    if (latsPaint != null) {
      final leftLat = Path()
        ..moveTo(cx - 25, height * 0.32)
        ..lineTo(cx - 4, height * 0.38)
        ..lineTo(cx - 17, height * 0.56)
        ..lineTo(cx - 23, height * 0.46)
        ..close();
      final rightLat = Path()
        ..moveTo(cx + 25, height * 0.32)
        ..lineTo(cx + 4, height * 0.38)
        ..lineTo(cx + 17, height * 0.56)
        ..lineTo(cx + 23, height * 0.46)
        ..close();
      canvas.drawPath(leftLat, latsPaint);
      canvas.drawPath(rightLat, latsPaint);
    }

    // 3. Arrière d'épaule (Rear Delts)
    final rearDeltPaint = _paintForRegion(_MuscleRegion.rearDelts);
    if (rearDeltPaint != null) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - 31, height * 0.28),
          width: 13,
          height: 14,
        ),
        rearDeltPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + 31, height * 0.28),
          width: 13,
          height: 14,
        ),
        rearDeltPaint,
      );
    }

    // 4. Triceps
    final tricepsPaint = _paintForRegion(_MuscleRegion.triceps);
    if (tricepsPaint != null) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - 35, height * 0.39),
          width: 10,
          height: 20,
        ),
        tricepsPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx + 35, height * 0.39),
          width: 10,
          height: 20,
        ),
        tricepsPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnatomicalSilhouettePainter oldDelegate) {
    return oldDelegate.pulseIntensity != pulseIntensity ||
        oldDelegate.primaryRegions != primaryRegions ||
        oldDelegate.secondaryRegions != secondaryRegions;
  }
}

// =============================================================================
// MÉTHODE C : Carte Hybride Minimaliste (Fiche Pro Workout + Slider)
// =============================================================================
class _MethodCHybridProCard extends StatefulWidget {
  final _ShowcaseExercise exercise;

  const _MethodCHybridProCard({super.key, required this.exercise});

  @override
  State<_MethodCHybridProCard> createState() => _MethodCHybridProCardState();
}

class _MethodCHybridProCardState extends State<_MethodCHybridProCard> {
  double _trajectoryProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    final pct = (_trajectoryProgress * 100).round();
    final phaseTitle = pct < 30
        ? 'Départ (Étirement)'
        : (pct < 75 ? 'Trajectoire (Concentrique)' : 'Pic de contraction');

    return _ShowcaseCardShell(
      methodTag: 'MÉTHODE C',
      title: 'Carte Hybride Minimaliste (Fiche Pro)',
      subtitle: 'Miniature interactive + biomécanique actionnable',
      accentColor: const Color(0xFF10B981),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top compact row: Interactive cross-fade thumbnail + Muscle badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 112,
                  height: 92,
                  color: const Color(0xFF0F1115),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _OfflineSafeExerciseImage(
                        url: widget.exercise.startImageUrl,
                        exerciseTitle: widget.exercise.titleFr,
                        isContraction: false,
                        compact: true,
                      ),
                      Opacity(
                        opacity: _trajectoryProgress.clamp(0.0, 1.0),
                        child: _OfflineSafeExerciseImage(
                          url: widget.exercise.endImageUrl,
                          exerciseTitle: widget.exercise.titleFr,
                          isContraction: true,
                          compact: true,
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(190),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '$pct%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.exercise.titleEn,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...widget.exercise.primaryLabels.map(
                          (m) => _musclePill(m, isPrimary: true),
                        ),
                        ...widget.exercise.secondaryLabels.map(
                          (m) => _musclePill(m, isPrimary: false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3 Biomechanical cues
          _cueRow(
            icon: Icons.accessibility_new_rounded,
            color: const Color(0xFF00E5FF),
            label: 'SETUP',
            text: widget.exercise.setupCue,
          ),
          const SizedBox(height: 8),
          _cueRow(
            icon: Icons.route_rounded,
            color: const Color(0xFF387BFF),
            label: 'TRAJECTOIRE',
            text: widget.exercise.trajectoryCue,
          ),
          const SizedBox(height: 8),
          _cueRow(
            icon: Icons.air_rounded,
            color: const Color(0xFF10B981),
            label: 'RESPIRATION & TEMPO',
            text: widget.exercise.tempoCue,
          ),
          const SizedBox(height: 14),

          // Interactive Trajectory Scrubber Slider
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1115),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF252A36), width: 0.8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Inspecteur manuel',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        phaseTitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF10B981),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF10B981),
                    inactiveTrackColor: const Color(0xFF2B313F),
                    thumbColor: const Color(0xFF00E5FF),
                    overlayColor: const Color(0xFF00E5FF).withAlpha(40),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _trajectoryProgress,
                    onChanged: (val) =>
                        setState(() => _trajectoryProgress = val),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _musclePill(String text, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFF00E5FF).withAlpha(28)
            : const Color(0xFF252A36),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPrimary ? const Color(0xFF00E5FF) : const Color(0xFF394152),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: isPrimary ? const Color(0xFF00E5FF) : Colors.white70,
        ),
      ),
    );
  }

  Widget _cueRow({
    required IconData icon,
    required Color color,
    required String label,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withAlpha(28),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SHARED UI HELPERS (100% self-contained)
// =============================================================================
class _ShowcaseCardShell extends StatelessWidget {
  final String methodTag;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget child;
  final Widget? trailing;

  const _ShowcaseCardShell({
    required this.methodTag,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentColor.withAlpha(110), width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha(32),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        methodTag,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _OfflineSafeExerciseImage extends StatelessWidget {
  final String url;
  final String exerciseTitle;
  final bool isContraction;
  final bool compact;

  const _OfflineSafeExerciseImage({
    super.key,
    required this.url,
    required this.exerciseTitle,
    required this.isContraction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: compact ? 20 : 28,
            height: compact ? 20 : 28,
            child: const CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Color(0xFF00E5FF),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF14171F),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isContraction
                    ? Icons.fitness_center_rounded
                    : Icons.accessibility_new_rounded,
                size: compact ? 26 : 42,
                color: isContraction
                    ? const Color(0xFF10B981)
                    : const Color(0xFF00E5FF),
              ),
              if (!compact) ...[
                const SizedBox(height: 10),
                Text(
                  '$exerciseTitle — ${isContraction ? "Contraction" : "Départ"}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Aperçu hors-ligne (GitHub Raw inaccessible)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
