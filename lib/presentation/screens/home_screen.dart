import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/date_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_padding.dart';
import '../../core/theme/app_space.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home/date_strip_widget.dart';
import '../widgets/home/meal_section_card.dart';
import '../widgets/home/nutrition_card.dart';
import '../widgets/home/streak_badge.dart';
import '../widgets/home/water_tracker_card.dart';

/// Senior-Architect Dashboard Home Screen composing modular single-responsibility widgets.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final dateController = Get.find<DateController>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppDrawer(isHistorySelected: false),
      appBar: AppBar(
        title: Text(loc.caloryCounter, style: theme.textTheme.headlineMedium),
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: const Center(
              child: StreakBadge(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.padding24,
                vertical: AppPadding.padding8,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const DateStripWidget(),
                  const VSpace32(),
                  const NutritionSummaryCard(),
                  const VSpace24(),
                  const WaterTrackerCard(),
                  const VSpace32(),
                  Text(loc.mealsToday, style: theme.textTheme.headlineMedium),
                  const VSpace16(),
                  Obx(() {
                    final data = dateController.currentNutrition;

                    return Column(
                      children: [
                        MealSectionCard(
                          title: loc.breakfast,
                          calories: data.breakfastCalories,
                          icon: Icons.breakfast_dining_rounded,
                        ),
                        MealSectionCard(
                          title: loc.lunch,
                          calories: data.lunchCalories,
                          icon: Icons.lunch_dining_rounded,
                        ),
                        MealSectionCard(
                          title: loc.snacks,
                          calories: data.snacksCalories,
                          icon: Icons.bakery_dining_rounded,
                        ),
                        MealSectionCard(
                          title: loc.dinner,
                          calories: data.dinnerCalories,
                          icon: Icons.dinner_dining_rounded,
                        ),
                      ],
                    );
                  }),
                  const VSpace110(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
