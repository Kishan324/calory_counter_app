import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_space.dart';
import '../../core/utils/toast_helper.dart';
import '../widgets/app_primary_button.dart';

class FoodResultScreen extends StatelessWidget {
  final dynamic food;
  final String imagePath;

  const FoodResultScreen({
    Key? key,
    required this.food,
    required this.imagePath,
  }) : super(key: key);

  String _formatFoodName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((w) => w.isNotEmpty
            ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Extract details safely
    Map<String, dynamic> foodMap = {};
    try {
      foodMap = food.toJson();
    } catch (_) {
      try {
        foodMap = Map<String, dynamic>.from(food);
      } catch (_) {}
    }

    final String rawName =
        (foodMap['name'] ?? food.name ?? 'Unknown Food').toString();
    final String foodName = _formatFoodName(rawName);

    final num caloriesRaw = foodMap['calories'] ?? food.calories ?? 0;
    final int calories = caloriesRaw.round();
    final double protein = (foodMap['protein'] as num?)?.toDouble() ?? 0.0;
    final double carbs = (foodMap['carbs'] as num?)?.toDouble() ?? 0.0;
    final double fats = (foodMap['fats'] as num?)?.toDouble() ??
        (foodMap['fat'] as num?)?.toDouble() ??
        0.0;

    double sugar = 1.24;
    try {
      sugar = (foodMap['sugar'] as num?)?.toDouble() ??
          (food.sugar as num?)?.toDouble() ??
          1.24;
    } catch (_) {}

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // A: Background Image Header (Top 45% of screen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),

          // Image Gradient Overlay for legibility
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.4),
                    AppColors.transparent,
                    AppColors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // C: Main Content Screen (Anchored to fill the bottom area)
          Positioned(
            top:
                screenHeight * 0.45 - 32.h, // Overlaps the image slightly by 32px
            left: 0,
            right: 0,
            bottom: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 400.0, end: 0.0),
              duration: AppDurations.slow,
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(AppRadius.radius32)),
                  boxShadow: AppShadows.header(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(AppRadius.radius32)),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppPadding.padding24,
                      right: AppPadding.padding24,
                      top: AppPadding.padding32,
                      bottom: MediaQuery.of(context).padding.bottom + AppPadding.padding40,
                    ),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // D: Food Title
                        Text(
                          foodName,
                          style: GoogleFonts.sora(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const VSpace32(),

                        // E: Calories Highlight Card
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.h, horizontal: AppPadding.padding24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(200),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: AppRadius.border28,
                            boxShadow: AppShadows.primaryButton(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Calories',
                                    style: GoogleFonts.inter(
                                      color: AppColors.white70,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const VSpace6(),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(AppPadding.padding4),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                            Icons.local_fire_department_rounded,
                                            color: AppColors.accent,
                                            size: 16),
                                      ),
                                      const HSpace8(),
                                      Text(
                                        'Estimated Energy',
                                        style: GoogleFonts.inter(
                                          color: AppColors.white70,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$calories',
                                    style: GoogleFonts.sora(
                                      color: AppColors.white,
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.w900,
                                      height: 1,
                                    ),
                                  ),
                                  const HSpace4(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Text(
                                      'kcal',
                                      style: GoogleFonts.inter(
                                        color: AppColors.white70,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const VSpace40(),

                        // F: Macronutrients Title & Row
                        Text(
                          'Macronutrients',
                          style: GoogleFonts.sora(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const VSpace16(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMacroCard(
                                context,
                                'Protein',
                                protein,
                                AppColors.proteinRed,
                                Icons.fitness_center_rounded),
                            _buildMacroCard(context, 'Carbs', carbs,
                                AppColors.carbsBlue, Icons.bolt_rounded),
                            _buildMacroCard(
                                context,
                                'Fat',
                                fats,
                                AppColors.fatsGreen,
                                Icons.water_drop_rounded),
                            _buildMacroCard(
                                context,
                                'Sugar',
                                sugar,
                                AppColors.sugarPurple,
                                Icons.cookie_rounded),
                          ],
                        ),
                        const VSpace48(),

                        // G: CTA Button
                        AppPrimaryButton(
                          text: 'Add to Diary',
                          onPressed: () {
                            Get.back(); // Close ResultScreen
                            Get.back(); // Close ScannerScreen
                            ToastHelper.showSuccess(
                              "Logged $foodName to food diary",
                              title: "Diary Updated",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // B: Top Section: Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 8.w,
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(AppPadding.padding8),
                decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white, size: 20),
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(BuildContext context, String label, double value,
      Color color, IconData icon) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppPadding.padding4),
        padding: EdgeInsets.symmetric(vertical: AppPadding.padding16, horizontal: AppPadding.padding4),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? color.withOpacity(0.12)
              : color.withOpacity(0.08),
          borderRadius: AppRadius.border24,
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const VSpace12(),
            Text(
              '${value.toStringAsFixed(1)}g',
              style: GoogleFonts.inter(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const VSpace4(),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.white54
                    : AppColors.black54,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
