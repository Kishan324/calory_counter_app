import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_space.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';

import 'auth/auth_entry_screen.dart';
import 'language_screen.dart';
import 'theme_screen.dart';
import 'edit_profile_screen.dart';
import 'weight_goal_screen.dart';
import 'daily_calories_screen.dart';
import '../../data/services/biometric_service.dart';

/// User profile configuration screen with settings, goals, preferences, and security lock options.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RxBool _isEnabled = false.obs;
  final RxBool _isBiometricAvailable = false.obs;

  late final ProfileController profileController;
  late final LocaleController localeController;
  late final ThemeController themeController;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();
    localeController = Get.find<LocaleController>();
    themeController = Get.find<ThemeController>();
    authController = Get.find<AuthController>();

    _loadAppLock();
    _checkBiometricAvailability();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profileController.profile == null) {
        profileController.fetchProfile(silent: false);
      } else {
        profileController.fetchProfile(silent: true);
      }
    });
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'de':
        return 'Deutsch';
      case 'hi':
        return 'हिंदी';
      case 'gu':
        return 'ગુજરાતી';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  String _getThemeName(AppThemeType type) {
    switch (type) {
      case AppThemeType.system:
        return 'System Default';
      case AppThemeType.light:
        return 'Light (Green)';
      case AppThemeType.dark:
        return 'Dark (Teal)';
      case AppThemeType.mint:
        return 'Mint Pastel';
      case AppThemeType.berry:
        return 'Berry Pink';
      case AppThemeType.sunset:
        return 'Sunset Orange';
      case AppThemeType.ocean:
        return 'Ocean Blue';
    }
  }

  Future<void> _loadAppLock() async {
    final enabled = await BiometricService().isAppLockEnabled();
    _isEnabled.value = enabled;
  }

  Future<void> _checkBiometricAvailability() async {
    final available = await BiometricService().isBiometricAvailable();
    _isBiometricAvailable.value = available;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.profile, style: theme.textTheme.headlineLarge),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (profileController.isLoading && profileController.profile == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24, vertical: AppPadding.padding8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context, isDark, loc),
                const VSpace28(),
                Text(loc.goals, style: theme.textTheme.headlineMedium),
                const VSpace14(),
                _buildSettingsCard(context, isDark, [
                  _buildSettingsRow(
                    context,
                    Icons.flag_rounded,
                    loc.weightGoal,
                    profileController.weightGoal != null
                        ? '${profileController.weightGoal} kg'
                        : '-- kg',
                    onTap: () => Get.to(
                      () => const WeightGoalScreen(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 320),
                    ),
                  ),
                  _buildSettingsRow(
                    context,
                    Icons.local_fire_department_rounded,
                    loc.dailyCalories,
                    profileController.dailyCalories != null
                        ? '${profileController.dailyCalories} kcal'
                        : '-- kcal',
                    isLast: true,
                    onTap: () => Get.to(
                      () => const DailyCaloriesScreen(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 320),
                    ),
                  ),
                ]),
                const VSpace28(),
                Text(loc.preferences, style: theme.textTheme.headlineMedium),
                const VSpace14(),
                _buildSettingsCard(context, isDark, [
                  _buildSettingsRow(context, Icons.notifications_rounded,
                      loc.notifications, 'On'),
                  _buildSettingsRow(context, Icons.palette_rounded, loc.theme,
                      _getThemeName(themeController.themeType),
                      onTap: () => Get.to(
                        () => const ThemeScreen(),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 320),
                      )),
                  _buildSettingsRow(
                      context,
                      Icons.language_rounded,
                      loc.language,
                      _getLanguageName(localeController.locale.languageCode),
                      isLast: true,
                      onTap: () => Get.to(
                        () => const LanguageScreen(),
                        transition: Transition.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 320),
                      )),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    indent: 56.w,
                    endIndent: 20.w,
                  ),
                  const VSpace5(),
                  setAppLock(),
                  const VSpace10(),
                ]),
                const VSpace28(),
                _buildLogoutButton(context, isDark, loc),
                const VSpace110(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showLogoutConfirmation(context, loc),
      borderRadius: AppRadius.border24,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppPadding.padding20),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.1),
          borderRadius: AppRadius.border24,
          border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            const HSpace12(),
            Text(
              loc.logout,
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Logout",
      barrierColor: AppColors.black.withOpacity(0.4),
      transitionDuration: AppDurations.normal,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24),
            child: ClipRRect(
              borderRadius: AppRadius.border24,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.all(AppPadding.padding24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.7),
                    borderRadius: AppRadius.border24,
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppPadding.padding14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.error.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.error,
                          size: 28.sp,
                        ),
                      ),
                      const VSpace20(),
                      Text(
                        loc.logoutConfirmTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const VSpace10(),
                      Text(
                        loc.logoutConfirmMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const VSpace24(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: AppPadding.padding14),
                                side: BorderSide(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.border14,
                                ),
                              ),
                              child: Text(loc.cancel),
                            ),
                          ),
                          const HSpace12(),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Get.back();
                                await authController.logout();
                                Get.offAll(() => const AuthEntryScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                padding: EdgeInsets.symmetric(vertical: AppPadding.padding14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.border14,
                                ),
                              ),
                              child: Text(
                                loc.logout,
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }

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

  Widget _buildProfileHeader(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);

    String initials = 'U';
    if (profileController.name != null && profileController.name!.isNotEmpty) {
      final parts = profileController.name!.trim().split(RegExp(r'\s+'));
      if (parts.length > 1) {
        initials = (parts[0][0] + parts[1][0]).toUpperCase();
      } else {
        initials = parts[0][0].toUpperCase();
      }
    }

    final avatarProvider = _getAvatarProvider(profileController.profileImageUrl);
    final hasImage = avatarProvider != null;

    return InkWell(
      onTap: () => Get.to(
        () => const EditProfileScreen(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 320),
      ),
      borderRadius: AppRadius.border24,
      child: Container(
        padding: EdgeInsets.all(AppPadding.padding20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.border24,
          boxShadow: AppShadows.header(isDark),
        ),
        child: Row(
          children: [
            Container(
              height: AppSizes.avatarSizeMd,
              width: AppSizes.avatarSizeMd,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
                image: hasImage
                    ? DecorationImage(
                        image: avatarProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasImage
                  ? Center(
                      child: Text(
                        initials,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: theme.colorScheme.primary,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
            const HSpace16(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileController.name ?? loc.name,
                    style: theme.textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const VSpace4(),
                  Text(
                    loc.premiumMember,
                    style: theme.textTheme.bodySmall!
                        .copyWith(color: theme.colorScheme.secondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(AppPadding.padding8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.edit_rounded,
                  size: 18.sp, color: theme.colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, bool isDark, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border24,
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget setAppLock() {
    return Obx(() {
      if (!_isBiometricAvailable.value) return const SizedBox.shrink();

      final theme = Theme.of(context);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.padding4),
        child: SwitchListTile(
          title: Text(
            AppLocalizations.of(context)!.appLock,
            style: theme.textTheme.bodyLarge,
          ),
          secondary: Container(
            padding: EdgeInsets.all(AppPadding.padding8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fingerprint_rounded,
              color: theme.colorScheme.primary,
              size: 20.sp,
            ),
          ),
          value: _isEnabled.value,
          activeColor: theme.colorScheme.primary,
          onChanged: (value) async {
            await BiometricService().setAppLockEnabled(value);
            _isEnabled.value = value;
          },
        ),
      );
    });
  }

  Widget _buildSettingsRow(
      BuildContext context, IconData icon, String title, String value,
      {bool isLast = false, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.padding20, vertical: AppPadding.padding18),
            child: Row(
              children: [
                Icon(icon,
                    color: theme.colorScheme.onSurfaceVariant, size: 22.sp),
                const HSpace14(),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const HSpace8(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  size: 14.sp,
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              indent: 56.w,
              endIndent: 20.w,
            ),
        ],
      ),
    );
  }
}
