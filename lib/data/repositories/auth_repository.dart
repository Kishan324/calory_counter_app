import 'dart:async';
import '../../core/theme/app_durations.dart';
import '../services/api_service.dart';

/// Repository managing authentication operations and user session credentials.
class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  ApiService get apiService => _apiService;

  /// Authenticates user credentials and returns session data.
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(AppDurations.slow);

    if (email.isEmpty || password.isEmpty) {
      throw "Email and password cannot be empty";
    }

    return {
      'success': true,
      'data': {
        'token': 'fitcal_auth_token_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 101,
          'email': email,
          'name': email.split('@').first.toUpperCase(),
        },
        'message': 'Logged in successfully',
      }
    };
  }

  /// Registers a new user account.
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    await Future.delayed(AppDurations.slow);

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw "Please fill all required registration fields";
    }

    return {
      'success': true,
      'token': 'fitcal_auth_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 102,
        'name': name,
        'email': email,
      },
      'message': 'Account registered successfully',
    };
  }
}
