import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Premium gradient progress ring used by the rest chronometer.
///
/// Animates smoothly between values and supports RTL (the sweep direction is
/// mirrored so the ring "drains" in the reading direction).
class RestProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final List<Color> colors;
  final Widget? child;

  const RestProgressRing({
    super.key,
    required this.progress,
    required this.size,
    required this.colors,
    this.strokeWidth = 10,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _RingPainter(
              progress: value,
              strokeWidth: strokeWidth,
              colors: colors,
              mirror: isRtl,
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;
  final bool mirror;

  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
    required this.mirror,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = AppColors.surfaceElevated;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress * (mirror ? -1 : 1);
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [...colors, colors.first],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(rect);

    // Soft glow under the arc for depth.
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..color = colors.first.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawArc(rect, -math.pi / 2, sweep, false, glow);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.colors != colors ||
      old.mirror != mirror ||
      old.strokeWidth != strokeWidth;
}
