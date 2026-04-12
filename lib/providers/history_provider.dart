import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../data/models/history_model.dart';
import '../data/services/api_service.dart';
import '../core/utils/toast_helper.dart';

class HistoryProvider with ChangeNotifier {
  final ApiService _apiService;

  HistoryProvider(this._apiService);

  DateTime _selectedDate = DateTime.now();
  List<HistoryModel> _historyList = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Track last fetched date string to prevent duplicate API calls
  String? _lastFetchedDateStr;

  DateTime get selectedDate => _selectedDate;
  List<HistoryModel> get historyList => _historyList;
  List<HistoryModel> _mockHistoryList = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<HistoryModel> get filteredHistory {
    return _mockHistoryList.where((item) {
      if (item.createdAt == null) return false;
      return isSameDay(item.createdAt!, _selectedDate);
    }).toList();
  }

  void loadMockData() {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));

    _mockHistoryList = [
      HistoryModel(
        id: 1,
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        name: 'Avocado Toast',
        calories: 320,
        createdAt: today,
      ),
      HistoryModel(
        id: 2,
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        name: 'Greek Salad',
        calories: 250,
        createdAt: today,
      ),
      HistoryModel(
        id: 3,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        name: 'Cheeseburger',
        calories: 680,
        createdAt: yesterday,
      ),
      HistoryModel(
        id: 4,
        imageUrl: 'https://images.unsplash.com/photo-1499028344343-cd173ffc68a9?w=400',
        name: 'Grilled Chicken',
        calories: 410,
        createdAt: yesterday,
      ),
      HistoryModel(
        id: 5,
        imageUrl: 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400',
        name: 'Oatmeal Bowl',
        calories: 210,
        createdAt: twoDaysAgo,
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }

  void changeDate(DateTime date) {
    final today = DateTime.now();
    // Prevent future dates
    if (date.isAfter(today) && !isSameDay(date, today)) {
       return;
    }

    if (isSameDay(_selectedDate, date)) {
      return; 
    }
    
    _selectedDate = date;
    notifyListeners();
    // TEMPORARY FOR MOCK TESTING: Do not call API
    // fetchHistoryByDate(date);
  }

  Future<void> fetchHistoryByDate(DateTime date) async {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);
    
    // Prevent duplicate calls for the same date
    if (_isLoading && _lastFetchedDateStr == dateStr) return;
    
    _isLoading = true;
    _errorMessage = null;
    _lastFetchedDateStr = dateStr;
    notifyListeners();

    try {
      final response = await _apiService.get('/history?date=$dateStr');
      
      if (response.data != null && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        _historyList = data.map((item) => HistoryModel.fromJson(item)).toList();
      } else {
        _errorMessage = response.data['message'] ?? 'Failed to load history';
        ToastHelper.showError(_errorMessage!);
        _historyList = [];
      }
    } on DioException catch (e) {
      _errorMessage = e.error?.toString() ?? e.message ?? 'An error occurred';
      ToastHelper.showError(_errorMessage!);
      _historyList = [];
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      ToastHelper.showError(_errorMessage!);
      _historyList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
