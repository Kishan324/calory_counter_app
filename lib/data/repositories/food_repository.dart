import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
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
      final file = File(imagePath);
      final bool fileExists = await file.exists();
      final String fileName = imagePath.split('/').last;

      print('--- DEBUG IMAGE UPLOAD ---');
      print('PATH: $imagePath');
      print('EXISTS: $fileExists');
      print('FILENAME: $fileName');

      final formData = FormData.fromMap({
        'image': [
          await MultipartFile.fromFile(
            imagePath,
            filename: fileName,
            // Depending on Dio version, Use DioMediaType if MediaType fails
            contentType: MediaType('image', 'jpeg'),
          )
        ]
      });

      final response = await apiService.post(
        '/analyze-food',
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

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
