import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/profile_repository.dart';
import '../core/utils/toast_helper.dart';

/// Manages user profile fetching, updating, and target goals state using GetX.
class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;

  final Rxn<UserProfile> _profile = Rxn<UserProfile>();
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;

  UserProfile? get profile => _profile.value;
  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;

  String? get name => _profile.value?.name;
  String? get profileImageUrl => _profile.value?.profileImage;
  double? get weightGoal => _profile.value?.weightGoal;
  int? get dailyCalories => _profile.value?.dailyCalories;
  DateTime? get birthDate => _profile.value?.birthDate;

  ProfileController(this._profileRepository);

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  void _setSaving(bool value) {
    _isSaving.value = value;
  }

  /// Fetches latest user profile from API
  Future<void> fetchProfile({bool silent = false}) async {
    if (!silent) {
      _setLoading(true);
    }

    try {
      _profile.value = await _profileRepository.getProfile();
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error fetching profile: $e");
      }
    } finally {
      if (!silent) {
        _setLoading(false);
      }
    }
  }

  /// Updates profile details such as name, avatar image, weight goal, calories target, or birth date
  Future<bool> updateProfileDetails({
    String? name,
    String? imagePath,
    double? weightGoal,
    int? dailyCalories,
    DateTime? birthDate,
    required String successMessage,
    bool navigateBack = true,
  }) async {
    _setSaving(true);
    try {
      final updatedProfile = await _profileRepository.updateProfile(
        name: name ?? _profile.value?.name,
        imagePath: imagePath,
        weightGoal: weightGoal ?? _profile.value?.weightGoal,
        dailyCalories: dailyCalories ?? _profile.value?.dailyCalories,
        birthDate: birthDate ?? _profile.value?.birthDate,
      );
      _profile.value = updatedProfile;
      _profile.refresh();
      _setSaving(false);
      if (navigateBack) {
        Get.back();
      }
      ToastHelper.showSuccess(successMessage);
      return true;
    } catch (e) {
      ToastHelper.showError(e.toString());
      _setSaving(false);
      return false;
    }
  }
}
