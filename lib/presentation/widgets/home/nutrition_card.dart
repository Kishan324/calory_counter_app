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

/// Hero Nutrition Summary Card displaying daily calories circular progress and macro progress bars.
class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final dateController = Get.find<DateController>();

    return Obx(() {
      final nutrition = dateController.currentNutrition;

      return Container(
        padding: AppPadding.all20,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.border28,
          boxShadow: AppShadows.header(isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loc.dailySummary,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                Icon(Icons.more_horiz, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
            const VSpace24(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _MacroCircularProgress(
                  title: loc.calories,
                  nutrition: nutrition,
                  color: theme.colorScheme.primary,
                  loc: loc,
                ),
                const HSpace24(),
                Expanded(
                  child: Column(
                    children: [
                      _MacroProgressBar(
                        title: loc.protein,
                        current: nutrition.protein,
                        total: nutrition.totalProtein,
                        ratio: nutrition.proteinRatio,
                        color: AppColors.proteinRed,
                      ),
                      const VSpace16(),
                      _MacroProgressBar(
                        title: loc.carbs,
                        current: nutrition.carbs,
                        total: nutrition.totalCarbs,
                        ratio: nutrition.carbsRatio,
                        color: AppColors.carbsBlue,
                      ),
                      const VSpace16(),
                      _MacroProgressBar(
                        title: loc.fats,
                        current: nutrition.fats,
                        total: nutrition.totalFats,
                        ratio: nutrition.fatsRatio,
                        color: AppColors.fatsGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _MacroCircularProgress extends StatelessWidget {
  final String title;
  final DateNutrition nutrition;
  final Color color;
  final AppLocalizations loc;

  const _MacroCircularProgress({
    required this.title,
    required this.nutrition,
    required this.color,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: nutrition.calorieRatio),
        duration: AppDurations.slow,
        curve: Curves.fastOutSlowIn,
        builder: (context, animValue, child) {
          final animatedRemaining =
              (nutrition.totalCalories - (animValue * nutrition.totalCalories))
                  .round()
                  .clamp(0, nutrition.totalCalories);

          return Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 10,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
              CircularProgressIndicator(
                value: animValue,
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$animatedRemaining',
                      style: theme.textTheme.displayLarge!.copyWith(fontSize: 22.sp),
                    ),
                    const VSpace2(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        loc.kcalLeft,
                        style: theme.textTheme.labelMedium!.copyWith(fontSize: 9.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MacroProgressBar extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final double ratio;
  final Color color;

  const _MacroProgressBar({
    required this.title,
    required this.current,
    required this.total,
    required this.ratio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: ratio),
      duration: AppDurations.slow,
      curve: Curves.fastOutSlowIn,
      builder: (context, animValue, child) {
        final animatedCurrent = (animValue * total).round().clamp(0, total);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$animatedCurrent',
                        style: theme.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      TextSpan(
                        text: ' / $total g',
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace6(),
            ClipRRect(
              borderRadius: AppRadius.border6,
              child: LinearProgressIndicator(
                value: animValue,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 7.h,
              ),
            ),
          ],
        );
      },
    );
  }
}
