import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized ThemeData configuration using AppColors design system tokens.
class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bgLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        onSurfaceVariant: AppColors.textSubLight,
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        scaffoldBackgroundColor: AppColors.bgDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textMainDark,
        onSurfaceVariant: AppColors.textSubDark,
      );

  static ThemeData get mintTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.mintPrimary,
        scaffoldBackgroundColor: AppColors.mintBg,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        onSurfaceVariant: AppColors.textSubLight,
      );

  static ThemeData get berryTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.berryPrimary,
        scaffoldBackgroundColor: AppColors.berryBg,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        onSurfaceVariant: AppColors.textSubLight,
      );

  static ThemeData get sunsetTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.sunsetPrimary,
        scaffoldBackgroundColor: AppColors.sunsetBg,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        onSurfaceVariant: AppColors.textSubLight,
      );

  static ThemeData get oceanTheme => _buildTheme(
        brightness: Brightness.light,
        primary: AppColors.oceanPrimary,
        scaffoldBackgroundColor: AppColors.oceanBg,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textMainLight,
        onSurfaceVariant: AppColors.textSubLight,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color scaffoldBackgroundColor,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    final baseTextTheme = ThemeData(brightness: brightness).textTheme;
    final googleTextTheme = GoogleFonts.interTextTheme(baseTextTheme);

    return ThemeData(
      brightness: brightness,
      primaryColor: primary,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: AppColors.white,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.transparent,
        backgroundColor: AppColors.transparent,
      ),
      textTheme: googleTextTheme.copyWith(
        headlineLarge: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: -0.3),
        headlineSmall: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: onSurface),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        titleSmall: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: onSurface),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceVariant),
        labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        labelSmall: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: onSurface, letterSpacing: -1.0),
        displayMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.accent),
        displaySmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: onSurface),
      ),
    );
  }
}
