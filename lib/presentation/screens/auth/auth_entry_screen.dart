import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthEntryScreen extends StatelessWidget {
  const AuthEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          theme.colorScheme.primary.withOpacity(0.08),
                          theme.scaffoldBackgroundColor,
                        ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  const Spacer(),
                  // Branding
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: theme.colorScheme.primary,
                      size: 50.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    loc.welcomeTitle,
                    style: theme.textTheme.headlineLarge!.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    loc.authTagline,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Actions
                  _AuthButton(
                    label: loc.login,
                    isPrimary: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _AuthButton(
                    label: loc.signup,
                    isPrimary: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              color: isPrimary
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.2),
              ),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: isPrimary ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
