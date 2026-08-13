import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../catalog/data/providers/catalog_providers.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../inventory/data/providers/inventory_providers.dart';
import '../repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  final syncEngine = ref.watch(syncEngineProvider);
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  return OrderRepository(db, supabase, syncEngine, inventoryRepo);
});
