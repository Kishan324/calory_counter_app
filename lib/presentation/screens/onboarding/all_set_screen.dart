import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary
                    .withOpacity(isDark ? 0.2 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: theme.colorScheme.primary,
                size: 56.sp,
              ),
            ),
            SizedBox(height: 40.h),
            Text(
              loc.allSet,
              style: theme.textTheme.headlineLarge!.copyWith(fontSize: 28.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              loc.allSetSubtitle,
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
