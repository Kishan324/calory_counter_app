/// Centralized API endpoint routes and network configuration constants.
class ApiEndpoints {
  static const String baseUrl = 'https://api.calorycounter.com/v1';

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String foods = '/foods';
  static const String scanFood = '/foods/scan';
  static const String history = '/history';
}
