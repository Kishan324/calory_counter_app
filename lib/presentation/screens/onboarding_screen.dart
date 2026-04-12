import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/onboarding_provider.dart';
import '../../data/models/user_model.dart';
import 'auth/auth_entry_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'onboarding/feature_screens.dart';
import 'onboarding/user_info_screen.dart';
import 'onboarding/all_set_screen.dart';

/// Parent controller screen — owns PageController, navigation logic,
/// page indicator, skip button, and user form state.
/// Each page is a separate, modular widget imported from onboarding/.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  // ── User form state (owned here, passed down to UserInfoScreen) ──
  String _selectedGender = '';
  DateTime? _selectedDate;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _formError;

  static const int _totalPages = 5;

  @override
  void initState() {
    super.initState();
    final savedIndex = context.read<OnboardingProvider>().savedPageIndex;
    _currentPage = savedIndex;
    _pageController = PageController(initialPage: savedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // ── Navigation ───────────────────────────────────────────────────

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
      _formError = null;
    });
    context.read<OnboardingProvider>().savePageIndex(index);
  }

  void _nextPage() {
    // Validate user info before moving from page 3
    if (_currentPage == 3) {
      if (_selectedGender.isEmpty) {
        setState(() => _formError = 'Please select your gender');
        return;
      }
      if (_selectedDate == null) {
        setState(() => _formError = 'Please select your birth date');
        return;
      }
      final weight = double.tryParse(_weightController.text.trim());
      if (weight == null || weight <= 0) {
        setState(() => _formError = 'Please enter a valid weight');
        return;
      }
      final height = double.tryParse(_heightController.text.trim());
      if (height == null || height <= 0) {
        setState(() => _formError = 'Please enter a valid height');
        return;
      }
      setState(() => _formError = null);

      context.read<OnboardingProvider>().saveUserData(UserModel(
            gender: _selectedGender,
            birthDate: _selectedDate!,
            weight: weight,
            height: height,
          ));
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    await context.read<OnboardingProvider>().completeOnboarding();
    
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthEntryScreen()),
      (route) => false,
    );
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor,
                        ]
                      : [
                          theme.colorScheme.primary.withOpacity(0.08),
                          theme.scaffoldBackgroundColor,
                          theme.scaffoldBackgroundColor,
                        ],
                ),
              ),
            ),
          ),

          // ── PageView with modular screen widgets ──
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: [
              // Page 0
              WelcomeScreen(onNext: _nextPage),
              // Page 1
              const CalorieFeatureScreen(),
              // Page 2
              const AnalyticsFeatureScreen(),
              // Page 3
              UserInfoScreen(
                selectedGender: _selectedGender,
                selectedDate: _selectedDate,
                weightController: _weightController,
                heightController: _heightController,
                formError: _formError,
                onGenderSelected: (g) => setState(() {
                  _selectedGender = g;
                  _formError = null;
                }),
                onDateSelected: (d) => setState(() {
                  _selectedDate = d;
                  _formError = null;
                }),
              ),
              // Page 4
              const AllSetScreen(),
            ],
          ),

          // ── Skip button (top-right) ──
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, right: 16.w),
                child: _currentPage < _totalPages - 1
                    ? TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          loc.skip,
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Page indicator + CTA button (bottom) ──
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: 40.h, left: 24.w, right: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated dot indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_totalPages, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin:
                              EdgeInsets.symmetric(horizontal: 4.w),
                          width: isActive ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface
                                    .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),
                    // Glass CTA button
                    _GlassButton(
                      label: _currentPage == _totalPages - 1
                          ? loc.letsGo
                          : _currentPage == 0
                              ? loc.getStarted
                              : loc.continueBtn,
                      onTap: _nextPage,
                      theme: theme,
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

// ─── Glass CTA button ─────────────────────────────────────────────

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.label,
    required this.onTap,
    required this.theme,
  });
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            height: 56.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
