import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_storage_keys.dart';
import '../core/utils/toast_helper.dart';

/// Manages active localization and persistent language settings using GetX.
class LocaleController extends GetxController {
  final Rx<Locale> _locale = const Locale('en').obs;

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(AppStorageKeys.languageCode);
    if (savedLanguageCode != null) {
      _locale.value = Locale(savedLanguageCode);
      Get.updateLocale(_locale.value);
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale.value != newLocale) {
      _locale.value = newLocale;
      Get.updateLocale(newLocale);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStorageKeys.languageCode, newLocale.languageCode);

      ToastHelper.showSuccess(
        "Language updated successfully",
        title: "Preferences",
      );
    }
  }
}

