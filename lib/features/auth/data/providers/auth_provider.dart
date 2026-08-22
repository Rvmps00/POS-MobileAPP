import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../catalog/data/providers/catalog_providers.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = Supabase.instance.client;
  final db = ref.watch(appDatabaseProvider);
  final syncEngine = ref.watch(syncEngineProvider);
  
  return AuthRepository(supabase, db, syncEngine);
});

final activeStaffProvider = NotifierProvider<ActiveStaffNotifier, StaffProfilesTableData?>(() {
  return ActiveStaffNotifier();
});

class ActiveStaffNotifier extends Notifier<StaffProfilesTableData?> {
  @override
  StaffProfilesTableData? build() => null;

  void setActiveStaff(StaffProfilesTableData staff) {
    state = staff;
  }

  void clearActiveStaff() {
    state = null;
  }
}

final staffProfilesProvider = FutureProvider<List<StaffProfilesTableData>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  await repo.syncStaffProfiles();
  return repo.getActiveStaff();
});

final allStaffProfilesProvider = FutureProvider<List<StaffProfilesTableData>>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  await repo.syncStaffProfiles();
  return repo.getAllStaff();
});
