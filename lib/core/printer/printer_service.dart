import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'receipt_builder.dart';

class PrinterService {
  final SharedPreferences _prefs;
  static const String _savedMacAddressKey = 'saved_printer_mac_address';
  
  PrinterService(this._prefs);

  /// Get the saved printer MAC address for auto-reconnect
  String? get savedMacAddress => _prefs.getString(_savedMacAddressKey);

  /// Save a printer MAC address for auto-reconnect
  Future<void> saveMacAddress(String macAddress) async {
    await _prefs.setString(_savedMacAddressKey, macAddress);
  }
  
  /// Clear the saved printer
  Future<void> clearSavedPrinter() async {
    await _prefs.remove(_savedMacAddressKey);
  }

  /// Check if bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    return await PrintBluetoothThermal.bluetoothEnabled;
  }

  /// Scan for paired bluetooth devices
  Future<List<BluetoothInfo>> getPairedDevices() async {
    final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;
    return listResult;
  }

  /// Connect to a specific printer by MAC address
  Future<bool> connect(String macAddress) async {
    try {
      final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
      if (result) {
        await saveMacAddress(macAddress);
      }
      return result;
    } catch (e) {
      debugPrint('Error connecting to printer: $e');
      return false;
    }
  }

  /// Disconnect the current printer
  Future<bool> disconnect() async {
    try {
      return await PrintBluetoothThermal.disconnect;
    } catch (e) {
      debugPrint('Error disconnecting printer: $e');
      return false;
    }
  }

  /// Check connection status
  Future<bool> get isConnected async {
    try {
      return await PrintBluetoothThermal.connectionStatus.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
    } catch (e) {
      return false;
    }
  }

  /// Send raw bytes to printer
  Future<bool> printBytes(List<int> bytes) async {
    try {
      final connected = await isConnected;
      if (!connected) return false;
      return await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      debugPrint('Error printing bytes: $e');
      return false;
    }
  }
}
