import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/auth_provider.dart';
import 'auth/auth_entry_screen.dart';
import 'language_screen.dart';
import 'theme_screen.dart';
import '../../data/services/biometric_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _getLanguageName(String code) {
    switch (code) {
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

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  bool isEnabled = false;
  bool _isBiometricAvailable = false;

  Future<void> _loadAppLock() async {
    final enabled = await BiometricService().isAppLockEnabled();
    setState(() {
      isEnabled = enabled;
    });
  }

  Future<void> _checkBiometricAvailability() async {
    final available = await BiometricService().isBiometricAvailable();
    setState(() {
      _isBiometricAvailable = available;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAppLock();
    _checkBiometricAvailability();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.profile, style: theme.textTheme.headlineLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context, isDark, loc),
              SizedBox(height: 28.h),
              Text(loc.goals, style: theme.textTheme.headlineMedium),
              SizedBox(height: 14.h),
              _buildSettingsCard(context, isDark, [
                _buildSettingsRow(
                    context, Icons.flag_rounded, loc.weightGoal, '70 kg'),
                _buildSettingsRow(context, Icons.local_fire_department_rounded,
                    loc.dailyCalories, '2000 kcal',
                    isLast: true),
              ]),
              SizedBox(height: 28.h),
              Text(loc.preferences, style: theme.textTheme.headlineMedium),
              SizedBox(height: 14.h),
              _buildSettingsCard(context, isDark, [
                _buildSettingsRow(context, Icons.notifications_rounded,
                    loc.notifications, 'On'),
                _buildSettingsRow(context, Icons.palette_rounded, loc.theme,
                    _getThemeName(context.watch<ThemeProvider>().themeMode),
                    onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ThemeScreen()));
                }),
                _buildSettingsRow(context, Icons.language_rounded, loc.language,
                    _getLanguageName(localeProvider.locale.languageCode),
                    isLast: true, onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LanguageScreen()));
                }),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  indent: 56.w,
                  endIndent: 20.w,
                ),
                SizedBox(height: 5.h),
                setAppLock(),
                SizedBox(height: 10.h),
              ]),
              SizedBox(height: 28.h),
              _buildLogoutButton(context, isDark, loc),
              SizedBox(height: 110.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showLogoutConfirmation(context, loc),
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            SizedBox(width: 12.w),
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
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔴 Icon
                      Container(
                        padding: EdgeInsets.all(14.w),
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

                      SizedBox(height: 20.h),

                      // 📝 Title
                      Text(
                        loc.logoutConfirmTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // 📄 Message
                      Text(
                        loc.logoutConfirmMessage,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // 🔘 Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                side: BorderSide(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Text(loc.cancel),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                await context.read<AuthProvider>().logout();

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AuthEntryScreen()),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              child: Text(
                                loc.logout,
                                style: const TextStyle(color: Colors.white),
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

      // ✨ Animation
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

  Widget _buildProfileHeader(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64.w,
            width: 64.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: theme.textTheme.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
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
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.edit_rounded,
                size: 18.sp, color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
      BuildContext context, bool isDark, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget setAppLock() {
    if (!_isBiometricAvailable) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SwitchListTile(
        title: Text(
          AppLocalizations.of(context)!.appLock,
          style: theme.textTheme.bodyLarge,
        ),
        secondary: Container(
          padding: EdgeInsets.all(8.w),
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
        value: isEnabled,
        activeColor: theme.colorScheme.primary,
        onChanged: (value) async {
          await BiometricService().setAppLockEnabled(value);
          setState(() {
            isEnabled = value;
          });
        },
      ),
    );
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Row(
              children: [
                Icon(icon,
                    color: theme.colorScheme.onSurfaceVariant, size: 22.sp),
                SizedBox(width: 14.w),
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
                SizedBox(width: 8.w),
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
