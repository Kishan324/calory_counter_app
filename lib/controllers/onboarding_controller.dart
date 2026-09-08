import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_storage_keys.dart';
import '../core/theme/app_durations.dart';
import '../core/utils/toast_helper.dart';
import '../data/models/user_model.dart';
import '../presentation/screens/auth/auth_entry_screen.dart';

/// Manages onboarding slide index, persistent completion status, and user profile intake state.
class OnboardingController extends GetxController {
  late final PageController pageController;

  final RxBool isFirstTime = true.obs;
  final RxInt currentPage = 0.obs;
  final Rxn<UserModel> userModel = Rxn<UserModel>();

  final RxString selectedGender = ''.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final RxnString formError = RxnString();

  static const int totalPages = 5;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    weightController.addListener(() {
      if (formError.value != null) formError.value = null;
    });
    heightController.addListener(() {
      if (formError.value != null) formError.value = null;
    });
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstTime.value = prefs.getBool(AppStorageKeys.isFirstTime) ?? true;
    final savedIndex = prefs.getInt(AppStorageKeys.onboardingPageIndex) ?? 0;
    currentPage.value = savedIndex;

    if (pageController.hasClients) {
      pageController.jumpToPage(savedIndex);
    }

    final gender = prefs.getString(AppStorageKeys.userGender);
    final birthDateStr = prefs.getString(AppStorageKeys.userBirthDate);
    final weight = prefs.getDouble(AppStorageKeys.userWeight);
    final height = prefs.getDouble(AppStorageKeys.userHeight);

    if (gender != null &&
        birthDateStr != null &&
        weight != null &&
        height != null) {
      userModel.value = UserModel(
        gender: gender,
        birthDate: DateTime.parse(birthDateStr),
        weight: weight,
        height: height,
      );
      selectedGender.value = gender;
      selectedDate.value = DateTime.parse(birthDateStr);
      weightController.text = weight.toString();
      heightController.text = height.toString();
    } else {
      final defaultDate = DateTime.now().subtract(const Duration(days: 365 * 25));
      selectedGender.value = 'Male';
      selectedDate.value = defaultDate;
      weightController.text = '70';
      heightController.text = '170';
      userModel.value = UserModel(
        gender: 'Male',
        birthDate: defaultDate,
        weight: 70.0,
        height: 170.0,
      );
    }
  }

  bool get isUserInfoValid {
    if (selectedGender.value.isEmpty) return false;
    if (selectedDate.value == null) return false;
    final weight = double.tryParse(weightController.text.trim());
    if (weight == null || weight <= 0) return false;
    final height = double.tryParse(heightController.text.trim());
    if (height == null || height <= 0) return false;
    return true;
  }

  void onPageChanged(int index) {
    if (currentPage.value == 3 && index > 3) {
      if (!validateUserInfo(showToast: true)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (pageController.hasClients) {
            pageController.jumpToPage(3);
          }
          currentPage.value = 3;
        });
        return;
      }
    }

    currentPage.value = index;
    formError.value = null;
    savePageIndex(index);
  }

  Future<void> savePageIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppStorageKeys.onboardingPageIndex, index);
  }

  void setGender(String gender) {
    selectedGender.value = gender;
    formError.value = null;
  }

  void setBirthDate(DateTime date) {
    selectedDate.value = date;
    formError.value = null;
  }

  bool validateUserInfo({bool showToast = true}) {
    if (selectedGender.value.isEmpty) {
      formError.value = 'Please select your gender';
      if (showToast) {
        ToastHelper.showError(formError.value!, title: "Required Field");
      }
      return false;
    }
    if (selectedDate.value == null) {
      formError.value = 'Please select your birth date';
      if (showToast) {
        ToastHelper.showError(formError.value!, title: "Required Field");
      }
      return false;
    }
    final weight = double.tryParse(weightController.text.trim());
    if (weight == null || weight <= 0) {
      formError.value = 'Please enter a valid weight';
      if (showToast) {
        ToastHelper.showError(formError.value!, title: "Invalid Input");
      }
      return false;
    }
    final height = double.tryParse(heightController.text.trim());
    if (height == null || height <= 0) {
      formError.value = 'Please enter a valid height';
      if (showToast) {
        ToastHelper.showError(formError.value!, title: "Invalid Input");
      }
      return false;
    }

    formError.value = null;
    saveUserData(UserModel(
      gender: selectedGender.value,
      birthDate: selectedDate.value!,
      weight: weight,
      height: height,
    ));
    return true;
  }

  Future<void> saveUserData(UserModel user) async {
    userModel.value = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStorageKeys.userGender, user.gender);
    await prefs.setString(AppStorageKeys.userBirthDate, user.birthDate.toIso8601String());
    await prefs.setDouble(AppStorageKeys.userWeight, user.weight);
    await prefs.setDouble(AppStorageKeys.userHeight, user.height);
  }

  void nextPage() {
    if (currentPage.value == 3) {
      if (!validateUserInfo(showToast: true)) return;
    }

    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: AppDurations.medium,
        curve: Curves.easeInOutCubic,
      );
    } else {
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    if (userModel.value == null || !isUserInfoValid) {
      final defaultDate = DateTime.now().subtract(const Duration(days: 365 * 25));
      saveUserData(UserModel(
        gender: selectedGender.value.isNotEmpty ? selectedGender.value : 'Male',
        birthDate: selectedDate.value ?? defaultDate,
        weight: double.tryParse(weightController.text.trim()) ?? 70.0,
        height: double.tryParse(heightController.text.trim()) ?? 170.0,
      ));
    }
    completeOnboarding(isSkipping: true);
  }

  Future<void> completeOnboarding({bool isSkipping = false}) async {
    if (!isSkipping && currentPage.value == 3) {
      if (!validateUserInfo(showToast: true)) return;
    }

    isFirstTime.value = false;
    currentPage.value = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStorageKeys.isFirstTime, false);
    await prefs.setInt(AppStorageKeys.onboardingPageIndex, 0);

    if (isSkipping) {
      ToastHelper.showInfo("Welcome to FitCal!");
    } else {
      ToastHelper.showSuccess("Welcome to FitCal!", title: "Setup Complete");
    }
    Get.offAll(() => const AuthEntryScreen());
  }

  @override
  void onClose() {
    pageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.onClose();
  }
}
