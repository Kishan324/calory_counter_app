import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/models/food_model.dart';
import '../data/repositories/food_repository.dart';

class FoodProvider with ChangeNotifier {
  final FoodRepository foodRepository;
  
  List<FoodModel> _foods = [];
  bool _isLoading = false;
  String? _error;

  FoodProvider(this.foodRepository);

  List<FoodModel> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFoods() async {
    _setLoading(true);
    _error = null;

    try {
      _foods = await foodRepository.getFoods();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<FoodModel?> scanFood(String imagePath) async {
    _setLoading(true);
    _error = null;

    try {
      final newFood = await foodRepository.scanFood(imagePath);
      // Add the newly scanned food item to our list
      _foods.add(newFood);
      return newFood; // Return so the UI can display its details
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
