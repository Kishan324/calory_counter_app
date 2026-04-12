import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_screen.dart';
import 'analytics_screen.dart';
import 'profile_screen.dart';
import 'scanner_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../data/services/biometric_service.dart';
import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isLocked = false;
  bool _hasCheckedOnce = false;

  @override
  void initState() {
    super.initState();
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
      if (!_hasCheckedOnce) {
        _hasCheckedOnce = true;
        return; // 🔥 skip first resume
      }

      _checkLock();
    }
  }

  bool _isAuthenticating = false;

  Future<void> _checkLock() async {
    if (_isAuthenticating) return; // 🔥 prevent loop

    final bioService = BiometricService();

    if (await bioService.isAppLockEnabled() &&
        await bioService.isBiometricAvailable()) {
      _isAuthenticating = true; // 🔥 start lock

      setState(() {
        _isLocked = true;
      });

      final authenticated = await bioService.authenticate(
        localizedReason: AppLocalizations.of(context)!.authenticateToUnlock,
      );

      _isAuthenticating = false; // 🔥 reset

      if (authenticated) {
        if (mounted) {
          setState(() {
            _isLocked = false;
          });
        }
      }
    }
  }

  final List<Widget> _screens = const [
    HomeScreen(key: ValueKey('home')),
    AnalyticsScreen(key: ValueKey('analytics')),
    ProfileScreen(key: ValueKey('profile')),
  ];

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  void _onFabTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerScreen()),
    );
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
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
                  child: _screens[_currentIndex],
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
                        child: CustomBottomNavBar(
                          currentIndex: _currentIndex,
                          onTap: _onTabTapped,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: _onFabTapped,
                        child: Container(
                          height: 64.w,
                          width: 64.w,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.35),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
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
        if (_isLocked)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_rounded,
                          color: Colors.white, size: 64.sp),
                      SizedBox(height: 16.h),
                      Text(
                        AppLocalizations.of(context)!.appLocked,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextButton(
                        onPressed: _checkLock,
                        child: Text(
                          AppLocalizations.of(context)!.tapToUnlock,
                          style: TextStyle(
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
          ),
      ],
    );
  }
}
