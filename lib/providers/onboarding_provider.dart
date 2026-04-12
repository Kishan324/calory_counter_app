import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';

class OnboardingProvider with ChangeNotifier {
  static const _keyIsFirstTime = 'isFirstTime';
  static const _keyPageIndex = 'onboarding_page_index';
  static const _keyGender = 'user_gender';
  static const _keyBirthDate = 'user_birthDate';
  static const _keyWeight = 'user_weight';
  static const _keyHeight = 'user_height';

  bool _isFirstTime = true;
  int _savedPageIndex = 0;
  UserModel? _userModel;

  bool get isFirstTime => _isFirstTime;
  int get savedPageIndex => _savedPageIndex;
  UserModel? get userModel => _userModel;

  OnboardingProvider() {
    _load();
  }

  // ignore: avoid_void_async
  void _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstTime = prefs.getBool(_keyIsFirstTime) ?? true;
    _savedPageIndex = prefs.getInt(_keyPageIndex) ?? 0;

    final gender = prefs.getString(_keyGender);
    final birthDateStr = prefs.getString(_keyBirthDate);
    final weight = prefs.getDouble(_keyWeight);
    final height = prefs.getDouble(_keyHeight);

    if (gender != null &&
        birthDateStr != null &&
        weight != null &&
        height != null) {
      _userModel = UserModel(
        gender: gender,
        birthDate: DateTime.parse(birthDateStr),
        weight: weight,
        height: height,
      );
    }
    notifyListeners();
  }

  // ignore: avoid_void_async
  void savePageIndex(int index) async {
    _savedPageIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPageIndex, index);
  }

  // ignore: avoid_void_async
  void saveUserData(UserModel user) async {
    _userModel = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGender, user.gender);
    await prefs.setString(_keyBirthDate, user.birthDate.toIso8601String());
    await prefs.setDouble(_keyWeight, user.weight);
    await prefs.setDouble(_keyHeight, user.height);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isFirstTime = false;
    _savedPageIndex = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstTime, false);
    await prefs.setInt(_keyPageIndex, 0);
    notifyListeners();
  }
}
