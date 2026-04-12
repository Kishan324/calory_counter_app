import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_theme.dart';

enum AppThemeType { system, light, dark, mint, berry, sunset, ocean }

class ThemeProvider with ChangeNotifier {
  AppThemeType _themeType = AppThemeType.system;

  AppThemeType get themeType => _themeType;

  ThemeProvider({String? initialTheme}) {
    if (initialTheme != null) {
      _themeType = AppThemeType.values.firstWhere(
        (e) => e.name == initialTheme,
        orElse: () => AppThemeType.system,
      );
    } else {
      _loadThemeType();
    }
  }

  Future<void> _loadThemeType() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('appThemeType');
    if (stored != null) {
      _themeType = AppThemeType.values.firstWhere(
        (e) => e.name == stored,
        orElse: () => AppThemeType.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeType(AppThemeType type) async {
    if (_themeType == type) return;
    _themeType = type;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (type == AppThemeType.system) {
      await prefs.remove('appThemeType');
    } else {
      await prefs.setString('appThemeType', type.name);
    }
  }

  ThemeMode get themeMode {
    if (_themeType == AppThemeType.system) return ThemeMode.system;
    if (_themeType == AppThemeType.dark) return ThemeMode.dark;
    return ThemeMode.light; 
  }

  ThemeData get themeData {
    switch (_themeType) {
      case AppThemeType.mint: return AppTheme.mintTheme;
      case AppThemeType.berry: return AppTheme.berryTheme;
      case AppThemeType.sunset: return AppTheme.sunsetTheme;
      case AppThemeType.ocean: return AppTheme.oceanTheme;
      case AppThemeType.light:
      case AppThemeType.system:
      default:
        return AppTheme.lightTheme;
    }
  }

  ThemeData get darkThemeData {
    if (_themeType == AppThemeType.system || _themeType == AppThemeType.dark) {
      return AppTheme.darkTheme;
    }
    return themeData;
  }
}
