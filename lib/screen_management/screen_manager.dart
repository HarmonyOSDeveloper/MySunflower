// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ScreenManager extends ChangeNotifier {
  int _screenIndex = 0;
  int get screenIndex => _screenIndex;

  void changeScreen(int index) {
    _screenIndex = index;
    notifyListeners();
  }
}
