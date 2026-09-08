import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<UserProfile> getProfile() async {
    try {
      final response = await _apiService.post(
        '/profile',
        data: FormData(),
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception("Failed to load profile");
      }
    } on DioException catch (e) {
      throw e.error ?? "Failed to fetch profile details.";
    } catch (e) {
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }

  /// Update user profile details (multipart form-data)
  Future<UserProfile> updateProfile({
    String? name,
    String? imagePath,
    double? weightGoal,
    int? dailyCalories,
  }) async {
    try {
      final Map<String, dynamic> dataMap = {};

      if (name != null) {
        dataMap['name'] = name;
      }
      if (weightGoal != null) {
        dataMap['weight_goal'] = weightGoal;
      }
      if (dailyCalories != null) {
        dataMap['daily_calories'] = dailyCalories;
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        final bool fileExists = await file.exists();
        if (fileExists) {
          final String fileName = imagePath.split('/').last;
          dataMap['profile_image'] = await MultipartFile.fromFile(
            imagePath,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          );
        }
      }

      final formData = FormData.fromMap(dataMap);

      final response = await _apiService.post(
        '/profile',
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserProfile.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception("Failed to update profile");
      }
    } on DioException catch (e) {
      throw e.error ?? "Failed to update profile details.";
    } catch (e) {
      throw "An unexpected error occurred: ${e.toString()}";
    }
  }
}
