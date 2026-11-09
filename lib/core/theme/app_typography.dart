import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography configuration designed for high legibility, athletic metrics, and Arabic RTL rendering.
/// Provides default text styles as well as context-aware builders for dynamic Light/Dark resolution.
class AppTypography {
  AppTypography._();

  // Dark defaults (static constants for backwards compatibility)
  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
  );

  static const TextStyle metricLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle metricMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle metricSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // Dynamic Theme Resolvers
  static TextStyle ofDisplay(BuildContext context) =>
      display.copyWith(color: AppColors.ofTextPrimary(context));

  static TextStyle ofTitleLarge(BuildContext context) =>
      titleLarge.copyWith(color: AppColors.ofTextPrimary(context));

  static TextStyle ofTitleMedium(BuildContext context) =>
      titleMedium.copyWith(color: AppColors.ofTextPrimary(context));

  static TextStyle ofBody(BuildContext context) =>
      body.copyWith(color: AppColors.ofTextPrimary(context));

  static TextStyle ofBodySecondary(BuildContext context) =>
      bodySecondary.copyWith(color: AppColors.ofTextSecondary(context));

  static TextStyle ofCaption(BuildContext context) =>
      caption.copyWith(color: AppColors.ofTextTertiary(context));

  static TextStyle ofMetricLarge(BuildContext context) =>
      metricLarge.copyWith(color: AppColors.ofTextPrimary(context));

  static TextStyle ofMetricMedium(BuildContext context) =>
      metricMedium.copyWith(color: AppColors.ofTextPrimary(context));
}
