import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_space.dart';
import '../widgets/app_glass_button.dart';
import '../../controllers/onboarding_controller.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/feature_screens.dart';
import 'onboarding/user_info_screen.dart';
import 'onboarding/all_set_screen.dart';

/// Parent onboarding screen owning PageController, page indicators, and profile intake state via GetX.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    final controller = Get.put(OnboardingController());

    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Ambient Background Canvas ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          theme.colorScheme.primary.withValues(alpha: 0.14),
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          theme.colorScheme.primary.withValues(alpha: 0.07),
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor,
                        ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -40.h,
            right: -40.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.10),
                    theme.colorScheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // ── Page View ──
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: [
              WelcomeScreen(onNext: controller.nextPage),
              const CalorieFeatureScreen(),
              const AnalyticsFeatureScreen(),
              Obx(
                () => UserInfoScreen(
                  selectedGender: controller.selectedGender.value,
                  selectedDate: controller.selectedDate.value,
                  weightController: controller.weightController,
                  heightController: controller.heightController,
                  formError: controller.formError.value,
                  onGenderSelected: controller.setGender,
                  onDateSelected: controller.setBirthDate,
                ),
              ),
              const AllSetScreen(),
            ],
          ),

          // ── Top Navigation Header ──
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.padding20,
                  vertical: AppPadding.padding12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Step Counter Pill
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.padding14,
                          vertical: AppPadding.padding6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.white.withValues(alpha: 0.08)
                              : theme.colorScheme.surface,
                          borderRadius: AppRadius.border20,
                          border: Border.all(
                            color: isDark
                                ? AppColors.white.withValues(alpha: 0.12)
                                : AppColors.black.withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'STEP ${controller.currentPage.value + 1} OF ${OnboardingController.totalPages}',
                          style: theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                    // Skip Button
                    Obx(
                      () => controller.currentPage.value < OnboardingController.totalPages - 1
                          ? InkWell(
                              onTap: controller.skipOnboarding,
                              borderRadius: AppRadius.border20,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppPadding.padding14,
                                  vertical: AppPadding.padding6,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.08)
                                      : theme.colorScheme.surface,
                                  borderRadius: AppRadius.border20,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.white.withValues(alpha: 0.12)
                                        : AppColors.black.withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(alpha: 0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  loc.skip,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Bottom Floating Bar (Dots & Action Button) ──
          if (!keyboardVisible)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 24.h,
                    left: AppPadding.padding24,
                    right: AppPadding.padding24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page indicator pills
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(OnboardingController.totalPages, (i) {
                            final isActive = i == controller.currentPage.value;
                            return AnimatedContainer(
                              duration: AppDurations.medium,
                              curve: Curves.easeOutCubic,
                              margin: EdgeInsets.symmetric(horizontal: AppPadding.padding4),
                              width: isActive ? 28.w : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                                borderRadius: AppRadius.border10,
                                boxShadow: [
                                  BoxShadow(
                                    color: isActive
                                        ? theme.colorScheme.primary.withValues(alpha: 0.4)
                                        : AppColors.transparent,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const VSpace20(),
                      // Action CTA button
                      Obx(
                        () => AppGlassButton(
                          label: controller.currentPage.value == OnboardingController.totalPages - 1
                              ? loc.letsGo
                              : controller.currentPage.value == 0
                                  ? loc.getStarted
                                  : loc.continueBtn,
                          onTap: controller.nextPage,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
