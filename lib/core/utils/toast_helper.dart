import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_durations.dart';
import '../theme/app_radius.dart';
import '../theme/app_space.dart';

enum ToastType { success, error, info }

/// Premium Full-Width Glassmorphic Toast Notification utility.
class ToastHelper {
  static void showSuccess(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.success,
    );
  }

  static void showError(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.error,
    );
  }

  static void showInfo(String message, {String? title}) {
    showGlassToast(
      message: message,
      title: title,
      type: ToastType.info,
    );
  }

  static void showGlassToast({
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration? duration,
  }) {
    final context = Get.context;
    final isDark = context != null
        ? Theme.of(context).brightness == Brightness.dark
        : true;

    Color accentColor;
    IconData icon;
    String defaultTitle;

    switch (type) {
      case ToastType.success:
        accentColor = AppColors.primary;
        icon = Icons.check_circle_rounded;
        defaultTitle = 'Success';
        break;
      case ToastType.error:
        accentColor = AppColors.error;
        icon = Icons.error_rounded;
        defaultTitle = 'Notice';
        break;
      case ToastType.info:
        accentColor = AppColors.accent;
        icon = Icons.info_rounded;
        defaultTitle = 'Information';
        break;
    }

    final displayTitle = title ?? defaultTitle;

    Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      duration: duration ?? AppDurations.splashDelay,
      backgroundColor: AppColors.transparent,
      barBlur: 0,
      overlayBlur: 0,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.zero,
      messageText: ClipRRect(
        borderRadius: AppRadius.border20,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.black.withOpacity(0.7)
                  : AppColors.white.withOpacity(0.85),
              borderRadius: AppRadius.border20,
              border: Border.all(
                color: accentColor.withOpacity(0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 24.sp,
                  ),
                ),
                const HSpace14(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayTitle,
                        style: GoogleFonts.sora(
                          color: isDark ? AppColors.white : AppColors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const VSpace2(),
                      Text(
                        message,
                        style: GoogleFonts.inter(
                          color: isDark ? AppColors.white70 : AppColors.black54,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
