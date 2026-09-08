import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';

/// Glassmorphic CTA button component used in onboarding and overlays.
class AppGlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const AppGlassButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppRadius.border20,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: AppRadius.border20,
              boxShadow: AppShadows.glassButton(theme.colorScheme.primary),
            ),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
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
