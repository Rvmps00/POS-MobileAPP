import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../catalog/data/providers/catalog_providers.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../inventory/data/providers/inventory_providers.dart';
import '../repositories/order_repository.dart';

import '../../../../core/printer/printer_providers.dart';
import 'package:POSCO/core/database/app_database.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  final syncEngine = ref.watch(syncEngineProvider);
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return OrderRepository(db, supabase, syncEngine, inventoryRepo, prefs);
});

// --- PHASE 6 PROVIDERS ---

// Provider to fetch list of orders with optional search query
final orderHistoryProvider = FutureProvider.family.autoDispose<List<OrdersTableData>, String?>((ref, searchQuery) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrders(searchQuery: searchQuery);
});

// Provider to fetch items for a specific order
final orderItemsProvider = FutureProvider.family<List<OrderItemsTableData>, String>((ref, orderId) async {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.getOrderItems(orderId);
});

// Simple provider class to handle actions like cancel order
final orderActionsProvider = Provider<OrderActions>((ref) {
  return OrderActions(ref);
});

class OrderActions {
  final Ref ref;
  OrderActions(this.ref);

  Future<void> cancelOrder(String orderId) async {
    final repo = ref.read(orderRepositoryProvider);
    await repo.cancelOrder(orderId);
    // Invalidate the history provider so it refreshes the list
    ref.invalidate(orderHistoryProvider);
  }
}
