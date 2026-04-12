import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared internal layout widget for feature onboarding pages.
class _OnboardingFeaturePage extends StatelessWidget {
  const _OnboardingFeaturePage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 56.sp),
            ),
            SizedBox(height: 40.h),
            Text(
              title,
              style: theme.textTheme.headlineLarge!.copyWith(fontSize: 26.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}

/// Page 2 — Calorie tracking feature highlight.
class CalorieFeatureScreen extends StatelessWidget {
  const CalorieFeatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return _OnboardingFeaturePage(
      icon: Icons.restaurant_menu_rounded,
      title: loc.trackCaloriesTitle,
      subtitle: loc.trackCaloriesSubtitle,
    );
  }
}

/// Page 3 — Analytics feature highlight.
class AnalyticsFeatureScreen extends StatelessWidget {
  const AnalyticsFeatureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return _OnboardingFeaturePage(
      icon: Icons.bar_chart_rounded,
      title: loc.analyticsTitle,
      subtitle: loc.analyticsSubtitle,
    );
  }
}
