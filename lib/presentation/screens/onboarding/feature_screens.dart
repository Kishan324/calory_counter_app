import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';

/// Page 2 — Calorie tracking feature highlight.
class CalorieFeatureScreen extends StatelessWidget {
  const CalorieFeatureScreen({Key? key}) : super(key: key);

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

            // Crisp Hero Feature Visual Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding24,
                vertical: AppPadding.padding28,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withOpacity(0.06)
                    : theme.colorScheme.surface,
                borderRadius: AppRadius.border24,
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
                children: [
                  // Icon Badge
                  Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(isDark ? 0.25 : 0.15),
                    ),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      color: theme.colorScheme.primary,
                      size: 44.sp,
                    ),
                  ),
                  const VSpace24(),

                  // Macro Nutrition Preview Chips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _MacroPill(
                        label: 'Protein',
                        value: '135g',
                        color: AppColors.proteinRed,
                      ),
                      _MacroPill(
                        label: 'Carbs',
                        value: '210g',
                        color: AppColors.carbsBlue,
                      ),
                      _MacroPill(
                        label: 'Fats',
                        value: '60g',
                        color: AppColors.fatsGreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const VSpace36(),

            // Title
            Text(
              loc.trackCaloriesTitle,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace16(),

            // Subtitle
            Text(
              loc.trackCaloriesSubtitle,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: 15.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace100(),
          ],
        ),
      ),
    );
  }
}

/// Page 3 — Analytics feature highlight.
class AnalyticsFeatureScreen extends StatelessWidget {
  const AnalyticsFeatureScreen({Key? key}) : super(key: key);

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

            // Crisp Hero Chart Graphic Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding24,
                vertical: AppPadding.padding28,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withOpacity(0.06)
                    : theme.colorScheme.surface,
                borderRadius: AppRadius.border24,
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
                children: [
                  // Icon Badge
                  Container(
                    width: 90.w,
                    height: 90.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary.withOpacity(isDark ? 0.25 : 0.15),
                    ),
                    child: Icon(
                      Icons.bar_chart_rounded,
                      color: theme.colorScheme.primary,
                      size: 44.sp,
                    ),
                  ),
                  const VSpace24(),

                  // Chart Bars Preview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      _ChartBar(heightFraction: 0.55, dayLabel: 'M'),
                      _ChartBar(heightFraction: 0.80, dayLabel: 'T'),
                      _ChartBar(heightFraction: 0.65, dayLabel: 'W'),
                      _ChartBar(heightFraction: 0.95, dayLabel: 'T', isHighest: true),
                      _ChartBar(heightFraction: 0.70, dayLabel: 'F'),
                      _ChartBar(heightFraction: 0.45, dayLabel: 'S'),
                      _ChartBar(heightFraction: 0.85, dayLabel: 'S'),
                    ],
                  ),
                ],
              ),
            ),

            const VSpace36(),

            // Title
            Text(
              loc.analyticsTitle,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace16(),

            // Subtitle
            Text(
              loc.analyticsSubtitle,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontSize: 15.sp,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const VSpace100(),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding12,
        vertical: AppPadding.padding8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: AppRadius.border14,
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 14.sp,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double heightFraction;
  final String dayLabel;
  final bool isHighest;

  const _ChartBar({
    required this.heightFraction,
    required this.dayLabel,
    this.isHighest = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14.w,
          height: 48.h * heightFraction,
          decoration: BoxDecoration(
            color: isHighest
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.35),
            borderRadius: AppRadius.border6,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          dayLabel,
          style: theme.textTheme.labelMedium!.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}

