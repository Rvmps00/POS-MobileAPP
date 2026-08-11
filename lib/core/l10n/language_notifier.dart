import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_notifier.g.dart';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  static const _langKey = 'app_language_code';

  @override
  Locale build() {
    _loadLanguage();
    return const Locale('id'); // Default to Indonesian
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langStr = prefs.getString(_langKey);
    if (langStr != null) {
      state = Locale(langStr);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, languageCode);
  }
}
