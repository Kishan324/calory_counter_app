import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_endpoints.dart';
import '../local/shared_prefs_helper.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (kDebugMode) {
            debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          
          final token = await SharedPrefsHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            debugPrint('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
            debugPrint('ERROR MESSAGE => ${e.message}');
          }
          
          if (e.response?.statusCode == 401) {
            await SharedPrefsHelper.clearAuth();
          }
          
          return handler.next(_handleError(e));
        },
      ),
    );
  }

  DioException _handleError(DioException error) {
  String errorDescription = "Unexpected error occurred";

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      errorDescription = "Connection timeout";
      break;

    case DioExceptionType.receiveTimeout:
      errorDescription = "Server is taking too long to respond";
      break;

    case DioExceptionType.sendTimeout:
      errorDescription = "Request timeout";
      break;

    case DioExceptionType.badResponse:
      if (error.response?.data != null &&
          error.response?.data is Map &&
          error.response?.data['message'] != null) {
        errorDescription = error.response?.data['message'];
      } else {
        errorDescription =
            "Server error: ${error.response?.statusCode}";
      }
      break;

    case DioExceptionType.connectionError:
      if (error.message != null &&
          error.message!.contains("SocketException")) {
        errorDescription = "No Internet connection";
      } else {
        errorDescription = "Unable to connect to server";
      }
      break;

    case DioExceptionType.cancel:
      errorDescription = "Request cancelled";
      break;

    case DioExceptionType.unknown:
    default:
      errorDescription = error.message ?? "Something went wrong";
      break;
  }

  return DioException(
    requestOptions: error.requestOptions,
    error: errorDescription,
    type: error.type,
    response: error.response,
  );
}

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.post(
        endpoint, 
        data: data, 
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(endpoint, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(endpoint, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
