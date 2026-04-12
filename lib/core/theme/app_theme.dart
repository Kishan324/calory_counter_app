import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color _primary = Color(0xFF2E6B4F); // Darker rich green for light mode
  static const Color _primaryDark = Color(0xFF4DB6AC); // Softer teal-green for dark mode
  static const Color _accent = Color(0xFFFF7043);

  static ThemeData get lightTheme => _buildTheme(
        brightness: Brightness.light,
        primary: _primary,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        surface: Colors.white,
        onSurface: const Color(0xFF141414),
        onSurfaceVariant: const Color(0xFF757575),
      );

  static ThemeData get darkTheme => _buildTheme(
        brightness: Brightness.dark,
        primary: _primaryDark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        onSurface: const Color(0xFFEDEDED),
        onSurfaceVariant: const Color(0xFFA0A0A0),
      );

  static ThemeData get mintTheme => _buildTheme(
        brightness: Brightness.light,
        primary: const Color(0xFF00BFA5),
        scaffoldBackgroundColor: const Color(0xFFE0F2F1),
        surface: Colors.white,
        onSurface: const Color(0xFF141414),
        onSurfaceVariant: const Color(0xFF757575),
      );

  static ThemeData get berryTheme => _buildTheme(
        brightness: Brightness.light,
        primary: const Color(0xFFD81B60),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC),
        surface: Colors.white,
        onSurface: const Color(0xFF141414),
        onSurfaceVariant: const Color(0xFF757575),
      );

  static ThemeData get sunsetTheme => _buildTheme(
        brightness: Brightness.light,
        primary: const Color(0xFFFF6D00),
        scaffoldBackgroundColor: const Color(0xFFFFF3E0),
        surface: Colors.white,
        onSurface: const Color(0xFF141414),
        onSurfaceVariant: const Color(0xFF757575),
      );

  static ThemeData get oceanTheme => _buildTheme(
        brightness: Brightness.light,
        primary: const Color(0xFF1976D2),
        scaffoldBackgroundColor: const Color(0xFFE3F2FD),
        surface: Colors.white,
        onSurface: const Color(0xFF141414),
        onSurfaceVariant: const Color(0xFF757575),
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color scaffoldBackgroundColor,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: primary,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: _accent,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
      ),
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: -0.3),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: onSurface),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: onSurface),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceVariant),
        titleMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant),
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: onSurface, letterSpacing: -1.0),
        displayMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: _accent),
      ),
    );
  }
}
