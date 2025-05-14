import 'package:flutter/material.dart';

/// Provider for theme management
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _showThemeIndicator = false;

  /// Check if dark mode is enabled
  bool get isDarkMode => _isDarkMode;

  /// Get the current theme mode
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Check if theme change indicator should be shown
  bool get showThemeIndicator => _showThemeIndicator;

  /// Toggle theme between light and dark mode
  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _showThemeIndicator = true;
    notifyListeners();

    // Hide the indicator after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _showThemeIndicator = false;
      notifyListeners();
    });
  }
}
