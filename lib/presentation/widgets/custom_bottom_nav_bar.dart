import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.25),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.white.withOpacity(0.08),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(
                    icon: Icons.home_rounded,
                    label: loc.home,
                    index: 0,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  _BottomNavItem(
                    icon: Icons.bar_chart_rounded,
                    label: loc.analytics,
                    index: 1,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                  _BottomNavItem(
                    icon: Icons.person_rounded,
                    label: loc.profile,
                    index: 2,
                    currentIndex: currentIndex,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isSelected = currentIndex == index;
    final primaryColor = theme.colorScheme.primary;

    final iconColor =
        isSelected ? primaryColor : (isDark ? Colors.white54 : Colors.grey);
    final textColor =
        isSelected ? primaryColor : (isDark ? Colors.white54 : Colors.grey);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 75.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  style: isSelected
                      ? theme.textTheme.bodySmall!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp)
                      : theme.textTheme.bodySmall!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
