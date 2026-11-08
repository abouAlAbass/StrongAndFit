import 'package:flutter/material.dart';

/// Context-aware color accessor providing semantic light/dark colors dynamically.
/// Backwards-compatible: static fields remain for dark mode as default constants.
class AppColors {
  AppColors._();

  // Dark Palette (Strong aesthetic)
  static const Color background = Color(0xFF0F0F12);
  static const Color surface = Color(0xFF18181D);
  static const Color surfaceElevated = Color(0xFF22222A);
  static const Color card = Color(0xFF1C1C22);
  static const Color inputBackground = Color(0xFF262630);

  // Dark Borders & Dividers
  static const Color border = Color(0xFF2E2E38);
  static const Color divider = Color(0xFF282832);

  // Accents & Brand (Consistent across modes)
  static const Color primary = Color(0xFF387BFF); // Strong electric blue
  static const Color primaryContainer = Color(0xFF1A3568);
  static const Color secondary = Color(0xFF00C7BE);

  // Functional & Set Status
  static const Color completed = Color(0xFF30D158); // Vivid success green
  static const Color completedContainer = Color(0xFF13381E);
  static const Color warmup = Color(0xFFFF9F0A); // Amber
  static const Color dropset = Color(0xFFBF5AF2); // Purple
  static const Color failure = Color(0xFFFF453A); // Crimson red
  static const Color error = Color(0xFFFF453A); // Crimson red error
  static const Color prGold = Color(0xFFFFD700); // Metallic trophy gold
  static const Color pending = Color(0xFF48484A);

  // Dark Text Hierarchy
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9898A0);
  static const Color textTertiary = Color(0xFF63636E);
  static const Color textPlaceholder = Color(0xFF4A4A55);

  // Light Palette
  static const Color lightBackground = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFEDF1F5);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightInputBackground = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFCBD5E1);
  static const Color lightDivider = Color(0xFFE2E8F0);
  static const Color lightPrimaryContainer = Color(0xFFDCE7FF);
  static const Color lightCompletedContainer = Color(0xFFDCF8E3);

  // Light Text Hierarchy (WCAG AA/AAA compliant high contrast)
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF334155);
  static const Color lightTextTertiary = Color(0xFF64748B);
  static const Color lightTextPlaceholder = Color(0xFF94A3B8);

  // Dynamic Theme Resolvers
  static Color ofBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? background : lightBackground;

  static Color ofSurface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surface : lightSurface;

  static Color ofSurfaceElevated(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? surfaceElevated : lightSurfaceElevated;

  static Color ofCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? card : lightCard;

  static Color ofInputBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? inputBackground : lightInputBackground;

  static Color ofBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? border : lightBorder;

  static Color ofDivider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? divider : lightDivider;

  static Color ofPrimaryContainer(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? primaryContainer : lightPrimaryContainer;

  static Color ofCompletedContainer(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? completedContainer : lightCompletedContainer;

  static Color ofTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPrimary : lightTextPrimary;

  static Color ofTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textSecondary : lightTextSecondary;

  static Color ofTextTertiary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textTertiary : lightTextTertiary;

  static Color ofTextPlaceholder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? textPlaceholder : lightTextPlaceholder;
}
