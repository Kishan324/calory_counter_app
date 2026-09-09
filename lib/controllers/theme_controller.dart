import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_storage_keys.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/haptic_helper.dart';
import '../core/utils/toast_helper.dart';

enum AppThemeType { system, light, dark, mint, berry, sunset, ocean }

/// Manages application theme selection and persistence using GetX.
class ThemeController extends GetxController with WidgetsBindingObserver {
  final Rx<AppThemeType> _themeType = AppThemeType.system.obs;

  AppThemeType get themeType => _themeType.value;

  ThemeController({String? initialTheme}) {
    if (initialTheme != null) {
      _themeType.value = AppThemeType.values.firstWhere(
        (e) => e.name == initialTheme,
        orElse: () => AppThemeType.system,
      );
    } else {
      _loadThemeType();
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    // Ensure the GetMaterialApp root is synchronized with the saved theme on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.changeThemeMode(themeMode);
      Get.changeTheme(themeData);
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeType.value == AppThemeType.system) {
      _themeType.refresh();
      Get.changeTheme(themeData);
    }
  }

  Future<void> _loadThemeType() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(AppStorageKeys.appThemeType);
    if (stored != null) {
      _themeType.value = AppThemeType.values.firstWhere(
        (e) => e.name == stored,
        orElse: () => AppThemeType.system,
      );
    }
  }

  Future<void> setThemeType(AppThemeType type) async {
    HapticHelper.selectionClick();

    _themeType.value = type;

    Get.changeThemeMode(themeMode);
    Get.changeTheme(themeData);

    final prefs = await SharedPreferences.getInstance();
    if (type == AppThemeType.system) {
      await prefs.remove(AppStorageKeys.appThemeType);
    } else {
      await prefs.setString(AppStorageKeys.appThemeType, type.name);
    }

    ToastHelper.showSuccess(
      "Theme updated successfully",
      title: "Appearance",
    );
  }


  ThemeMode get themeMode {
    if (_themeType.value == AppThemeType.system) return ThemeMode.system;
    if (_themeType.value == AppThemeType.dark) return ThemeMode.dark;
    return ThemeMode.light;
  }

  ThemeData get themeData {
    switch (_themeType.value) {
      case AppThemeType.dark:
        return AppTheme.darkTheme;
      case AppThemeType.mint:
        return AppTheme.mintTheme;
      case AppThemeType.berry:
        return AppTheme.berryTheme;
      case AppThemeType.sunset:
        return AppTheme.sunsetTheme;
      case AppThemeType.ocean:
        return AppTheme.oceanTheme;
      case AppThemeType.light:
        return AppTheme.lightTheme;
      case AppThemeType.system:
        final isPlatformDark =
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark;
        return isPlatformDark ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }

  ThemeData get darkThemeData {
    if (_themeType.value == AppThemeType.system || _themeType.value == AppThemeType.dark) {
      return AppTheme.darkTheme;
    }
    return themeData;
  }

  bool get isDarkMode {
    if (_themeType.value == AppThemeType.dark) return true;
    if (_themeType.value == AppThemeType.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return themeData.brightness == Brightness.dark;
  }
}
