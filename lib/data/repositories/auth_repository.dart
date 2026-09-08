import 'dart:async';
import '../../core/theme/app_durations.dart';
import '../services/api_service.dart';

/// Repository for authenticating users via simulated dummy backend endpoints.
class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  ApiService get apiService => _apiService;

  /// Simulated dummy login call returning template session data.
  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(AppDurations.slow);

    if (email.isEmpty || password.isEmpty) {
      throw "Email and password cannot be empty";
    }

    return {
      'success': true,
      'data': {
        'token': 'mock_jwt_token_fitcal_${DateTime.now().millisecondsSinceEpoch}',
        'user': {
          'id': 101,
          'email': email,
          'name': email.split('@').first.toUpperCase(),
        },
        'message': 'Logged in successfully',
      }
    };
  }

  /// Simulated dummy signup call returning template user account.
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
      'token': 'mock_jwt_token_fitcal_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': 102,
        'name': name,
        'email': email,
      },
      'message': 'Account registered successfully',
    };
  }
}
