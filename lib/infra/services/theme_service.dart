import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class ThemeService extends ChangeNotifier {
  bool isDarkTheme = true;

  void toggle() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
