import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';

class SecurityManager {
  static void initialize() {
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.POSCO.app',
        signingCertHashes: ['BE:72:52:00:46:4B:25:B1:C7:8F:DD:E8:B0:84:73:40:C2:2D:8F:43:3E:68:13:50:54:D8:90:B4:FB:DE:DD:A8'], // Replace with actual SHA-256 hash in production
        supportedStores: ['com.sec.android.app.samsungapps'],
      ),
      iosConfig: IOSConfig(
        bundleIds: ['com.POSCO.app'],
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
