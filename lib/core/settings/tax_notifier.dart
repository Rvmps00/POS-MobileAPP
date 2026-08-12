import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final taxEnabledProvider = NotifierProvider<TaxNotifier, bool>(TaxNotifier.new);

class TaxNotifier extends Notifier<bool> {
  static const _taxKey = 'is_tax_enabled';
  SharedPreferences? _prefs;

  @override
  bool build() {
    _init();
    return true; // Default
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final isEnabled = _prefs?.getBool(_taxKey) ?? true;
    state = isEnabled;
  }

  Future<void> toggleTax(bool value) async {
    state = value;
    await _prefs?.setBool(_taxKey, value);
  }
}
