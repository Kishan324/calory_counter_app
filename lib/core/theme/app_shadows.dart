import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Centralized BoxShadow presets for consistent UI elevation across light and dark modes.
class AppShadows {
  static List<BoxShadow> card(bool isDark) => [
        BoxShadow(
          color: AppColors.black.withOpacity(isDark ? 0.3 : 0.03),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> cardSubtle(bool isDark) => [
        BoxShadow(
          color: AppColors.black.withOpacity(isDark ? 0.3 : 0.02),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> header(bool isDark) => [
        BoxShadow(
          color: AppColors.black.withOpacity(isDark ? 0.3 : 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> primaryButton(Color primaryColor) => [
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> glassButton(Color primaryColor) => [
        BoxShadow(
          color: primaryColor.withOpacity(0.4),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
