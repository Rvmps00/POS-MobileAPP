import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../catalog/data/providers/catalog_providers.dart';
import '../repositories/inventory_repository.dart';

// ─── Repository Provider ───
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  final syncEngine = ref.watch(syncEngineProvider);
  return InventoryRepository(db, supabase, syncEngine);
});

// ─── Product Stock Streams ───
final inventoryProductsProvider =
    StreamProvider<List<ProductsTableData>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchAllProducts();
});

final lowStockProductsProvider =
    StreamProvider<List<ProductsTableData>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchLowStockProducts();
});

final outOfStockProductsProvider =
    StreamProvider<List<ProductsTableData>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchOutOfStockProducts();
});

// ─── Topping Stock Streams ───
final inventoryToppingsProvider =
    StreamProvider<List<AddonToppingsTableData>>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchAllToppings();
});

// ─── Combined Low-Stock Count (for badge) ───
final lowStockCountProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  // Combine product + topping low-stock counts
  return repo.watchLowStockCount().asyncMap((productCount) async {
    // We'll just use product count for now; topping count can be added later
    return productCount;
  });
});

// ─── Stock History ───
final stockHistoryProvider =
    StreamProvider.family<List<StockHistoryData>, String>((ref, productId) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return repo.watchStockHistory(productId);
});
