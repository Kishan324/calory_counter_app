import 'package:dio/dio.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/login', // Replace with AppConstants.loginEndpoint later
        data: {
          'email': email,
          'password': password,
        },
      );
      // Ensure the response data is parsed as a map
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // ApiService already formats error messages nicely inside the DioException.error field
      throw e.error ?? "Failed to login. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }

  Future<Map<String, dynamic>> signup(String name, String email, String password, String passwordConfirmation) async {
    try {
      final response = await _apiService.post(
        '/register', // Replace with AppConstants.signupEndpoint later
        data: {
          'name': name,
          'email': email,
          'password': password,
          ''
          'password_confirmation':passwordConfirmation,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw e.error ?? "Failed to signup. Please try again.";
    } catch (e) {
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }
}
