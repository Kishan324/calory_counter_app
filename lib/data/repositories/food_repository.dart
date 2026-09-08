import 'dart:async';
import 'dart:math';

import '../../core/theme/app_durations.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';

/// Repository providing simulated mock food analysis and template nutrition data.
class FoodRepository {
  final ApiService apiService;

  FoodRepository(this.apiService);

  static final List<FoodModel> _mockFoodTemplates = [
    FoodModel(
      name: 'Avocado Toast with Eggs',
      calories: 420,
      protein: 18.5,
      fat: 22.0,
      carbs: 34.0,
      sugar: 2.1,
    ),
    FoodModel(
      name: 'Grilled Chicken Salad',
      calories: 380,
      protein: 42.0,
      fat: 14.0,
      carbs: 18.0,
      sugar: 3.5,
    ),
    FoodModel(
      name: 'Salmon Bowl with Quinoa',
      calories: 540,
      protein: 36.0,
      fat: 24.0,
      carbs: 45.0,
      sugar: 1.8,
    ),
    FoodModel(
      name: 'Greek Yogurt & Berries',
      calories: 220,
      protein: 16.0,
      fat: 4.5,
      carbs: 26.0,
      sugar: 12.0,
    ),
  ];

  Future<List<FoodModel>> getFoods() async {
    await Future.delayed(AppDurations.slow);
    return List.from(_mockFoodTemplates);
  }

  Future<FoodModel> scanFood(String imagePath) async {
    await Future.delayed(AppDurations.splashDelay);

    // Pick a random template to simulate smart AI food scanner output
    final random = Random();
    final template = _mockFoodTemplates[random.nextInt(_mockFoodTemplates.length)];

    return FoodModel(
      name: template.name,
      calories: template.calories,
      protein: template.protein,
      fat: template.fat,
      carbs: template.carbs,
      sugar: template.sugar,
    );
  }
}
