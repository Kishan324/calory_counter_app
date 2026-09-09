import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';
import '../../controllers/scanner_controller.dart';
import 'food_result_screen.dart';

/// Camera food scanner screen managed reactively via GetX ScannerController.
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final ScannerController scannerCtrl;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ScannerController>()) {
      Get.delete<ScannerController>();
    }
    scannerCtrl = Get.put(ScannerController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<ScannerController>()) {
      Get.delete<ScannerController>();
    }
    super.dispose();
  }

  void _handleScan(BuildContext context, ScannerController scannerCtrl) async {
    try {
      final result = await scannerCtrl.captureAndScan();

      if (result != null) {
        await Get.to(
          () => FoodResultScreen(
            food: result,
            imagePath: scannerCtrl.capturedImagePath.value!,
          ),
          transition: Transition.fadeIn,
          duration: AppDurations.medium,
        );

        scannerCtrl.resetCapturedImage();
      }
    } catch (e) {
      Get.snackbar(
        'Scan Error',
        'Error scanning food item: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error.withValues(alpha: 0.8),
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Obx(() {
            final path = scannerCtrl.capturedImagePath.value;
            final isInit = scannerCtrl.isCameraInitialized.value;
            final isLoading = scannerCtrl.isCameraLoading.value;

            if (path != null) {
              return Positioned.fill(
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              );
            } else if (isInit &&
                scannerCtrl.cameraController != null &&
                scannerCtrl.cameraController!.value.isInitialized) {
              return Positioned.fill(
                child: CameraPreview(scannerCtrl.cameraController!),
              );
            } else if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              );
            } else {
              final error = scannerCtrl.cameraError.value;
              return Positioned.fill(
                child: Container(
                  color: AppColors.black,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_photography_rounded,
                            size: 64.sp,
                            color: AppColors.white.withValues(alpha: 0.4),
                          ),
                          const VSpace16(),
                          Text(
                            error != null && error.isNotEmpty
                                ? error
                                : 'Camera unavailable',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sora(
                              color: AppColors.white.withValues(alpha: 0.6),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const VSpace24(),
                          TextButton.icon(
                            onPressed: () => scannerCtrl.initializeCamera(),
                            icon: const Icon(Icons.refresh_rounded,
                                color: AppColors.white),
                            label: Text(
                              'Retry',
                              style: GoogleFonts.sora(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(AppPadding.padding16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close,
                              color: AppColors.white, size: 28),
                          onPressed: () => Get.back(),
                        ),
                        Expanded(
                          child: Text(
                            'Scan Food',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sora(
                              color: AppColors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_library_rounded,
                              color: AppColors.white, size: 26),
                          onPressed: () async {
                            final result = await scannerCtrl.pickFromGallery();
                            if (result != null && context.mounted) {
                              await Get.to(
                                () => FoodResultScreen(
                                  food: result,
                                  imagePath: scannerCtrl.capturedImagePath.value!,
                                ),
                                transition: Transition.fadeIn,
                                duration: AppDurations.medium,
                              );
                              scannerCtrl.resetCapturedImage();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                    const Spacer(),
                    SizedBox(
                      width: 250.w,
                      height: 250.w,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.white.withValues(alpha: 0.5), width: 2),
                              borderRadius: AppRadius.border24,
                            ),
                          ),
                          Obx(() {
                            if (!scannerCtrl.isScanning.value) {
                              return const SizedBox.shrink();
                            }

                            return AnimatedBuilder(
                              animation: scannerCtrl.animation,
                              builder: (context, child) {
                                return Positioned(
                                  top: scannerCtrl.animation.value * 248.h,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      boxShadow: AppShadows.glassButton(
                                        Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.only(bottom: AppPadding.padding32),
                      child: Obx(() {
                        if (scannerCtrl.isScanning.value) {
                          return const VSpace80();
                        }

                        return GestureDetector(
                          onTap: () => _handleScan(context, scannerCtrl),
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.white, width: 4),
                            ),
                            child: Center(
                              child: Container(
                                width: 64.w,
                                height: 64.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          Obx(() {
            if (scannerCtrl.isScanning.value &&
                scannerCtrl.capturedImagePath.value != null) {
              return Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      color: AppColors.black.withValues(alpha: 0.55),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 64,
                              height: 64,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 3.5,
                              ),
                            ),
                            VSpace32(),
                            Text(
                              'Analyzing your food...',
                              style: GoogleFonts.sora(
                                color: AppColors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const VSpace12(),
                            Text(
                              'Calories • Protein • Carbs • Fats',
                              style: GoogleFonts.inter(
                                color: AppColors.white70,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
