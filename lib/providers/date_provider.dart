import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  int _selectedIndex = 6; 

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
