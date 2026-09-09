import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_durations.dart';
import 'food_controller.dart';

/// Manages camera preview hardware lifecycle and image scanning state in ScannerScreen.
class ScannerController extends GetxController with GetSingleTickerProviderStateMixin {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final RxBool isCameraInitialized = false.obs;
  final RxBool isCameraLoading = true.obs;
  final RxBool isScanning = false.obs;
  final RxnString capturedImagePath = RxnString();
  final RxnString cameraError = RxnString();

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

  Future<void> _disposeCamera() async {
    if (cameraController != null) {
      try {
        await cameraController!.dispose();
      } catch (_) {}
      cameraController = null;
    }
  }

  Future<void> initializeCamera() async {
    isCameraLoading.value = true;
    isCameraInitialized.value = false;
    cameraError.value = null;
    await _disposeCamera();

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
      } else {
        cameraError.value = 'No camera found. Check permissions.';
      }
    } catch (e) {
      cameraError.value = e.toString();
      if (kDebugMode) {
        debugPrint('Camera init error: $e');
      }
      isCameraInitialized.value = false;
    } finally {
      isCameraLoading.value = false;
    }
  }

  Future<dynamic> captureAndScan() async {
    isScanning.value = true;

    try {
      String imagePathToScan;

      if (cameraController != null && cameraController!.value.isInitialized) {
        final XFile picture = await cameraController!.takePicture();
        imagePathToScan = picture.path;
      } else {
        final picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );

        if (pickedFile == null) {
          isScanning.value = false;
          return null;
        }
        imagePathToScan = pickedFile.path;
      }

      capturedImagePath.value = imagePathToScan;
      final foodCtrl = Get.find<FoodController>();
      final result = await foodCtrl.scanFood(imagePathToScan);

      isScanning.value = false;
      return result;
    } catch (e) {
      isScanning.value = false;
      capturedImagePath.value = null;
      rethrow;
    }
  }

  Future<dynamic> pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        isScanning.value = true;
        capturedImagePath.value = pickedFile.path;

        final foodCtrl = Get.find<FoodController>();
        final result = await foodCtrl.scanFood(pickedFile.path);

        isScanning.value = false;
        return result;
      }
      return null;
    } catch (e) {
      isScanning.value = false;
      capturedImagePath.value = null;
      rethrow;
    }
  }

  void resetCapturedImage() {
    capturedImagePath.value = null;
    isScanning.value = false;
  }

  @override
  void onClose() {
    cameraController?.dispose();
    animationController.dispose();
    super.onClose();
  }
}
