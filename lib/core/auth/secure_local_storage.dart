import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureLocalStorage extends LocalStorage {
  final FlutterSecureStorage _storage;
  
  SecureLocalStorage() 
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
        );

  static const _supabaseSessionKey = 'supabase_session';

  @override
  Future<void> initialize() async {
    // No initialization needed for flutter_secure_storage
  }

  @override
  Future<bool> hasAccessToken() async {
    return await _storage.containsKey(key: _supabaseSessionKey);
  }

  @override
  Future<String?> accessToken() async {
    return await _storage.read(key: _supabaseSessionKey);
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: _supabaseSessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(key: _supabaseSessionKey, value: persistSessionString);
  }
}
