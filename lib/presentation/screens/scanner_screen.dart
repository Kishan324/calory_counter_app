import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../../providers/food_provider.dart';
import 'food_result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  String? _capturedImagePath;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    _animationController = AnimationController(
       duration: const Duration(seconds: 2),
       vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _captureAndScan() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
        _isScanning = true;
    });

    try {
      final XFile picture = await _cameraController!.takePicture();
      
      if (!mounted) return;
      
      setState(() {
        _capturedImagePath = picture.path;
      });
      
      final provider = Provider.of<FoodProvider>(context, listen: false);
      final result = await provider.scanFood(picture.path);

      if (mounted) {
        setState(() {
          _isScanning = false;
        });

        if (result != null) {
          // Explicitly use FadeTransition to make it unmistakably a NEW screen,
          // avoiding the visual illusion of an Android slide-up bottom sheet
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => FoodResultScreen(
                food: result,
                imagePath: _capturedImagePath!,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
          
          // Resume camera stream if user dismisses the result without action
          if (mounted) {
            setState(() {
              _capturedImagePath = null;
            });
          }
        } else if (provider.error != null) {
          setState(() {
            _capturedImagePath = null; // Reset on failure
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error!)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _capturedImagePath = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Frozen Frame
          if (_capturedImagePath != null)
            Positioned.fill(
              child: Image.file(
                File(_capturedImagePath!),
                fit: BoxFit.cover,
              ),
            )
          else if (_isCameraInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          
          // Overlay UI
          if (_isCameraInitialized)
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 28),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Scan Food',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Balance for close button
                        ],
                      ),
                    ),
                    const Spacer(),
                    
                    // Viewfinder area with animation
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Stack(
                        children: [
                          // Viewfinder Border
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          // Scanning Line Animation
                          if (_isScanning)
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Positioned(
                                  top: _animation.value * 248,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Bottom Controls
                    Container(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: _isScanning
                          ? const SizedBox(height: 80) // Placed empty to allow overlay focus
                          : GestureDetector(
                              onTap: _captureAndScan,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),

          // Premium Loading Overlay (Shows during API mapping)
          if (_isScanning && _capturedImagePath != null)
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.55),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.5,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Analyzing your food...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Calories • Protein • Carbs • Fats',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
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
            ),
        ],
      ),
    );
  }
}
