import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Controller for managing app theme
class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Get the current theme mode
  ThemeMode get themeMode => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  /// Check if dark mode is enabled
  bool get isDarkMode => _loadThemeFromBox();

  /// Load theme setting from storage
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  /// Save theme setting to storage
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Toggle between light and dark theme
  void toggleTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    update();
  }

  /// Set specific theme mode
  void setTheme(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
    _saveThemeToBox(themeMode == ThemeMode.dark);
    update();
  }
}
