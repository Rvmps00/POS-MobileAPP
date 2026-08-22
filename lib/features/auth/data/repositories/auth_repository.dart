import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_engine.dart';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  final AppDatabase _db;
  final SyncEngine _syncEngine;

  AuthRepository(this._supabase, this._db, this._syncEngine);

  /// Fetch staff profiles from Supabase and sync to local DB
  Future<void> syncStaffProfiles() async {
    try {
      final response = await _supabase.from('staff_profiles').select();
      
      await _db.transaction(() async {
        for (final row in response) {
          final profile = StaffProfilesTableCompanion.insert(
            id: row['id'],
            fullName: row['full_name'],
            role: row['role'],
            pin: row['pin'],
            isActive: drift.Value(row['is_active'] ?? true),
            createdAt: drift.Value(
              row['created_at'] != null ? DateTime.parse(row['created_at']) : null,
            ),
            updatedAt: drift.Value(
              row['updated_at'] != null ? DateTime.parse(row['updated_at']) : null,
            ),
          );
          await _db.into(_db.staffProfilesTable).insertOnConflictUpdate(profile);
        }
      });
    } catch (e) {
      // Ignore if offline
    }
  }

  /// Get active staff from local DB
  Future<List<StaffProfilesTableData>> getActiveStaff() async {
    final query = _db.select(_db.staffProfilesTable)
      ..where((t) => t.isActive.equals(true));
    return query.get();
  }

  /// Get all staff from local DB (for Management)
  Future<List<StaffProfilesTableData>> getAllStaff() async {
    return _db.select(_db.staffProfilesTable).get();
  }

  /// Validate PIN against local DB
  Future<StaffProfilesTableData?> validatePin(String pin) async {
    final query = _db.select(_db.staffProfilesTable)
      ..where((t) => t.pin.equals(pin))
      ..where((t) => t.isActive.equals(true))
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Add a new staff profile
  Future<void> addStaff(String fullName, String role, String pin) async {
    final newId = const Uuid().v4();
    
    final profile = StaffProfilesTableCompanion.insert(
      id: newId,
      fullName: fullName,
      role: role,
      pin: pin,
      isActive: const drift.Value(true),
      createdAt: drift.Value(DateTime.now()),
      updatedAt: drift.Value(DateTime.now()),
    );
    
    await _db.into(_db.staffProfilesTable).insert(profile);
    
    await _syncEngine.enqueue(
      tableName: 'staff_profiles',
      recordId: newId,
      operation: 'INSERT',
      payload: {
        'id': newId,
        'full_name': fullName,
        'role': role,
        'pin': pin,
        'is_active': true,
      },
    );
  }

  /// Update a staff profile
  Future<void> updateStaff(String id, String fullName, String role, String pin, bool isActive) async {
    final profile = StaffProfilesTableCompanion(
      fullName: drift.Value(fullName),
      role: drift.Value(role),
      pin: drift.Value(pin),
      isActive: drift.Value(isActive),
      updatedAt: drift.Value(DateTime.now()),
    );

    await (_db.update(_db.staffProfilesTable)..where((t) => t.id.equals(id))).write(profile);

    await _syncEngine.enqueue(
      tableName: 'staff_profiles',
      recordId: id,
      operation: 'UPDATE',
      payload: {
        'id': id,
        'full_name': fullName,
        'role': role,
        'pin': pin,
        'is_active': isActive,
      },
    );
  }
}
