import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'auth/auth_entry_screen.dart';
import 'onboarding_screen.dart';
import 'main_screen.dart';
import '../../data/services/biometric_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _startTimer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    Timer(const Duration(milliseconds: 2000), _navigateToNext);
  }

  void _navigateToNext() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool appLockEnabled = prefs.getBool('appLock') ?? false;

    // Debug logs
    debugPrint("--- Splash Navigation Debug ---");
    debugPrint("isFirstTime: $isFirstTime");
    debugPrint("isLoggedIn: $isLoggedIn");
    debugPrint("appLockEnabled: $appLockEnabled");
    debugPrint("-------------------------------");

    if (!isFirstTime && isLoggedIn && appLockEnabled) {
      final bioService = BiometricService();
      if (await bioService.isBiometricAvailable()) {
        final authenticated = await bioService.authenticate(
          localizedReason: AppLocalizations.of(context)!.authenticateToUnlock,
        );

        if (!authenticated) {
          if (mounted) {
            _showLockRetryDialog(isFirstTime, isLoggedIn);
          }
          return;
        }
      }
    }

    _proceedToTarget(isFirstTime, isLoggedIn);
  }

  void _proceedToTarget(bool isFirstTime, bool isLoggedIn) {
    if (!mounted) return;

    Widget targetScreen;
    if (isFirstTime) {
      targetScreen = const OnboardingScreen();
    } else if (!isLoggedIn) {
      targetScreen = const MainScreen();
    } else {
      targetScreen = const MainScreen();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
      (route) => false,
    );
  }

  void _showLockRetryDialog(bool isFirstTime, bool isLoggedIn) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        title: const Text('App Locked', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Authentication is required to access your data.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToNext();
            },
            child: Text('Retry', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    color: theme.colorScheme.primary,
                    size: 60.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'FitCal',
                  style: theme.textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Calory Counter and Diet App',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
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
