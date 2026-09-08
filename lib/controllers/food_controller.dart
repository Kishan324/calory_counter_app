import 'dart:async';
import 'package:get/get.dart';
import '../core/utils/toast_helper.dart';
import '../data/models/food_model.dart';
import '../data/repositories/food_repository.dart';

/// Manages scanned food items and calorie database interactions using GetX.
class FoodController extends GetxController {
  final FoodRepository foodRepository;

  final RxList<FoodModel> _foods = <FoodModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();

  FoodController(this.foodRepository);

  List<FoodModel> get foods => _foods;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<void> fetchFoods() async {
    _setLoading(true);
    _error.value = null;

    try {
      final items = await foodRepository.getFoods();
      _foods.assignAll(items);
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Sends captured food image to backend scanner and records result
  Future<FoodModel?> scanFood(String imagePath) async {
    _setLoading(true);
    _error.value = null;

    try {
      final newFood = await foodRepository.scanFood(imagePath);
      _foods.add(newFood);
      ToastHelper.showSuccess(
        "Food item analyzed successfully",
        title: "AI Nutrition Scan",
      );
      return newFood;
    } catch (e) {
      _error.value = e.toString();
      ToastHelper.showError("Failed to analyze food item", title: "Scan Error");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }
}
