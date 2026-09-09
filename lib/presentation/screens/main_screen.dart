import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_space.dart';

import 'home_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../controllers/main_controller.dart';

/// Shell screen housing main navigation tabs and biometric security lock.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late final MainController controller;

  final List<Widget> _screens = const [
    HomeScreen(key: ValueKey('home')),
    AnalyticsScreen(key: ValueKey('analytics')),
    ProfileScreen(key: ValueKey('profile')),
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(MainController());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.handleAppResume(context);
    }
  }

  void _onFabTapped() {
    Get.to(() => const ScannerScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBody: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: AppDurations.normal,
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.04, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _screens[controller.currentIndex.value],
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h + bottomPadding,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IntrinsicWidth(
                        child: Obx(
                          () => CustomBottomNavBar(
                            currentIndex: controller.currentIndex.value,
                            onTap: controller.changeTab,
                          ),
                        ),
                      ),
                      const HSpace12(),
                      GestureDetector(
                        onTap: _onFabTapped,
                        child: Container(
                          height: AppSizes.avatarSizeMd,
                          width: AppSizes.avatarSizeMd,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.primaryButton(
                              theme.colorScheme.primary,
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!controller.isLocked.value) return const SizedBox.shrink();

          return Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: AppColors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded,
                          color: AppColors.white, size: 64.sp),
                      const VSpace16(),
                      Text(
                        AppLocalizations.of(context)?.appLocked ?? "App Locked",
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: AppColors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const VSpace8(),
                      TextButton(
                        onPressed: () => controller.checkLock(context),
                        child: Text(
                          AppLocalizations.of(context)?.tapToUnlock ?? "Tap to Unlock",
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
