import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider to work with AppTheme
final appThemeProvider = ChangeNotifierProvider((ref) {
  return AppTheme(ref.watch(sharedPreferencesProvider));
});

// provider stores the instance SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  return throw UnimplementedError();
});
final lightTheme = ThemeData.light();
final darkTheme = ThemeData.dark();

class AppTheme extends ChangeNotifier {
  AppTheme(this._prefs) {
    // Initialize theme according to system setting
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    if (brightness == Brightness.dark) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
  }

  final SharedPreferences _prefs;
  bool _isDarkMode = false;

  bool getTheme() => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool(
        'isDarkMode', _isDarkMode); // Update theme setting in SharedPreferences
    notifyListeners();
  }

  void setTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _prefs.setBool(
        'isDarkMode', _isDarkMode); // Update theme setting in SharedPreferences
    notifyListeners();
  }
}
