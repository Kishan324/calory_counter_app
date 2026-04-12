import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            // App icon
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: theme.colorScheme.primary,
                size: 56.sp,
              ),
            ),
            SizedBox(height: 32.h),
            // App name
            Text(
              loc.welcomeTitle,
              style: theme.textTheme.headlineLarge!.copyWith(
                fontSize: 24.sp,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            // Tagline
            Text(
              loc.tagline,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontStyle: FontStyle.italic,
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
