import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../core/theme/app_durations.dart';
import '../data/models/history_model.dart';
import '../data/services/api_service.dart';

/// Manages historical food consumption logs and date navigation using simulated mock data.
class HistoryController extends GetxController {
  final ApiService _apiService;

  HistoryController(this._apiService);

  ApiService get apiService => _apiService;

  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxList<HistoryModel> _historyList = <HistoryModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _errorMessage = RxnString();

  String? _lastFetchedDateStr;
  String? get lastFetchedDateStr => _lastFetchedDateStr;

  final RxInt _currentPage = 1.obs;
  final RxInt _lastPage = 1.obs;
  final RxInt _totalItems = 0.obs;

  DateTime get selectedDate => _selectedDate.value;
  List<HistoryModel> get historyList => _historyList;
  List<HistoryModel> get filteredHistory => _historyList;

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  int get currentPage => _currentPage.value;
  int get lastPage => _lastPage.value;
  int get totalItems => _totalItems.value;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Returns true if selectedDate is before today (meaning navigating forward 1 day is valid)
  bool canGoNext(DateTime date) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.isBefore(todayDate);
  }

  void changeDate(DateTime date) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    // Strict Future Date Guard: Never allow selecting any date after today
    if (targetDate.isAfter(todayDate)) {
      return;
    }

    if (isSameDay(_selectedDate.value, date)) {
      return;
    }

    _selectedDate.value = date;
    fetchHistoryByDate(date);
  }

  Future<void> fetchHistoryByDate(DateTime date) async {
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    _isLoading.value = true;
    _errorMessage.value = null;
    _currentPage.value = 1;
    _lastPage.value = 1;
    _lastFetchedDateStr = dateStr;

    await Future.delayed(AppDurations.normal);

    // Dynamic mock items for selected date
    final List<HistoryModel> mockItems = [
      HistoryModel(
        id: 1001,
        name: 'Oatmeal & Fresh Berries',
        calories: 340,
        imageUrl: 'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?w=500',
        createdAt: date.add(const Duration(hours: 8, minutes: 15)),
      ),
      HistoryModel(
        id: 1002,
        name: 'Grilled Chicken Caesar Salad',
        calories: 450,
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500',
        createdAt: date.add(const Duration(hours: 13, minutes: 00)),
      ),
      HistoryModel(
        id: 1003,
        name: 'Greek Yogurt & Almonds',
        calories: 210,
        imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500',
        createdAt: date.add(const Duration(hours: 16, minutes: 30)),
      ),
      HistoryModel(
        id: 1004,
        name: 'Pan-Seared Salmon & Asparagus',
        calories: 560,
        imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=500',
        createdAt: date.add(const Duration(hours: 19, minutes: 45)),
      ),
    ];

    _historyList.assignAll(mockItems);
    _totalItems.value = mockItems.length;
    _isLoading.value = false;
  }
}
