import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';

class AnalyticsDetailScreen extends StatefulWidget {
  const AnalyticsDetailScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsDetailScreen> createState() => _AnalyticsDetailScreenState();
}

class _AnalyticsDetailScreenState extends State<AnalyticsDetailScreen> {
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.analyticsDetail, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.padding24,
            vertical: AppPadding.padding16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNutritionGradeHeroCard(context, isDark, loc),
              const VSpace24(),
              Text(loc.macroBreakdown, style: theme.textTheme.headlineMedium),
              const VSpace16(),
              _buildMacroDonutChartCard(context, isDark, loc),
              const VSpace32(),
              Text(loc.mealBreakdown, style: theme.textTheme.headlineMedium),
              const VSpace16(),
              _buildMealCategoryBreakdown(context, isDark, loc),
              const VSpace32(),
              Text(loc.recommendations, style: theme.textTheme.headlineMedium),
              const VSpace16(),
              _buildRecommendationsList(context, isDark, loc),
              const VSpace60(),
            ],
          ),
        ),
      ),
    );
  }

  /// Ultra-Executive, Vibrant & 100% Theme-Harmonized Nutrition Grade Hero Deck
  Widget _buildNutritionGradeHeroCard(
    BuildContext context,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
              // Ambient Decorative Orbs for 3D Depth
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
                  Icons.verified_rounded,
                  color: AppColors.white.withValues(alpha: 0.12),
                  size: 60.sp,
                ),
              ),

              // Hero Content
              Padding(
                padding: EdgeInsets.all(AppPadding.padding20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar Header: Glass Nutrition Grade Pill + Glowing Gold Badge
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
                                  color: Color(0xFF69F0AE),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const HSpace6(),
                              Text(
                                loc.nutritionGrade.toUpperCase(),
                                style: theme.textTheme.labelSmall!.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Radiant 3D Gold Top 5% Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFE082), // Amber Gold Light
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
                                Icons.workspace_premium_rounded,
                                color: AppColors.white,
                                size: 19,
                              ),
                              const HSpace4(),
                              Text(
                                'TOP 5%',
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

                    // Grade Badge Avatar & Description
                    Row(
                      children: [
                        // Glowing Metallic 'A+' Grade Circle Shield
                        Container(
                          width: 82.w,
                          height: 82.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white.withValues(alpha: 0.22),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.55),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.2),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'A+',
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 32.sp,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const HSpace18(),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.nutritionGrade,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                  fontSize: 19.sp,
                                ),
                              ),
                              const VSpace4(),
                              Text(
                                loc.nutritionScoreText,
                                style: theme.textTheme.bodySmall!.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.88),
                                  fontSize: 13.sp,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const VSpace20(),

                    // Multi-Metric Quick Stat Strip
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailGlassPill(
                            context: context,
                            icon: Icons.track_changes_rounded,
                            label: 'Target Met',
                            iconColor: const Color(0xFFFFE082),
                          ),
                        ),
                        const HSpace8(),
                        Expanded(
                          child: _buildDetailGlassPill(
                            context: context,
                            icon: Icons.pie_chart_rounded,
                            label: 'Optimal',
                            iconColor: AppColors.white,
                          ),
                        ),
                        const HSpace8(),
                        Expanded(
                          child: _buildDetailGlassPill(
                            context: context,
                            icon: Icons.emoji_events_rounded,
                            label: 'Top 5%',
                            iconColor: const Color(0xFFFFE082),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper for Glass Metric Stat Pills in Detail Screen
  Widget _buildDetailGlassPill({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color iconColor,
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

  /// Interactive Macro Donut Chart (`fl_chart` PieChart)
  Widget _buildMacroDonutChartCard(
    BuildContext context,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppPadding.padding20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border28,
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (!mounted) return;
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedPieIndex = -1;
                            return;
                          }
                          _touchedPieIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 4,
                    centerSpaceRadius: 60.r,
                    sections: [
                      PieChartSectionData(
                        color: AppColors.proteinRed,
                        value: 30,
                        title: '30%',
                        radius: _touchedPieIndex == 0 ? 32.r : 26.r,
                        titleStyle: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        color: AppColors.carbsBlue,
                        value: 50,
                        title: '50%',
                        radius: _touchedPieIndex == 1 ? 32.r : 26.r,
                        titleStyle: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        color: AppColors.fatsGreen,
                        value: 20,
                        title: '20%',
                        radius: _touchedPieIndex == 2 ? 32.r : 26.r,
                        titleStyle: theme.textTheme.labelMedium!.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  duration: AppDurations.normal,
                  curve: Curves.easeOutCubic,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '391g',
                      style: theme.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      loc.totalMacros,
                      style: theme.textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const VSpace20(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildMacroLegend(
                    context, loc.protein, '112g (30%)', AppColors.proteinRed),
              ),
              Expanded(
                child: _buildMacroLegend(
                    context, loc.carbs, '225g (50%)', AppColors.carbsBlue),
              ),
              Expanded(
                child: _buildMacroLegend(
                    context, loc.fats, '54g (20%)', AppColors.fatsGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroLegend(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const HSpace6(),
            Flexible(
              child: Text(
                title,
                style: theme.textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const VSpace4(),
        Text(
          value,
          style: theme.textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Meal Category Calorie Breakdown
  Widget _buildMealCategoryBreakdown(
    BuildContext context,
    bool isDark,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppPadding.padding20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.border28,
        boxShadow: AppShadows.cardSubtle(isDark),
      ),
      child: Column(
        children: [
          _buildMealRow(context, loc.breakfast, '520 kcal', 0.28, AppColors.amber),
          const VSpace16(),
          _buildMealRow(context, loc.lunch, '680 kcal', 0.36, theme.colorScheme.primary),
          const VSpace16(),
          _buildMealRow(context, loc.dinner, '450 kcal', 0.24, AppColors.accent),
          const VSpace16(),
          _buildMealRow(context, loc.snacks, '200 kcal', 0.12, AppColors.carbsBlue),
        ],
      ),
    );
  }

  Widget _buildMealRow(
    BuildContext context,
    String label,
    String calories,
    double ratio,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const HSpace8(),
            Text(
              calories,
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
          ],
        ),
        const VSpace8(),
        ClipRRect(
          borderRadius: AppRadius.border8,
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8.h,
            backgroundColor: color.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  /// Health Recommendations List
  Widget _buildRecommendationsList(
    BuildContext context,
    bool isDark,
    AppLocalizations loc,
  ) {
    return Column(
      children: [
        _buildRecommendationItem(
          context,
          Icons.water_drop_rounded,
          AppColors.carbsBlue,
          loc.hydrationScore,
          loc.hydrationTarget,
          isDark,
        ),
        const VSpace12(),
        _buildRecommendationItem(
          context,
          Icons.fitness_center_rounded,
          AppColors.proteinRed,
          loc.protein,
          loc.proteinAdvice,
          isDark,
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    IconData icon,
    Color color,
    String title,
    String subtitle,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22.sp,
            ),
          ),
          const HSpace14(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VSpace4(),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
