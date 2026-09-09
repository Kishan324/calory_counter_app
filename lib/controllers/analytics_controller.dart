import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import '../core/utils/toast_helper.dart';

/// GetX Controller for managing fitness intelligence analytics, health scores, and macro progress.
class AnalyticsController extends GetxController {
  final RxInt selectedTimeframe = 0.obs;
  final RxInt touchedPieIndex = (-1).obs;

  final RxDouble avgCalories = 1850.0.obs;
  final RxDouble maxCalorieLimit = 2500.0.obs;
  final RxInt healthScore = 88.obs;
  final RxInt currentStreak = 5.obs;

  final RxList<double> weeklyCalorieData = <double>[
    1800,
    2100,
    1950,
    1600,
    2200,
    2400,
    1750,
  ].obs;

  final RxList<double> monthlyCalorieData = <double>[
    1890,
    2050,
    1780,
    1920,
  ].obs;

  final RxString proteinAvg = '112g'.obs;
  final RxString proteinTarget = '130g'.obs;
  final RxDouble proteinProgress = 0.86.obs;

  final RxString carbsAvg = '225g'.obs;
  final RxString carbsTarget = '280g'.obs;
  final RxDouble carbsProgress = 0.80.obs;

  final RxString fatsAvg = '54g'.obs;
  final RxString fatsTarget = '70g'.obs;
  final RxDouble fatsProgress = 0.77.obs;

  List<double> get currentCalorieData =>
      selectedTimeframe.value == 0 ? weeklyCalorieData : monthlyCalorieData;

  void setTimeframe(int index) {
    selectedTimeframe.value = index;
    if (index == 0) {
      avgCalories.value = 1850.0;
      healthScore.value = 88;
    } else {
      avgCalories.value = 1940.0;
      healthScore.value = 92;
    }
  }

  void updateWeeklyData(List<double> newData) {
    weeklyCalorieData.value = newData;
  }

  void setTouchedPieIndex(int index) {
    touchedPieIndex.value = index;
  }

  void exportNutritionReport(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final reportTitle = loc?.reportExported ?? 'Nutrition Report Exported';
    final reportMessage =
        '${loc?.weeklyProgress ?? "Weekly Progress"}: ${avgCalories.value.toInt()} kcal/day | Protein: ${proteinAvg.value} | Carbs: ${carbsAvg.value} | Fats: ${fatsAvg.value}';

    ToastHelper.showSuccess(
      reportMessage,
      title: reportTitle,
    );
  }
}

