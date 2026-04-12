import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/toast_helper.dart';
import '../data/local/shared_prefs_helper.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;

  AuthProvider(this._authRepository) {
    _loadAuthState();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Initial load and Auto-login check
  Future<void> _loadAuthState() async {
    final token = await SharedPrefsHelper.getToken();
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      _userEmail = await SharedPrefsHelper.getUserEmail();
      // Assume a backend token validation happens here if needed.
      notifyListeners();
    }
  }

  /// Real API Login Method
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

        // Start: Fixed Token Persistence
        final prefs = await SharedPreferences.getInstance();
        debugPrint("==== DEBUG PHASE 2: BEFORE SAVE ====");
        debugPrint("PREPARED KEY: 'auth_token' | VALUE: $token");

        final isSaved = await prefs.setString('auth_token', token);
        
        debugPrint("==== DEBUG PHASE 3: AFTER SAVE ====");
        debugPrint("PREFS.SET_STRING RETURNED SUCCESS?: $isSaved");

        // Verify Data Persistence Instantly
        final verificationToken = prefs.getString('auth_token');
        debugPrint("==== DEBUG VERIFICATION ====");
        debugPrint("READ IMMEDIATELY AFTER SAVE: $verificationToken");
        // End: Fixed Token Persistence

        // Save auxiliary user state
        await SharedPrefsHelper.saveUserEmail(email);

        _isLoggedIn = true;
        _userEmail = email;

        ToastHelper.showSuccess(response['data']['message'] ?? "Login successful!");
        _setLoading(false);
        return true;
      } else {
        debugPrint("==== DEBUG FAILURE ====");
        debugPrint("response['token'] WAS NULL!");
        debugPrint("FULL RESPONSE: $response");
        
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

  /// Real API Signup Method
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

      // Relax validation to check for token directly
      if (response['token'] != null || response['success'] == true) {
        final token = response['token'];
        
        // Auto-login on successful registration if token provided
        if (token != null) {
          await SharedPrefsHelper.saveToken(token);
          await SharedPrefsHelper.saveUserEmail(email);
          _isLoggedIn = true;
          _userEmail = email;
          _userName = name;
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

  /// Logout Method
  Future<void> logout() async {
    await SharedPrefsHelper.clearAuth();
    _isLoggedIn = false;
    _userEmail = null;
    _userName = null;

    ToastHelper.showSuccess("Logged out successfully");
    notifyListeners();
  }
}
