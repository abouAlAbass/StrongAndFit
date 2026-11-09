import 'package:flutter/material.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/l10n/generated/app_localizations_fr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/exercise_guide.dart';

/// Displays the visual demonstration or anatomical schematic for an [ExerciseGuide].
/// Attempts to load [ExerciseGuide.assetIllustrationPath] when present and gracefully
/// falls back to a high-contrast biomechanical vector diagram tailored to the exercise.
class ExerciseMediaViewer extends StatelessWidget {
  final ExerciseGuide guide;

  const ExerciseMediaViewer({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsFr();
    final assetPath = guide.assetIllustrationPath;

    return Container(
      height: 164,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.ofSurface(context),
            AppColors.ofPrimaryContainer(context).withValues(alpha: 0.35),
          ],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (assetPath != null && assetPath.isNotEmpty)
            Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  _BiomechanicalVectorFallback(guide: guide),
            )
          else
            _BiomechanicalVectorFallback(guide: guide),

          // Top-start badge: Biomechanical / Anatomical Illustration
          PositionedDirectional(
            top: 10,
            start: 12,
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.ofSurfaceElevated(
                  context,
                ).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.ofBorder(context),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.architecture_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.targetMuscles,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ofTextPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom-end badge: Primary muscle highlight
          if (guide.primaryMuscles.isNotEmpty)
            PositionedDirectional(
              bottom: 10,
              end: 12,
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  guide.primaryMuscles.first,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BiomechanicalVectorFallback extends StatelessWidget {
  final ExerciseGuide guide;

  const _BiomechanicalVectorFallback({required this.guide});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BiomechanicalSchematicPainter(
        slug: guide.slug,
        primaryColor: AppColors.primary,
        secondaryColor: AppColors.secondary,
        gridColor: AppColors.ofBorder(context).withValues(alpha: 0.35),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Icon(
                _iconForSlug(guide.slug),
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${guide.tempo} • ${guide.hypertrophyRepRange}',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.ofTextSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForSlug(String slug) {
    if (slug.contains('curl') || slug.contains('triceps') || slug == 'dips') {
      return Icons.sports_gymnastics_rounded;
    }
    if (slug.contains('squat') ||
        slug.contains('leg') ||
        slug.contains('lunge') ||
        slug.contains('calf') ||
        slug.contains('hip')) {
      return Icons.directions_run_rounded;
    }
    if (slug.contains('pull') ||
        slug.contains('row') ||
        slug.contains('chin') ||
        slug.contains('deadlift')) {
      return Icons.swap_vert_circle_outlined;
    }
    return Icons.fitness_center_rounded;
  }
}

class _BiomechanicalSchematicPainter extends CustomPainter {
  final String slug;
  final Color primaryColor;
  final Color secondaryColor;
  final Color gridColor;

  _BiomechanicalSchematicPainter({
    required this.slug,
    required this.primaryColor,
    required this.secondaryColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;

    // Subtle technical grid
    const step = 28.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Force-vector arc
    final arcPaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 120,
      height: 120,
    );
    canvas.drawArc(rect, -0.8, 1.6, false, arcPaint);
    canvas.drawArc(rect, 2.3, 1.6, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _BiomechanicalSchematicPainter oldDelegate) {
    return oldDelegate.slug != slug ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.gridColor != gridColor;
  }
}
