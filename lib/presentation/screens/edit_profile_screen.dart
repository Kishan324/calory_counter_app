import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_space.dart';
import '../widgets/app_primary_button.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/edit_profile_controller.dart';

/// User profile edit screen allowing name changes and avatar upload using GetX.
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  ImageProvider? _getAvatarProvider(String? imageStr) {
    if (imageStr == null || imageStr.isEmpty) return null;
    if (imageStr.startsWith('http://') || imageStr.startsWith('https://')) {
      return NetworkImage(imageStr);
    }
    final file = File(imageStr);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return null;
  }

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  void _showImageSourceSelector(BuildContext context, AppLocalizations loc, EditProfileController controller) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppRadius.radius24),
              topRight: Radius.circular(AppRadius.radius24),
            ),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.1),
            ),
          ),
          padding: EdgeInsets.all(AppPadding.padding24),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.selectImageSource,
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VSpace24(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSourceOption(
                      context: context,
                      icon: Icons.camera_alt_rounded,
                      label: loc.camera,
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.camera);
                      },
                    ),
                    _buildSourceOption(
                      context: context,
                      icon: Icons.photo_library_rounded,
                      label: loc.gallery,
                      onTap: () {
                        Get.back();
                        controller.pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.border16,
      child: Container(
        width: 120.w,
        padding: EdgeInsets.symmetric(vertical: AppPadding.padding16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: AppRadius.border16,
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.primary,
              size: 32.sp,
            ),
            const VSpace8(),
            Text(
              label,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    final controller = Get.put(EditProfileController());
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.editProfile, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(AppPadding.padding24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const VSpace20(),
                Center(
                  child: Stack(
                    children: [
                      Obx(() {
                        ImageProvider? avatarImage;
                        final localPath = controller.localImagePath.value;

                        if (localPath != null && localPath.isNotEmpty) {
                          avatarImage = _getAvatarProvider(localPath);
                        }
                        avatarImage ??= _getAvatarProvider(profileController.profileImageUrl);

                        return Container(
                          height: AppSizes.avatarSizeLg,
                          width: AppSizes.avatarSizeLg,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary
                                .withOpacity(isDark ? 0.2 : 0.1),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              width: 3,
                            ),
                            image: avatarImage != null
                                ? DecorationImage(
                                    image: avatarImage,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: avatarImage == null
                              ? Center(
                                  child: Text(
                                    _getInitials(controller.nameController.text.isNotEmpty
                                        ? controller.nameController.text
                                        : profileController.name),
                                    style: theme.textTheme.headlineLarge!.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontSize: 38.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showImageSourceSelector(context, loc, controller),
                          child: Container(
                            padding: EdgeInsets.all(AppPadding.padding8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.scaffoldBackgroundColor,
                                width: 2,
                              ),
                              boxShadow: AppShadows.cardSubtle(isDark),
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 18.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VSpace36(),
                GetBuilder<EditProfileController>(
                  builder: (ctrl) {
                    return TextFormField(
                      controller: ctrl.nameController,
                      textCapitalization: TextCapitalization.words,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: loc.name,
                        labelStyle: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        floatingLabelStyle:
                            theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.primary),
                        prefixIcon: Icon(Icons.person_outline_rounded,
                            color: theme.colorScheme.onSurfaceVariant),
                        suffixIcon: ctrl.nameController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: ctrl.clearName,
                              )
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadius.border16,
                          borderSide: BorderSide(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppRadius.border16,
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: AppRadius.border16,
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: AppRadius.border16,
                          borderSide: BorderSide(
                            color: theme.colorScheme.error,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.padding20, vertical: AppPadding.padding18),
                      ),
                      onChanged: (val) {
                        ctrl.update();
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return loc.nameRequired;
                        }
                        if (value.trim().length < 2) {
                          return loc.invalidName;
                        }
                        return null;
                      },
                    );
                  },
                ),
                const VSpace48(),
                Obx(
                  () => AppPrimaryButton(
                    text: loc.save,
                    onPressed: () => controller.submitForm(loc),
                    isLoading: profileController.isSaving,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
