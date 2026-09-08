import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_space.dart';

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
      height: AppSizes.navBarHeight,
      decoration: BoxDecoration(
        borderRadius: AppRadius.border28,
        border: Border.all(
          color: isDark
              ? AppColors.white.withOpacity(0.15)
              : AppColors.white.withOpacity(0.25),
          width: 2,
        ),
        boxShadow: AppShadows.header(isDark),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.border28,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.black.withOpacity(0.4)
                  : AppColors.white.withOpacity(0.08),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.padding12, vertical: AppPadding.padding6),
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
        isSelected ? primaryColor : (isDark ? AppColors.white54 : AppColors.textSubLight);
    final textColor =
        isSelected ? primaryColor : (isDark ? AppColors.white54 : AppColors.textSubLight);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 75.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.padding2, vertical: AppPadding.padding4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.15 : 1.0,
                duration: AppDurations.normal,
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: AppSizes.iconLg,
                  ),
                ),
              ),
              const VSpace4(),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: AppDurations.normal,
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
