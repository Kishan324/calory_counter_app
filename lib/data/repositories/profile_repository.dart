import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_storage_keys.dart';
import '../../core/theme/app_durations.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

/// Repository managing user profile data, goals, and personal settings.
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

  /// Fetches user profile details.
  Future<UserProfile> getProfile() async {
    await Future.delayed(AppDurations.normal);
    final prefs = await SharedPreferences.getInstance();
    final birthDateStr = prefs.getString(AppStorageKeys.userBirthDate);
    final birthDate = birthDateStr != null ? DateTime.tryParse(birthDateStr) : _cachedProfile.birthDate;

    _cachedProfile = UserProfile(
      name: _cachedProfile.name,
      profileImage: _cachedProfile.profileImage,
      weightGoal: _cachedProfile.weightGoal,
      dailyCalories: _cachedProfile.dailyCalories,
      birthDate: birthDate,
    );
    return _cachedProfile;
  }

  /// Updates user profile details and target metrics.
  Future<UserProfile> updateProfile({
    String? name,
    String? imagePath,
    double? weightGoal,
    int? dailyCalories,
    DateTime? birthDate,
  }) async {
    await Future.delayed(AppDurations.slow);

    if (birthDate != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStorageKeys.userBirthDate, birthDate.toIso8601String());
    }

    _cachedProfile = UserProfile(
      name: name ?? _cachedProfile.name,
      profileImage: imagePath ?? _cachedProfile.profileImage,
      weightGoal: weightGoal ?? _cachedProfile.weightGoal,
      dailyCalories: dailyCalories ?? _cachedProfile.dailyCalories,
      birthDate: birthDate ?? _cachedProfile.birthDate,
    );

    return _cachedProfile;
  }
}
