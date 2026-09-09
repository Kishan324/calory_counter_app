import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../controllers/date_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_durations.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_space.dart';

/// Horizontal date selector strip displaying the 7 days of the week.
class DateStripWidget extends StatelessWidget {
  const DateStripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return SizedBox(
      height: 76.h,
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
            child: DateItemWidget(
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

class DateItemWidget extends StatelessWidget {
  final int index;
  final DateTime date;
  final String weekDayLabel;

  const DateItemWidget({
    super.key,
    required this.index,
    required this.date,
    required this.weekDayLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateController = Get.find<DateController>();

    return Obx(() {
      final isSelected = dateController.selectedIndex == index;

      return InkWell(
        borderRadius: AppRadius.border14,
        onTap: () => dateController.setSelectedIndex(index),
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 2.w),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.surface
                : theme.colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: AppRadius.border14,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface
                      .withValues(alpha: isDark ? 0.2 : 0.12),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.black.withValues(alpha: isDark ? 0.3 : 0.04)
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
                height: 24.w,
                width: 24.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.05),
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
              const VSpace2(),
              Text(
                '${date.day}',
                style: theme.textTheme.displayMedium!.copyWith(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
