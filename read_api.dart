import 'dart:io';

void main() {
  final callbackFile = File(r'C:\Users\TugasAkhir\AppData\Local\Pub\Cache\hosted\pub.dev\freerasp-8.2.2\lib\src\callbacks\threat_callback.dart');
  if (callbackFile.existsSync()) {
    print('--- threat_callback.dart ---');
    print(callbackFile.readAsStringSync());
  }

  final talsecFile = File(r'C:\Users\TugasAkhir\AppData\Local\Pub\Cache\hosted\pub.dev\freerasp-8.2.2\lib\src\talsec.dart');
  if (talsecFile.existsSync()) {
    print('--- talsec.dart ---');
    print(talsecFile.readAsStringSync());
  }
}
