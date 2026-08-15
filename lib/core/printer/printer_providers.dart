import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'printer_service.dart';

/// Provider for SharedPreferences (needs to be overridden in main.dart if not already)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Provider for the PrinterService
final printerServiceProvider = Provider<PrinterService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrinterService(prefs);
});

class PrinterConnectionNotifier extends Notifier<bool> {
  late PrinterService _printerService;

  @override
  bool build() {
    _printerService = ref.read(printerServiceProvider);
    _checkStatus();
    return false;
  }

  Future<void> _checkStatus() async {
    state = await _printerService.isConnected;
  }

  Future<void> refresh() async {
    await _checkStatus();
  }

  Future<bool> connect(String macAddress) async {
    final result = await _printerService.connect(macAddress);
    state = result;
    return result;
  }

  Future<bool> disconnect() async {
    final result = await _printerService.disconnect();
    if (result) {
      await _printerService.clearSavedPrinter();
      state = false;
    }
    return result;
  }
}

final printerConnectionProvider = NotifierProvider<PrinterConnectionNotifier, bool>(() {
  return PrinterConnectionNotifier();
});
