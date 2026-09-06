import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:freerasp/freerasp.dart';

class SecurityManager {
  static void initialize() {
    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName: 'com.POSCO.app',
        signingCertHashes: [
          'vnJSAEZLJbHHj93osIRzQMItj0M+aBNQVNiQtPve3ag=', // Upload Key
          'bZ6ej5sBxGVQeHyANpZc2vQUgwvX2Q9qXiTv5ePyLR4=', // Classical Play App Signing Key
          'vjFfiPBe/UYTynW/xrhQfucgiwIsnw42k0p6A2vCJIA=', // Post-Quantum Play App Signing Key
        ],
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
