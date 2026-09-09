import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/haptic_helper.dart';

/// Standardized senior-architect back button for consistent navigation across all screens.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20.sp,
        color: color ?? theme.colorScheme.onSurface,
      ),
      onPressed: () {
        HapticHelper.lightImpact();
        if (onPressed != null) {
          onPressed!();
        } else {
          Get.back();
        }
      },
    );
  }
}
