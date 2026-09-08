import 'package:flutter/services.dart';

/// Centralized global helper for tactile haptic feedback across the application.
class HapticHelper {
  /// Subtle light impact feedback for general button presses, tabs, and interactive pills.
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Medium impact feedback for key user actions (e.g. logging food, saving settings).
  static Future<void> mediumImpact() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  /// Heavy impact feedback for major milestones and goal completions.
  static Future<void> heavyImpact() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Selection click feedback for picker changes, theme switches, and timeframe toggles.
  static Future<void> selectionClick() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  /// Success vibration sequence for successful goal achievement or scan completed.
  static Future<void> success() async {
    try {
      await HapticFeedback.vibrate();
    } catch (_) {}
  }
}
