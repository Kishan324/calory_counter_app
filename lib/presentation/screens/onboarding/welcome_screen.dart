import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';

/// Called when the user taps Next / Get Started on this page.
typedef OnNextCallback = void Function();

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  final OnNextCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.padding24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VSpace40(),

            // Hero Fire Icon Card with Outer Glow
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(isDark ? 0.20 : 0.12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.35),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? theme.colorScheme.primary.withOpacity(0.25)
                          : AppColors.white,
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: theme.colorScheme.primary,
                      size: 58.sp,
                    ),
                  ),
                ],
              ),
            ),

            const VSpace36(),

            // Welcome Header Title
            Text(
              loc.welcomeTitle,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace14(),

            // Tagline
            Text(
              loc.tagline,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: 15.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace32(),

            // Glass Feature Chips Stack
            Wrap(
              spacing: 8.w,
              runSpacing: 10.h,
              alignment: WrapAlignment.center,
              children: const [
                _WelcomeChip(icon: Icons.camera_alt_rounded, label: 'AI Food Scanner'),
                _WelcomeChip(icon: Icons.pie_chart_rounded, label: 'Macro Tracker'),
                _WelcomeChip(icon: Icons.show_chart_rounded, label: 'Smart Analytics'),
              ],
            ),

            const VSpace100(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WelcomeChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding14,
        vertical: AppPadding.padding8,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withOpacity(0.08)
            : theme.colorScheme.surface,
        borderRadius: AppRadius.border20,
        border: Border.all(
          color: isDark
              ? AppColors.white.withOpacity(0.14)
              : AppColors.black.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

