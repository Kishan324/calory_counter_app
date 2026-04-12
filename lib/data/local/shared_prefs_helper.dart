import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';

  /// Save token
  static Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Remove token
  static Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_tokenKey);
  }

  /// Save User Email
  static Future<bool> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userEmailKey, email);
  }

  /// Get User Email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Clear all auth data (Logout)
  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userEmailKey);
  }
}
