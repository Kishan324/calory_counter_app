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

  int _currentPage = 1;
  int _lastPage = 1;
  int _totalItems = 0;

  DateTime get selectedDate => _selectedDate;
  List<HistoryModel> get historyList => _historyList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get totalItems => _totalItems;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<HistoryModel> get filteredHistory {
    return _historyList;
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
    fetchHistoryByDate(date);
  }

  Future<void> fetchHistoryByDate(DateTime date) async {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    // Prevent duplicate calls for the same date
    if (_isLoading && _lastFetchedDateStr == dateStr) return;

    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    _lastPage = 1;
    _totalItems = 0;
    _lastFetchedDateStr = dateStr;
    notifyListeners();

    try {
      final response = await _apiService.get('/food-history?date=$dateStr');

      if (response.data != null) {
        final Map<String, dynamic> responseData =
            response.data is Map<String, dynamic>
                ? response.data as Map<String, dynamic>
                : {'data': response.data};

        final bool isSuccess =
            responseData['status'] == true || responseData['success'] == true;

        if (isSuccess) {
          final List<dynamic> data = responseData['data'] ?? [];
          _historyList =
              data.map((item) => HistoryModel.fromJson(item)).toList();

          if (responseData['pagination'] != null &&
              responseData['pagination'] is Map) {
            final pag = responseData['pagination'];
            _currentPage = pag['current_page'] is int
                ? pag['current_page']
                : int.tryParse(pag['current_page'].toString()) ?? 1;
            _lastPage = pag['last_page'] is int
                ? pag['last_page']
                : int.tryParse(pag['last_page'].toString()) ?? 1;
            _totalItems = pag['total'] is int
                ? pag['total']
                : int.tryParse(pag['total'].toString()) ?? 0;
          }
        } else {
          _errorMessage = responseData['message'] ?? 'Failed to load history';
          ToastHelper.showError(_errorMessage!);
          _historyList = [];
        }
      } else {
        _errorMessage = 'Failed to load history';
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
