import 'package:get/get.dart';

/// GetX Controller for managing weekly analytics progress and macro nutrient statistics.
class AnalyticsController extends GetxController {
  final RxDouble avgCalories = 1850.0.obs;
  final RxDouble maxCalorieLimit = 2500.0.obs;

  final RxList<double> weeklyCalorieData = <double>[
    1800,
    2100,
    1950,
    1600,
    2200,
    2400,
    1750,
  ].obs;

  final RxString proteinAvg = '112g'.obs;
  final RxString carbsAvg = '225g'.obs;
  final RxString fatsAvg = '54g'.obs;

  void updateWeeklyData(List<double> newData) {
    weeklyCalorieData.value = newData;
  }
}
