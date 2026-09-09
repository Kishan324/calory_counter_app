import 'package:get/get.dart';

/// Nutrition data snapshot for a specific day.
class DateNutrition {
  final int consumedCalories;
  final int totalCalories;
  final int protein;
  final int totalProtein;
  final int carbs;
  final int totalCarbs;
  final int fats;
  final int totalFats;
  final int breakfastCalories;
  final int lunchCalories;
  final int snacksCalories;
  final int dinnerCalories;

  const DateNutrition({
    required this.consumedCalories,
    required this.totalCalories,
    required this.protein,
    required this.totalProtein,
    required this.carbs,
    required this.totalCarbs,
    required this.fats,
    required this.totalFats,
    required this.breakfastCalories,
    required this.lunchCalories,
    required this.snacksCalories,
    required this.dinnerCalories,
  });

  int get remainingCalories => (totalCalories - consumedCalories).clamp(0, totalCalories);
  double get calorieRatio => (consumedCalories / totalCalories).clamp(0.0, 1.0);
  double get proteinRatio => (protein / totalProtein).clamp(0.0, 1.0);
  double get carbsRatio => (carbs / totalCarbs).clamp(0.0, 1.0);
  double get fatsRatio => (fats / totalFats).clamp(0.0, 1.0);
}

/// Manages active date selector index and date-specific nutrition data using GetX.
class DateController extends GetxController {
  final RxInt _selectedIndex = 6.obs;

  int get selectedIndex => _selectedIndex.value;

  static const List<DateNutrition> _dailyData = [
    DateNutrition(
      consumedCalories: 1350,
      totalCalories: 2000,
      protein: 72,
      totalProtein: 120,
      carbs: 158,
      totalCarbs: 250,
      fats: 39,
      totalFats: 65,
      breakfastCalories: 340,
      lunchCalories: 500,
      snacksCalories: 140,
      dinnerCalories: 370,
    ),
    DateNutrition(
      consumedCalories: 1620,
      totalCalories: 2000,
      protein: 90,
      totalProtein: 120,
      carbs: 180,
      totalCarbs: 250,
      fats: 46,
      totalFats: 65,
      breakfastCalories: 380,
      lunchCalories: 560,
      snacksCalories: 180,
      dinnerCalories: 500,
    ),
    DateNutrition(
      consumedCalories: 980,
      totalCalories: 2000,
      protein: 55,
      totalProtein: 120,
      carbs: 112,
      totalCarbs: 250,
      fats: 28,
      totalFats: 65,
      breakfastCalories: 280,
      lunchCalories: 430,
      snacksCalories: 90,
      dinnerCalories: 180,
    ),
    DateNutrition(
      consumedCalories: 1950,
      totalCalories: 2000,
      protein: 115,
      totalProtein: 120,
      carbs: 238,
      totalCarbs: 250,
      fats: 61,
      totalFats: 65,
      breakfastCalories: 480,
      lunchCalories: 690,
      snacksCalories: 250,
      dinnerCalories: 530,
    ),
    DateNutrition(
      consumedCalories: 1420,
      totalCalories: 2000,
      protein: 78,
      totalProtein: 120,
      carbs: 165,
      totalCarbs: 250,
      fats: 42,
      totalFats: 65,
      breakfastCalories: 310,
      lunchCalories: 520,
      snacksCalories: 150,
      dinnerCalories: 440,
    ),
    DateNutrition(
      consumedCalories: 1750,
      totalCalories: 2000,
      protein: 102,
      totalProtein: 120,
      carbs: 215,
      totalCarbs: 250,
      fats: 54,
      totalFats: 65,
      breakfastCalories: 420,
      lunchCalories: 580,
      snacksCalories: 200,
      dinnerCalories: 550,
    ),
    DateNutrition(
      consumedCalories: 1200,
      totalCalories: 2000,
      protein: 45,
      totalProtein: 120,
      carbs: 150,
      totalCarbs: 250,
      fats: 30,
      totalFats: 65,
      breakfastCalories: 350,
      lunchCalories: 450,
      snacksCalories: 120,
      dinnerCalories: 280,
    ),
  ];

  final RxInt currentWaterMl = 1250.obs;
  final RxInt targetWaterMl = 2500.obs;
  final RxInt streakDays = 5.obs;

  double get waterRatio =>
      (currentWaterMl.value / targetWaterMl.value).clamp(0.0, 1.0);

  void addWaterIntake(int amountMl) {
    currentWaterMl.value =
        (currentWaterMl.value + amountMl).clamp(0, targetWaterMl.value * 2);
  }

  void resetWaterIntake() {
    currentWaterMl.value = 0;
  }

  DateNutrition get currentNutrition {
    final idx = _selectedIndex.value;
    if (idx >= 0 && idx < _dailyData.length) {
      return _dailyData[idx];
    }
    return _dailyData.last;
  }

  void setSelectedIndex(int index) {
    if (_selectedIndex.value != index) {
      _selectedIndex.value = index;
    }
  }
}
