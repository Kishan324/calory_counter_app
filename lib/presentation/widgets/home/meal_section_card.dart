import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_space.dart';
import '../../../core/utils/toast_helper.dart';
import '../../screens/scanner_screen.dart';

/// Meal category card widget (Breakfast, Lunch, Snacks, Dinner).
class MealSectionCard extends StatelessWidget {
  final String title;
  final int calories;
  final IconData icon;

  const MealSectionCard({
    super.key,
    required this.title,
    required this.calories,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: AppPadding.padding14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border24,
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          borderRadius: AppRadius.border24,
          onTap: () {
            ToastHelper.showInfo(
              "Opening scanner to log $title",
              title: title,
            );
            Get.to(() => const ScannerScreen());
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding16,
              vertical: AppPadding.padding20,
            ),
            child: Row(
              children: [
                Container(
                  padding: AppPadding.all12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: AppRadius.border16,
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 24.sp,
                  ),
                ),
                const HSpace14(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      const VSpace4(),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          loc.tapToAddFood,
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(end: calories.toDouble()),
                      duration: AppDurations.slow,
                      curve: Curves.fastOutSlowIn,
                      builder: (context, animCal, child) {
                        return Text(
                          '${animCal.round()}',
                          style: theme.textTheme.displayMedium!
                              .copyWith(color: theme.colorScheme.onSurface),
                        );
                      },
                    ),
                    const VSpace2(),
                    Text(
                      loc.kcal,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const HSpace10(),
                Icon(
                  Icons.add_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 26.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
