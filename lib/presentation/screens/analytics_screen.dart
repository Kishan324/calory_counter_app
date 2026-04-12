import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.analytics, style: theme.textTheme.headlineLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.weeklyProgress, style: theme.textTheme.headlineMedium),
              SizedBox(height: 20.h),
              _buildChartCard(context, isDark, loc),
              SizedBox(height: 32.h),
              Text(loc.macroBreakdown, style: theme.textTheme.headlineMedium),
              SizedBox(height: 20.h),
              _buildMacroStats(context, isDark, loc),
              SizedBox(height: 200.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(
      BuildContext context, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
    return Container(
      height: 280.h,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.caloriesConsumed,
            style: theme.textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: loc.avg, style: theme.textTheme.labelMedium),
                TextSpan(
                    text: '1,850',
                    style: theme.textTheme.displayMedium!
                        .copyWith(fontSize: 14.sp)),
                TextSpan(
                    text: loc.kcalPerDay,
                    style: theme.textTheme.labelMedium),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final valDate =
                            DateTime(2024, 1, 1 + value.toInt());
                        final dayStr = DateFormat.E(
                                Localizations.localeOf(context).toString())
                            .format(valDate);
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
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(context, 0, 1800, isDark),
                  _buildBarGroup(context, 1, 2100, isDark),
                  _buildBarGroup(context, 2, 1950, isDark),
                  _buildBarGroup(context, 3, 1600, isDark),
                  _buildBarGroup(context, 4, 2200, isDark),
                  _buildBarGroup(context, 5, 2400, isDark),
                  _buildBarGroup(context, 6, 1750, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(
      BuildContext context, int x, double y, bool isDark) {
    final theme = Theme.of(context);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: theme.colorScheme.primary,
          width: 14.w,
          borderRadius: BorderRadius.circular(6.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 2500,
            color: theme.colorScheme.onSurface
                .withOpacity(isDark ? 0.1 : 0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroStats(
      BuildContext context, bool isDark, AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
            child: _buildStatCard(
                context, loc.protein, '112g', const Color(0xFFE57373), isDark)),
        SizedBox(width: 12.w),
        Expanded(
            child: _buildStatCard(
                context, loc.carbs, '225g', const Color(0xFF64B5F6), isDark)),
        SizedBox(width: 12.w),
        Expanded(
            child: _buildStatCard(
                context, loc.fats, '54g', const Color(0xFF81C784), isDark)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color color, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.02),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.circle, color: color, size: 12.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: theme.textTheme.displayMedium!
                .copyWith(color: theme.colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: theme.textTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
