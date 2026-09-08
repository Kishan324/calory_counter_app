import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';
import '../../core/utils/toast_helper.dart';

import '../widgets/app_drawer.dart';
import '../../controllers/date_controller.dart';
import 'scanner_screen.dart';

/// Dashboard home screen showing animated daily nutrition totals and date selection strip.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final dateController = Get.find<DateController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(isHistorySelected: false),
      appBar: AppBar(
        title: Text(loc.caloryCounter, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding24,
                vertical: AppPadding.padding8,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DateStripWidget(),
                  const VSpace32(),
                  _buildNutritionCard(context, isDark, loc),
                  const VSpace32(),
                  Text(loc.mealsToday, style: theme.textTheme.headlineMedium),
                  const VSpace16(),
                  Obx(() {
                    final data = dateController.currentNutrition;

                    return Column(
                      children: [
                        _buildMealSection(
                          context: context,
                          title: loc.breakfast,
                          calories: data.breakfastCalories,
                          icon: Icons.breakfast_dining_rounded,
                          isDark: isDark,
                          loc: loc,
                        ),
                        _buildMealSection(
                          context: context,
                          title: loc.lunch,
                          calories: data.lunchCalories,
                          icon: Icons.lunch_dining_rounded,
                          isDark: isDark,
                          loc: loc,
                        ),
                        _buildMealSection(
                          context: context,
                          title: loc.snacks,
                          calories: data.snacksCalories,
                          icon: Icons.bakery_dining_rounded,
                          isDark: isDark,
                          loc: loc,
                        ),
                        _buildMealSection(
                          context: context,
                          title: loc.dinner,
                          calories: data.dinnerCalories,
                          icon: Icons.dinner_dining_rounded,
                          isDark: isDark,
                          loc: loc,
                        ),
                      ],
                    );
                  }),
                  const VSpace110(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
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
                  child: Text(
                    loc.dailySummary,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.more_horiz, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
            const VSpace24(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildMacroCircular(
                  context: context,
                  title: loc.calories,
                  nutrition: nutrition,
                  color: theme.colorScheme.primary,
                  loc: loc,
                ),
                const HSpace24(),
                Expanded(
                  child: Column(
                    children: [
                      _buildMacroBar(
                        context: context,
                        title: loc.protein,
                        current: nutrition.protein,
                        total: nutrition.totalProtein,
                        ratio: nutrition.proteinRatio,
                        color: AppColors.proteinRed,
                      ),
                      const VSpace16(),
                      _buildMacroBar(
                        context: context,
                        title: loc.carbs,
                        current: nutrition.carbs,
                        total: nutrition.totalCarbs,
                        ratio: nutrition.carbsRatio,
                        color: AppColors.carbsBlue,
                      ),
                      const VSpace16(),
                      _buildMacroBar(
                        context: context,
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

  Widget _buildMacroCircular({
    required BuildContext context,
    required String title,
    required DateNutrition nutrition,
    required Color color,
    required AppLocalizations loc,
  }) {
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
                color: theme.colorScheme.onSurface.withOpacity(0.1),
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
                    Text(
                      loc.kcalLeft,
                      style: theme.textTheme.labelMedium!.copyWith(fontSize: 9.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildMacroBar({
    required BuildContext context,
    required String title,
    required int current,
    required int total,
    required double ratio,
    required Color color,
  }) {
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
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 7.h,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealSection({
    required BuildContext context,
    required String title,
    required int calories,
    required IconData icon,
    required bool isDark,
    required AppLocalizations loc,
  }) {
    final theme = Theme.of(context);

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
                        .withOpacity(isDark ? 0.15 : 0.08),
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
                      Text(
                        title,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const VSpace4(),
                      Text(
                        loc.tapToAddFood,
                        style: theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

class DateStripWidget extends StatelessWidget {
  const DateStripWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return SizedBox(
      height: 95.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dates.length * 2 - 1, (i) {
          if (i.isOdd) {
            return const HSpace5();
          }

          final index = i ~/ 2;
          final date = dates[index];
          final weekDayLabel =
              DateFormat.E(Localizations.localeOf(context).toString())
                  .format(date);

          return Expanded(
            key: ValueKey(index),
            child: _DateItem(
              index: index,
              date: date,
              weekDayLabel: weekDayLabel,
            ),
          );
        }),
      ),
    );
  }
}

class _DateItem extends StatelessWidget {
  final int index;
  final DateTime date;
  final String weekDayLabel;

  const _DateItem({
    Key? key,
    required this.index,
    required this.date,
    required this.weekDayLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateController = Get.find<DateController>();

    return Obx(() {
      final isSelected = dateController.selectedIndex == index;

      return GestureDetector(
        onTap: () => dateController.setSelectedIndex(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.surface : AppColors.transparent,
            borderRadius: AppRadius.border14,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface
                      .withOpacity(isDark ? 0.2 : 0.12),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.black.withOpacity(isDark ? 0.3 : 0.04)
                    : AppColors.transparent,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: AppDurations.normal,
                curve: Curves.fastOutSlowIn,
                height: 26.w,
                width: 26.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    weekDayLabel.substring(0, 1),
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: isSelected
                          ? theme.colorScheme.surface
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
              const VSpace4(),
              Text(
                '${date.day}',
                style: theme.textTheme.displayMedium!.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
