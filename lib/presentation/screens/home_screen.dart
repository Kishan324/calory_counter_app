import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';
import '../../providers/date_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(isHistorySelected: false),
      appBar: AppBar(
        title: Text(loc.caloryCounter, style: theme.textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DateStripWidget(),
                  SizedBox(height: 32.h),
                  _buildNutritionCard(context, isDark, loc),
                  SizedBox(height: 32.h),
                  Text(loc.mealsToday, style: theme.textTheme.headlineMedium),
                  SizedBox(height: 16.h),
                  _buildMealSection(context, loc.breakfast, '350',
                      Icons.breakfast_dining_rounded, isDark, loc),
                  _buildMealSection(context, loc.lunch, '0',
                      Icons.lunch_dining_rounded, isDark, loc),
                  _buildMealSection(context, loc.snacks, '120',
                      Icons.bakery_dining_rounded, isDark, loc),
                  _buildMealSection(context, loc.dinner, '0',
                      Icons.dinner_dining_rounded, isDark, loc),
                  SizedBox(height: 110.h),
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
    return Container(
      padding: EdgeInsets.all(20.w),
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
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildMacroCircular(context, loc.calories, 1200, 2000,
                  theme.colorScheme.primary, loc),
              SizedBox(width: 24.w),
              Expanded(
                child: Column(
                  children: [
                    _buildMacroBar(
                        context, loc.protein, 45, 120, const Color(0xFFE57373)),
                    SizedBox(height: 16.h),
                    _buildMacroBar(
                        context, loc.carbs, 150, 250, const Color(0xFF64B5F6)),
                    SizedBox(height: 16.h),
                    _buildMacroBar(
                        context, loc.fats, 30, 65, const Color(0xFF81C784)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCircular(BuildContext context, String title, int current,
      int total, Color color, AppLocalizations loc) {
    final theme = Theme.of(context);
    final double percent = current / total;
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 10,
            strokeCap: StrokeCap.round,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${total - current}',
                  style:
                      theme.textTheme.displayLarge!.copyWith(fontSize: 22.sp),
                ),
                SizedBox(height: 2.h),
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
      ),
    );
  }

  Widget _buildMacroBar(
      BuildContext context, String title, int current, int total, Color color) {
    final theme = Theme.of(context);
    final double percent = current / total;
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
                      text: '$current',
                      style: theme.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface)),
                  TextSpan(
                      text: ' / $total g', style: theme.textTheme.labelMedium),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 7.h,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, String title, String calories,
      IconData icon, bool isDark, AppLocalizations loc) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary
                        .withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 14.w),
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
                      SizedBox(height: 4.h),
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
                    Text(
                      calories,
                      style: theme.textTheme.displayMedium!
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      loc.kcal,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
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

class DateStripWidget extends StatefulWidget {
  const DateStripWidget({Key? key}) : super(key: key);

  @override
  State<DateStripWidget> createState() => _DateStripWidgetState();
}

class _DateStripWidgetState extends State<DateStripWidget> {
  late final List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _dates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_dates.length * 2 - 1, (i) {
          if (i.isOdd) {
            return SizedBox(width: 5.w);
          }

          final index = i ~/ 2;
          final date = _dates[index];
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

    return Selector<DateProvider, bool>(
      selector: (context, provider) => provider.selectedIndex == index,
      builder: (context, isSelected, child) {
        return GestureDetector(
          onTap: () {
            final provider = context.read<DateProvider>();
            if (provider.selectedIndex != index) {
              provider.setSelectedIndex(index);
            }
          },
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
            decoration: BoxDecoration(
              color:
                  isSelected ? theme.colorScheme.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : theme.colorScheme.onSurface
                        .withOpacity(isDark ? 0.2 : 0.12),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
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
                SizedBox(height: 4.h),
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
      },
    );
  }
}
