import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_durations.dart';
import 'food_controller.dart';

/// Manages camera preview hardware lifecycle and image scanning state in ScannerScreen.
class ScannerController extends GetxController with GetSingleTickerProviderStateMixin {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final RxBool isCameraInitialized = false.obs;
  final RxBool isScanning = false.obs;
  final RxnString capturedImagePath = RxnString();

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();

    animationController = AnimationController(
      duration: AppDurations.splashDelay,
      vsync: this,
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<dynamic> captureAndScan() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }

    isScanning.value = true;

    try {
      final XFile picture = await cameraController!.takePicture();
      capturedImagePath.value = picture.path;

      final foodCtrl = Get.find<FoodController>();
      final result = await foodCtrl.scanFood(picture.path);

      isScanning.value = false;
      return result;
    } catch (e) {
      isScanning.value = false;
      capturedImagePath.value = null;
      rethrow;
    }
  }

  void resetCapturedImage() {
    capturedImagePath.value = null;
  }

  @override
  void onClose() {
    cameraController?.dispose();
    animationController.dispose();
    super.onClose();
  }
}
