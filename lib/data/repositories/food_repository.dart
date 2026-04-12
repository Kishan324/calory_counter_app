import 'dart:async';
import '../models/food_model.dart';
import '../services/api_service.dart';

class FoodRepository {
  final ApiService apiService;

  FoodRepository(this.apiService);

  Future<List<FoodModel>> getFoods() async {
    try {
      final response = await apiService.get('/foods');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => FoodModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (e) {
      throw Exception('Error fetching foods: $e');
    }
  }

  Future<FoodModel> scanFood(String imagePath) async {
    try {
      // Assuming a POST endpoint that takes the image
      // For real file uploads, FormData with MultipartFile would be used:
      // data: FormData.fromMap({'file': await MultipartFile.fromFile(imagePath)})
      final response = await apiService.post('/scan', data: {
        'image_path': imagePath,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FoodModel.fromJson(response.data);
      } else {
        throw Exception('Failed to scan food');
      }
    } catch (e) {
      throw Exception('Error scanning food: $e');
    }
  }
}
