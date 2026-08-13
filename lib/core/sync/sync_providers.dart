import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/catalog/data/providers/catalog_providers.dart';
import 'connectivity_service.dart';
import 'sync_engine.dart';

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  final connectivity = ref.watch(connectivityServiceProvider);
  final engine = SyncEngine(db, supabase, connectivity);
  ref.onDispose(() => engine.dispose());
  return engine;
});

final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final engine = ref.watch(syncEngineProvider);
  return engine.watchPendingCount();
});
