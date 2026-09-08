import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/analytics_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final controller = Get.find<AnalyticsController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.analytics, style: theme.textTheme.headlineLarge),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding24,
            vertical: AppPadding.padding8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.weeklyProgress, style: theme.textTheme.headlineMedium),
              const VSpace20(),
              _buildChartCard(context, controller, isDark, loc),
              const VSpace32(),
              Text(loc.macroBreakdown, style: theme.textTheme.headlineMedium),
              const VSpace20(),
              _buildMacroStats(context, controller, isDark, loc),
              const VSpace200(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(AppPadding.padding24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border28,
        boxShadow: AppShadows.header(isDark),
      ),
      child: Obx(() {
        final avgCalStr = NumberFormat('#,###').format(controller.avgCalories.value);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.caloriesConsumed,
              style: theme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const VSpace6(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: loc.avg, style: theme.textTheme.labelMedium),
                  TextSpan(
                    text: avgCalStr,
                    style: theme.textTheme.displayMedium!.copyWith(fontSize: 14.sp),
                  ),
                  TextSpan(text: loc.kcalPerDay, style: theme.textTheme.labelMedium),
                ],
              ),
            ),
            const VSpace32(),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.maxCalorieLimit.value,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final valDate = DateTime(2024, 1, 1 + value.toInt());
                          final dayStr = DateFormat.E(
                            Localizations.localeOf(context).toString(),
                          ).format(valDate);
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              dayStr.substring(0, 1).toUpperCase(),
                              style: theme.textTheme.labelMedium,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    controller.weeklyCalorieData.length,
                    (index) => _buildBarGroup(
                      context,
                      index,
                      controller.weeklyCalorieData[index],
                      controller.maxCalorieLimit.value,
                      isDark,
                    ),
                  ),
                ),
                swapAnimationDuration: AppDurations.slow,
                swapAnimationCurve: Curves.easeOutCubic,
              ),
            ),
          ],
        );
      }),
    );
  }

  BarChartGroupData _buildBarGroup(
    BuildContext context,
    int x,
    double y,
    double maxY,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: theme.colorScheme.primary,
          width: 14.w,
          borderRadius: AppRadius.border6,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.1 : 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroStats(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              loc.protein,
              controller.proteinAvg.value,
              AppColors.proteinRed,
              isDark,
              0,
            ),
          ),
          const HSpace12(),
          Expanded(
            child: _buildStatCard(
              context,
              loc.carbs,
              controller.carbsAvg.value,
              AppColors.carbsBlue,
              isDark,
              1,
            ),
          ),
          const HSpace12(),
          Expanded(
            child: _buildStatCard(
              context,
              loc.fats,
              controller.fatsAvg.value,
              AppColors.fatsGreen,
              isDark,
              2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    Color color,
    bool isDark,
    int delayIndex,
  ) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      key: ValueKey('stat_${title}_$value'),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (delayIndex * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * animValue),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: AppPadding.padding20,
                horizontal: AppPadding.padding12,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadius.border24,
                boxShadow: AppShadows.cardSubtle(isDark),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppPadding.padding8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.circle, color: color, size: 12.sp),
                  ),
                  const VSpace12(),
                  Text(
                    value,
                    style: theme.textTheme.displayMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const VSpace4(),
                  Text(
                    title,
                    style: theme.textTheme.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
