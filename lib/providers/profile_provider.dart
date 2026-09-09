import 'package:flutter/foundation.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/profile_repository.dart';
import '../core/utils/toast_helper.dart';

/// Provider managing user profile state and target goal updates.
class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository;

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  String? get name => _profile?.name;
  String? get profileImageUrl => _profile?.profileImage;
  double? get weightGoal => _profile?.weightGoal;
  int? get dailyCalories => _profile?.dailyCalories;

  ProfileProvider(this._profileRepository);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  /// Fetch user profile details from backend
  Future<void> fetchProfile({bool silent = false}) async {
    if (!silent) {
      _setLoading(true);
    }

    try {
      _profile = await _profileRepository.getProfile();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching profile: $e");
      }
    } finally {
      if (!silent) {
        _setLoading(false);
      } else {
        notifyListeners();
      }
    }
  }

  /// Update profile details
  Future<bool> updateProfileDetails({
    String? name,
    String? imagePath,
    double? weightGoal,
    int? dailyCalories,
    required String successMessage,
  }) async {
    _setSaving(true);
    try {
      final updatedProfile = await _profileRepository.updateProfile(
        name: name ?? _profile?.name,
        imagePath: imagePath,
        weightGoal: weightGoal ?? _profile?.weightGoal,
        dailyCalories: dailyCalories ?? _profile?.dailyCalories,
      );
      _profile = updatedProfile;
      ToastHelper.showSuccess(successMessage);
      _setSaving(false);
      return true;
    } catch (e) {
      ToastHelper.showError(e.toString());
      _setSaving(false);
      return false;
    }
  }
}
