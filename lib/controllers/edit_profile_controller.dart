import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'profile_controller.dart';

/// Manages form key, avatar image selection, and profile updates for EditProfileScreen.
class EditProfileController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  final RxnString localImagePath = RxnString();
  final Rxn<DateTime> selectedBirthDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    final profileCtrl = Get.find<ProfileController>();
    nameController = TextEditingController(text: profileCtrl.name ?? '');
    selectedBirthDate.value = profileCtrl.birthDate;
  }

  void setBirthDate(DateTime date) {
    selectedBirthDate.value = date;
    update();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        localImagePath.value = pickedFile.path;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error picking image: $e");
      }
    }
  }

  void clearName() {
    nameController.clear();
    update();
  }

  Future<void> submitForm(AppLocalizations loc) async {
    if (!formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final profileCtrl = Get.find<ProfileController>();

    await profileCtrl.updateProfileDetails(
      name: name,
      imagePath: localImagePath.value,
      birthDate: selectedBirthDate.value,
      successMessage: loc.profileUpdated,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
