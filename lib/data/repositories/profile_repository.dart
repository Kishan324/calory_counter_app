import 'dart:async';
import '../../core/theme/app_durations.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

/// Repository managing mock user profile details without active HTTP endpoints.
class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  ApiService get apiService => _apiService;

  static UserProfile _cachedProfile = UserProfile(
    name: 'Alex Morgan',
    profileImage: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
    weightGoal: 68.5,
    dailyCalories: 2000,
  );

  /// Fetch user profile details (simulated mock delay)
  Future<UserProfile> getProfile() async {
    await Future.delayed(AppDurations.normal);
    return _cachedProfile;
  }

  /// Update user profile details (simulated mock delay)
  Future<UserProfile> updateProfile({
    String? name,
    String? imagePath,
    double? weightGoal,
    int? dailyCalories,
  }) async {
    await Future.delayed(AppDurations.slow);

    _cachedProfile = UserProfile(
      name: name ?? _cachedProfile.name,
      profileImage: imagePath ?? _cachedProfile.profileImage,
      weightGoal: weightGoal ?? _cachedProfile.weightGoal,
      dailyCalories: dailyCalories ?? _cachedProfile.dailyCalories,
    );

    return _cachedProfile;
  }
}
