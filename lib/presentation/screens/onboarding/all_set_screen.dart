import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';

/// Page 5 — Final confirmation screen shown after user data is collected.
class AllSetScreen extends StatelessWidget {
  const AllSetScreen({Key? key}) : super(key: key);

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

            // Hero Check Badge with Outer Glow
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
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                      size: 58.sp,
                    ),
                  ),
                ],
              ),
            ),

            const VSpace36(),

            // Header Title
            Text(
              loc.allSet,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace14(),

            // Subtitle
            Text(
              loc.allSetSubtitle,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: 15.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace28(),

            // Crisp Setup Readiness Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding20,
                vertical: AppPadding.padding18,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withOpacity(0.06)
                    : theme.colorScheme.surface,
                borderRadius: AppRadius.border20,
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withOpacity(0.12)
                      : AppColors.black.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(isDark ? 0.2 : 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  _CheckItem(label: 'Daily Calorie Goal Calculated'),
                  VSpace10(),
                  _CheckItem(label: 'Macro Distribution Balanced'),
                  VSpace10(),
                  _CheckItem(label: 'AI Food Scanner Ready'),
                ],
              ),
            ),

            const VSpace100(),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;

  const _CheckItem({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.task_alt_rounded,
          color: theme.colorScheme.primary,
          size: 18.sp,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

