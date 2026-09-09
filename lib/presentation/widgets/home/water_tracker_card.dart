import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controllers/date_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_padding.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_space.dart';

/// Ultra-Premium Hydration Tracker Card with liquid vessel animation.
class WaterTrackerCard extends StatelessWidget {
  const WaterTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final dateController = Get.find<DateController>();

    return Container(
      padding: EdgeInsets.all(AppPadding.padding20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border28,
        border: Border.all(
          color: AppColors.carbsBlue.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1.5,
        ),
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Obx(() => _WaterGlassVessel(
                          ratio: dateController.waterRatio,
                          isDark: isDark,
                        )),
                    const HSpace16(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              loc.waterIntake,
                              style: theme.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const VSpace4(),
                          Obx(() => Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${dateController.currentWaterMl.value}',
                                    style:
                                        theme.textTheme.headlineMedium!.copyWith(
                                      color: AppColors.carbsBlue,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  Text(
                                    ' / ${dateController.targetWaterMl.value} ml',
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final percentage = (dateController.waterRatio * 100).toInt();
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.carbsBlue.withValues(alpha: 0.15),
                    borderRadius: AppRadius.border16,
                  ),
                  child: Text(
                    '$percentage%',
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: AppColors.carbsBlue,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
              }),
            ],
          ),
          const VSpace16(),
          Obx(() => ClipRRect(
                borderRadius: AppRadius.border12,
                child: LinearProgressIndicator(
                  value: dateController.waterRatio,
                  minHeight: 10.h,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.08),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.carbsBlue),
                ),
              )),
          const VSpace20(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => dateController.addWaterIntake(250),
                  icon: Icon(Icons.local_drink_rounded,
                      size: 16.sp, color: AppColors.carbsBlue),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+250 ml',
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: AppColors.carbsBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: AppColors.carbsBlue.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.border16,
                    ),
                  ),
                ),
              ),
              const HSpace8(),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => dateController.addWaterIntake(500),
                  icon: Icon(Icons.water_rounded,
                      size: 16.sp, color: AppColors.carbsBlue),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+500 ml',
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: AppColors.carbsBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(
                      color: AppColors.carbsBlue.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.border16,
                    ),
                  ),
                ),
              ),
              const HSpace8(),
              IconButton(
                onPressed: () => dateController.addWaterIntake(-250),
                tooltip: 'Subtract 250ml',
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterGlassVessel extends StatelessWidget {
  final double ratio;
  final bool isDark;

  const _WaterGlassVessel({
    required this.ratio,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 85.h,
      decoration: BoxDecoration(
        color: AppColors.carbsBlue.withValues(alpha: isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.border16.bottomLeft.x),
          bottomRight: Radius.circular(AppRadius.border16.bottomRight.x),
          topLeft: Radius.circular(AppRadius.border8.topLeft.x),
          topRight: Radius.circular(AppRadius.border8.topRight.x),
        ),
        border: Border.all(
          color: AppColors.carbsBlue.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.border14.bottomLeft.x),
          bottomRight: Radius.circular(AppRadius.border14.bottomRight.x),
          topLeft: Radius.circular(AppRadius.border6.topLeft.x),
          topRight: Radius.circular(AppRadius.border6.topRight.x),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: ratio),
              duration: AppDurations.normal,
              curve: Curves.easeOutCubic,
              builder: (context, val, child) {
                return FractionalTranslation(
                  translation: Offset(0, 1 - val),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.carbsBlue,
                          AppColors.accent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: Icon(
                Icons.water_drop_rounded,
                color: AppColors.white.withValues(alpha: 0.85),
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
