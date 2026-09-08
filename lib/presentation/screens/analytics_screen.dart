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
import '../../core/utils/haptic_helper.dart';

import 'analytics_detail_screen.dart';

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
              _buildHealthScoreHeroCard(context, controller, isDark, loc),
              const VSpace16(),
              _buildViewDetailedReportButton(context, isDark, loc),
              const VSpace24(),
              _buildTimeframeToggle(context, controller, isDark, loc),
              const VSpace20(),
              _buildChartCard(context, controller, isDark, loc),
              const VSpace32(),
              Text(loc.macroProgress, style: theme.textTheme.headlineMedium),
              const VSpace20(),
              _buildMacroProgressSection(context, controller, isDark, loc),
              const VSpace32(),
              Text(loc.smartInsights, style: theme.textTheme.headlineMedium),
              const VSpace16(),
              _buildSmartInsightsCard(context, controller, isDark, loc),
              const VSpace120(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetailedReportButton(
    BuildContext context,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () {
        HapticHelper.lightImpact();
        Get.to(() => const AnalyticsDetailScreen());
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.padding20,
          vertical: AppPadding.padding14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withValues(alpha: isDark ? 0.22 : 0.12),
              theme.colorScheme.surface,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: AppRadius.border20,
          border: Border.all(
            color: primaryColor.withValues(alpha: isDark ? 0.45 : 0.28),
            width: 1.5,
          ),
          boxShadow: AppShadows.cardSubtle(isDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_graph_rounded,
                    color: primaryColor,
                    size: 20.sp,
                  ),
                ),
                const HSpace12(),
                Text(
                  loc.viewDetailedReport,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.white,
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ultra-Executive, Vibrant & 100% Theme-Harmonized Health Score Hero Deck
  Widget _buildHealthScoreHeroCard(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Vibrant 3-stop mesh linear gradient derived from active theme primary
    final gradientCenter = Color.alphaBlend(
      AppColors.accent.withValues(alpha: 0.28),
      primaryColor,
    );
    final gradientEnd = Color.alphaBlend(
      Colors.black.withValues(alpha: 0.35),
      primaryColor,
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.border28,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.5 : 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppRadius.border28,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, gradientCenter, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.border28,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              // Ambient Decorative Glass Spheres & Sparkle Discs for 3D Depth
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Positioned(
                left: -40,
                bottom: -40,
                child: Container(
                  width: 160.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                right: 40.w,
                bottom: 15.h,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.white.withValues(alpha: 0.12),
                  size: 60.sp,
                ),
              ),

              // Hero Deck Content
              Padding(
                padding: EdgeInsets.all(AppPadding.padding20),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Header: Live AI Index Tag + Glowing 3D Golden Flame Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.22),
                              borderRadius: AppRadius.border14,
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.45),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7.w,
                                  height: 7.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF69F0AE), // Pulsing Neon Emerald Dot
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const HSpace6(),
                                Text(
                                  loc.healthScore.toUpperCase(),
                                  style: theme.textTheme.labelSmall!.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Radiant 3D Gold Flame Streak Badge with Shadow Glow
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFE082), // Amber Light Gold
                                  Color(0xFFFF8F00), // Deep Golden Amber
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppRadius.border16,
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.9),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF8F00).withValues(alpha: 0.6),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department_rounded,
                                  color: AppColors.white,
                                  size: 19,
                                ),
                                const HSpace4(),
                                Text(
                                  loc.dayStreak(controller.currentStreak.value),
                                  style: theme.textTheme.labelMedium!.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.sp,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const VSpace20(),

                      // Dial Gauge & Headline Section
                      Row(
                        children: [
                          // Concentric Glowing Dial Ring
                          Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.18),
                              border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.45),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 82.w,
                                  height: 82.h,
                                  child: CircularProgressIndicator(
                                    value: controller.healthScore.value / 100,
                                    strokeWidth: 9.w,
                                    backgroundColor: AppColors.white.withValues(
                                      alpha: 0.25,
                                    ),
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${controller.healthScore.value}',
                                      style: theme.textTheme.headlineLarge!.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.white,
                                        fontSize: 28.sp,
                                        height: 1.0,
                                      ),
                                    ),
                                    Text(
                                      '/100',
                                      style: theme.textTheme.labelSmall!.copyWith(
                                        color: AppColors.white.withValues(alpha: 0.85),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const HSpace18(),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.dietQuality,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.white,
                                    fontSize: 19.sp,
                                  ),
                                ),
                                const VSpace4(),
                                Text(
                                  '${loc.healthScore}: ${controller.healthScore.value}/100',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    color: AppColors.white.withValues(alpha: 0.88),
                                    fontSize: 13.sp,
                                  ),
                                ),
                                const VSpace8(),

                                // Rating Star Pill Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(alpha: 0.22),
                                    borderRadius: AppRadius.border10,
                                    border: Border.all(
                                      color: AppColors.white.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.stars_rounded,
                                        color: Color(0xFFFFE082),
                                        size: 15,
                                      ),
                                      const HSpace4(),
                                      Text(
                                        loc.excellent,
                                        style: theme.textTheme.labelMedium!.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const VSpace20(),

                      // Multi-Metric Quick Stat Glass Deck (Bottom Strip)
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricGlassPill(
                              context: context,
                              icon: Icons.local_fire_department_rounded,
                              label: loc.dayStreak(controller.currentStreak.value),
                              iconColor: const Color(0xFFFFE082),
                              primaryColor: primaryColor,
                            ),
                          ),
                          const HSpace8(),
                          Expanded(
                            child: _buildMetricGlassPill(
                              context: context,
                              icon: Icons.insights_rounded,
                              label: '${controller.healthScore.value}% Score',
                              iconColor: AppColors.white,
                              primaryColor: primaryColor,
                            ),
                          ),
                          const HSpace8(),
                          Expanded(
                            child: _buildMetricGlassPill(
                              context: context,
                              icon: Icons.stars_rounded,
                              label: loc.excellent,
                              iconColor: const Color(0xFFFFE082),
                              primaryColor: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for Glass Metric Stat Pills
  Widget _buildMetricGlassPill({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color primaryColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.18),
        borderRadius: AppRadius.border12,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 14.sp),
          const HSpace4(),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Segmented Timeframe Switcher (Weekly vs Monthly)
  Widget _buildTimeframeToggle(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);

    return Obx(
      () => Container(
        height: 48.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.border20,
          boxShadow: AppShadows.cardSubtle(isDark),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticHelper.selectionClick();
                  controller.setTimeframe(0);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: controller.selectedTimeframe.value == 0
                        ? theme.colorScheme.primary
                        : AppColors.transparent,
                    borderRadius: AppRadius.border16,
                  ),
                  child: Text(
                    loc.weekly,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: controller.selectedTimeframe.value == 0
                          ? AppColors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: controller.selectedTimeframe.value == 0
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticHelper.selectionClick();
                  controller.setTimeframe(1);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: controller.selectedTimeframe.value == 1
                        ? theme.colorScheme.primary
                        : AppColors.transparent,
                    borderRadius: AppRadius.border16,
                  ),
                  child: Text(
                    loc.monthly,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: controller.selectedTimeframe.value == 1
                          ? AppColors.white
                          : theme.colorScheme.onSurface,
                      fontWeight: controller.selectedTimeframe.value == 1
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive Touch Bar Chart Card
  Widget _buildChartCard(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(AppPadding.padding24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border28,
        boxShadow: AppShadows.header(isDark),
      ),
      child: Obx(() {
        final avgCalStr =
            NumberFormat('#,###').format(controller.avgCalories.value);
        final dataList = controller.currentCalorieData;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    loc.caloriesConsumed,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    borderRadius: AppRadius.border12,
                  ),
                  child: Text(
                    loc.onTrack,
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const VSpace6(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: loc.avg, style: theme.textTheme.labelMedium),
                  TextSpan(
                    text: avgCalStr,
                    style: theme.textTheme.displayMedium!
                        .copyWith(fontSize: 16.sp),
                  ),
                  TextSpan(
                      text: loc.kcalPerDay, style: theme.textTheme.labelMedium),
                ],
              ),
            ),
            const VSpace24(),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: controller.maxCalorieLimit.value,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => isDark
                          ? AppColors.surfaceDark
                          : theme.colorScheme.surface,
                      tooltipRoundedRadius: 12.r,
                      tooltipPadding: EdgeInsets.all(8.w),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} ${loc.kcal}',
                          theme.textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          final isWeekly =
                              controller.selectedTimeframe.value == 0;
                          String titleText = '';

                          if (isWeekly) {
                            final valDate =
                                DateTime(2024, 1, 1 + value.toInt());
                            titleText = DateFormat.E(
                              Localizations.localeOf(context).toString(),
                            ).format(valDate);
                          } else {
                            final weekNum = value.toInt() + 1;
                            titleText = loc.weekShort(weekNum);
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: SizedBox(
                              width: isWeekly ? 38.w : 68.w,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  titleText,
                                  style: theme.textTheme.labelMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    dataList.length,
                    (index) => _buildBarGroup(
                      context,
                      index,
                      dataList[index],
                      controller.maxCalorieLimit.value,
                      isDark,
                    ),
                  ),
                ),
                duration: AppDurations.slow,
                curve: Curves.easeOutCubic,
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
            color: theme.colorScheme.onSurface
                .withOpacity(isDark ? 0.1 : 0.05),
          ),
        ),
      ],
    );
  }

  /// Visual Macro Progress Section with linear progress indicators
  Widget _buildMacroProgressSection(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    return Obx(
      () => Column(
        children: [
          _buildMacroProgressBar(
            context,
            loc.protein,
            controller.proteinAvg.value,
            controller.proteinTarget.value,
            controller.proteinProgress.value,
            AppColors.proteinRed,
            isDark,
          ),
          const VSpace16(),
          _buildMacroProgressBar(
            context,
            loc.carbs,
            controller.carbsAvg.value,
            controller.carbsTarget.value,
            controller.carbsProgress.value,
            AppColors.carbsBlue,
            isDark,
          ),
          const VSpace16(),
          _buildMacroProgressBar(
            context,
            loc.fats,
            controller.fatsAvg.value,
            controller.fatsTarget.value,
            controller.fatsProgress.value,
            AppColors.fatsGreen,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroProgressBar(
    BuildContext context,
    String label,
    String current,
    String target,
    double progress,
    Color color,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppPadding.padding16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border20,
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const HSpace8(),
                  Text(
                    label,
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '$current / $target',
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const VSpace12(),
          ClipRRect(
            borderRadius: AppRadius.border8,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  /// Smart AI Nutrition Insights Card
  Widget _buildSmartInsightsCard(
    BuildContext context,
    AnalyticsController controller,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);

    return Obx(() {
      final avgCalStr =
          NumberFormat('#,###').format(controller.avgCalories.value);

      return Container(
        padding: EdgeInsets.all(AppPadding.padding20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.border24,
          boxShadow: AppShadows.cardSubtle(isDark),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: AppRadius.border12,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: theme.colorScheme.primary,
                    size: 20.sp,
                  ),
                ),
                const HSpace12(),
                Expanded(
                  child: Text(
                    loc.insightProteinMessage,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const VSpace14(),
            Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.08),
              height: 1,
            ),
            const VSpace14(),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    borderRadius: AppRadius.border12,
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: AppColors.accent,
                    size: 20.sp,
                  ),
                ),
                const HSpace12(),
                Expanded(
                  child: Text(
                    loc.insightCalorieMessage(avgCalStr),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
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

