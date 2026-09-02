import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';

class SecurityManager {
  static void initialize() {
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.surya.pos_mobile_app',
        signingCertHashes: ['AKoRuyLMM91E7lX/Zqp3u4jMmd0A7hH/Iqozu0TMVd0='], // Replace with actual SHA-256 hash in production
        supportedStores: ['com.sec.android.app.samsungapps'],
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.surya.pos_mobile_app'],
        teamId: 'YOUR_TEAM_ID',
      ),
      watcherMail: 'admin@example.com',
      isProd: kReleaseMode,
    );

    final callback = ThreatCallback(
      onPrivilegedAccess: () => _handleSecurityThreat('Root access detected'),
      onSimulator: () => _handleSecurityThreat('Emulator detected'),
      onHooks: () => _handleSecurityThreat('Hooking framework detected'),
      onAppIntegrity: () => debugPrint('SECURITY THREAT: App tampering detected (Ignored for internal restaurant use)'),
      onDeviceBinding: () => _handleSecurityThreat('Device binding failed'),
      onUnofficialStore: () => debugPrint('SECURITY THREAT: Untrusted installation source (Ignored for internal restaurant use)'),
    );

    Talsec.instance.attachListener(callback);
    Talsec.instance.start(config);
  }

  static void _handleSecurityThreat(String message) {
    debugPrint('SECURITY THREAT DETECTED: $message');
    if (kReleaseMode) {
      // In a real production app, you might want to silently exit or clear session
      exit(0);
    }
  }
}
