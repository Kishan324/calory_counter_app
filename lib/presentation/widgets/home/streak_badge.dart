import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../controllers/date_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_space.dart';

/// Flame Streak Badge displayed in the AppBar. Tapping opens the interactive Streak Modal.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final dateController = Get.find<DateController>();

    return InkWell(
      onTap: () => showStreakModal(context, dateController, loc),
      borderRadius: AppRadius.border20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.amber.withValues(alpha: 0.15),
          borderRadius: AppRadius.border20,
          border: Border.all(
            color: AppColors.amber.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🔥', style: TextStyle(fontSize: 14.sp)),
            const HSpace4(),
            Obx(() => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    loc.dayStreak(dateController.streakDays.value),
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: AppColors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  static void showStreakModal(
    BuildContext context,
    DateController dateController,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(AppPadding.padding24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.border28.topLeft.x),
            topRight: Radius.circular(AppRadius.border28.topRight.x),
          ),
          boxShadow: AppShadows.cardSubtle(isDark),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: AppRadius.border8,
              ),
            ),
            const VSpace20(),
            Container(
              padding: EdgeInsets.all(AppPadding.padding16),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 40.sp),
              ),
            ),
            const VSpace16(),
            Obx(() => Text(
                  loc.dayStreak(dateController.streakDays.value),
                  style: theme.textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                )),
            const VSpace8(),
            Text(
              loc.streakSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const VSpace24(),
            Builder(builder: (context) {
              final today = DateTime.now();
              final dates = List.generate(
                  7, (index) => today.subtract(Duration(days: 6 - index)));

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final isCompleted = index < dateController.streakDays.value;
                  final dayLabel = DateFormat.E(
                          Localizations.localeOf(context).toString())
                      .format(dates[index]);
                  final dayInitial =
                      dayLabel.isNotEmpty ? dayLabel.substring(0, 1) : '';

                  return Column(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? AppColors.amber
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isCompleted ? Icons.check : Icons.lock_outline,
                            color: isCompleted
                                ? AppColors.black
                                : theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                            size: 18.sp,
                          ),
                        ),
                      ),
                      const VSpace6(),
                      Text(
                        dayInitial,
                        style: theme.textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? AppColors.amber
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  );
                }),
              );
            }),
            const VSpace28(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.border16,
                  ),
                ),
                child: Text(
                  loc.keepItUp,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const VSpace12(),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
