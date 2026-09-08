import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_storage_keys.dart';
import '../core/utils/toast_helper.dart';
import '../data/local/shared_prefs_helper.dart';
import '../data/repositories/auth_repository.dart';

/// Manages user authentication, session state, and credentials using GetX.
class AuthController extends GetxController {
  final AuthRepository _authRepository;

  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxnString _userEmail = RxnString();
  final RxnString _userName = RxnString();

  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String? get userEmail => _userEmail.value;
  String? get userName => _userName.value;

  AuthController(this._authRepository);

  @override
  void onInit() {
    super.onInit();
    _loadAuthState();
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Restores session state from persistent storage
  Future<void> _loadAuthState() async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      _isLoggedIn.value = true;
      _userEmail.value = await SharedPrefsHelper.getUserEmail();
    }
  }

  /// Authenticates user against backend API
  Future<bool> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      ToastHelper.showError("Email and password cannot be empty");
      return false;
    }

    _setLoading(true);

    try {
      final response =
          await _authRepository.login(email.trim(), password.trim());

      if (response['data']['token'] != null) {
        final String token = response['data']['token'].toString();
        debugPrint("==== DEBUG PHASE 1: TOKEN RECEIVED ====");
        debugPrint("API RESPONSE TOKEN: $token");

        final prefs = await SharedPreferences.getInstance();
        final isSaved = await prefs.setString(AppStorageKeys.authToken, token);
        debugPrint("PREFS.SET_STRING RETURNED SUCCESS?: $isSaved");

        await SharedPrefsHelper.saveUserEmail(email);

        _isLoggedIn.value = true;
        _userEmail.value = email;

        ToastHelper.showSuccess(response['data']['message'] ?? "Login successful!");
        _setLoading(false);
        return true;
      } else {
        ToastHelper.showError(response['data']['message'] ?? "Login failed");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      ToastHelper.showError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Registers a new user account
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ToastHelper.showError("All fields are required");
      return false;
    }

    if (password.length < 6) {
      ToastHelper.showError("Password must be at least 6 characters");
      return false;
    }

    if (password != confirmPassword) {
      ToastHelper.showError("Passwords do not match");
      return false;
    }

    _setLoading(true);

    try {
      final response = await _authRepository.signup(
          name.trim(), email.trim(), password, confirmPassword);

      if (response['token'] != null || response['success'] == true) {
        final token = response['token'];

        if (token != null) {
          await SharedPrefsHelper.saveToken(token);
          await SharedPrefsHelper.saveUserEmail(email);
          _isLoggedIn.value = true;
          _userEmail.value = email;
          _userName.value = name;
        }

        ToastHelper.showSuccess(response['message'] ?? "Signup successful!");
        _setLoading(false);
        return true;
      } else {
        ToastHelper.showError(response['message'] ?? "Signup failed");
        _setLoading(false);
        return false;
      }
    } catch (e) {
      ToastHelper.showError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Logs out current user and clears session tokens
  Future<void> logout() async {
    await SharedPrefsHelper.clearAuth();
    _isLoggedIn.value = false;
    _userEmail.value = null;
    _userName.value = null;

    ToastHelper.showSuccess("Logged out successfully");
  }
}
