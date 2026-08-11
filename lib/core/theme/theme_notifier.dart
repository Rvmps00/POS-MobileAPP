import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_notifier.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _themeKey = 'app_theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_themeKey);
    if (themeStr == 'light') {
      state = ThemeMode.light;
    } else if (themeStr == 'dark') {
      state = ThemeMode.dark;
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, newTheme.name);
  }
}
