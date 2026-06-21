import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ──────────────────────────────────────────────
//  COLORS — cinematic dark: deep space · electric violet · cyan glow
// ──────────────────────────────────────────────
class AppColors {
  // Backgrounds
  static const bg        = Color(0xFF07071A);
  static const bgCard    = Color(0xFF0E0E2E);
  static const bgHover   = Color(0xFF13133A);

  // Primary accent — electric violet
  static const accent      = Color(0xFF7C3AED);
  static const accentLight = Color(0xFFA78BFA);
  static const accentGlow  = Color(0x667C3AED);

  // Secondary — cyan streaks
  static const cyan      = Color(0xFF06B6D4);
  static const cyanLight = Color(0xFF67E8F9);

  // Text
  static const textPrimary = Color(0xFFE8E8F8);
  static const textMuted   = Color(0xFF7272A0);
  static const textDim     = Color(0xFF3A3A5C);

  // Borders
  static const border      = Color(0x3D7C3AED);
  static const borderLight = Color(0x527C3AED);

  // Legacy aliases
  static const white = textPrimary;
  static const black = bg;
  static const muted = textMuted;

  static const gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, cyan],
  );

  static BoxDecoration glowBox({double radius = 16, Color? borderColor}) =>
      BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? border),
        boxShadow: [BoxShadow(color: accentGlow, blurRadius: 32, spreadRadius: -4)],
      );
}

// ──────────────────────────────────────────────
//  THEME
// ──────────────────────────────────────────────
class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.accent,
      secondary: AppColors.cyan,
      surface:   AppColors.bgCard,
      onPrimary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
      bodyColor:    AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgCard,
      hintStyle: const TextStyle(color: AppColors.textMuted),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accentLight),
      ),
    ),
    dividerColor: AppColors.border,
  );
}

// ──────────────────────────────────────────────
//  TEXT STYLES
// ──────────────────────────────────────────────
class AppText {
  static TextStyle display({Color color = AppColors.textPrimary, double? size}) =>
      TextStyle(
        fontFamily: 'Barlow',
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        fontSize: size ?? 64,
        color: color,
        height: 1.0,
        letterSpacing: -1.5,
      );

  static TextStyle heading({Color color = AppColors.textPrimary, double? size}) =>
      TextStyle(
        fontFamily: 'Barlow',
        fontWeight: FontWeight.w900,
        fontSize: size ?? 48,
        color: color,
        height: 1.05,
        letterSpacing: -1.0,
      );

  static TextStyle condensed({Color color = AppColors.textMuted, double? size}) =>
      TextStyle(
        fontFamily: 'BarlowCondensed',
        fontWeight: FontWeight.w700,
        fontSize: size ?? 11,
        color: color,
        letterSpacing: 2.0,
      );

  static TextStyle body({Color color = AppColors.textMuted, double? size}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size ?? 14,
        color: color,
        height: 1.8,
        fontWeight: FontWeight.w400,
      );

  /// Gradient shimmer text
  static Widget gradient(String text, TextStyle style) => ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [AppColors.accentLight, AppColors.cyan],
    ).createShader(bounds),
    child: Text(text, style: style.copyWith(color: Colors.white)),
  );
}

// ──────────────────────────────────────────────
//  SHARED WIDGETS
// ──────────────────────────────────────────────
class AppTag extends StatelessWidget {
  final String label;
  final Color? bg, fg;
  const AppTag(this.label, {super.key, this.bg, this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: bg ?? AppColors.accent.withOpacity(0.12),
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: AppText.condensed(color: fg ?? AppColors.accentLight, size: 9)),
  );
}

class GradientDivider extends StatelessWidget {
  final double height;
  const GradientDivider({super.key, this.height = 1});

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: const BoxDecoration(gradient: AppColors.gradientAccent),
  );
}

class GlowDot extends StatelessWidget {
  final double size;
  final Color color;
  const GlowDot({super.key, this.size = 8, this.color = AppColors.accent});

  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8, spreadRadius: 1)],
    ),
  );
}