import 'package:drift/drift.dart' as drift;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_engine.dart';

class InventoryRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SyncEngine _syncEngine;
  final _uuid = const Uuid();

  InventoryRepository(this._db, this._supabase, this._syncEngine);

  // ─── Product Stock ───

  /// Watch all products with stock info, optionally filtered.
  Stream<List<ProductsTableData>> watchAllProducts() {
    return (
      _db.select(_db.productsTable)
        ..orderBy([(t) => drift.OrderingTerm.asc(t.name)])
    ).watch();
  }

  /// Watch products with low stock (stock <= threshold).
  Stream<List<ProductsTableData>> watchLowStockProducts() {
    return (_db.select(_db.productsTable)
          ..where(
            (t) =>
                t.stockQty.isSmallerOrEqual(t.lowStockThreshold) &
                t.stockQty.isBiggerThanValue(0),
          )
          ..orderBy([(t) => drift.OrderingTerm.asc(t.stockQty)]))
        .watch();
  }

  /// Watch out-of-stock products.
  Stream<List<ProductsTableData>> watchOutOfStockProducts() {
    return (_db.select(_db.productsTable)
          ..where((t) => t.stockQty.isSmallerOrEqualValue(0)))
        .watch();
  }

  /// Count of low-stock + out-of-stock products (for badge).
  Stream<int> watchLowStockCount() {
    final query = _db.selectOnly(_db.productsTable)
      ..where(
        _db.productsTable.stockQty
            .isSmallerOrEqual(_db.productsTable.lowStockThreshold),
      )
      ..addColumns([_db.productsTable.id.count()]);

    return query
        .map((row) => row.read(_db.productsTable.id.count()) ?? 0)
        .watchSingle();
  }

  /// Update stock for a single product and log history.
  Future<void> updateProductStock({
    required String productId,
    required int newQty,
    required String changeType, // SALE, RESTOCK, ADJUSTMENT, WASTE
    String? notes,
  }) async {
    final product = await (_db.select(_db.productsTable)
          ..where((t) => t.id.equals(productId)))
        .getSingle();

    final previousQty = product.stockQty;
    final changeAmount = newQty - previousQty;

    await _db.transaction(() async {
      // Update stock
      await (_db.update(_db.productsTable)
            ..where((t) => t.id.equals(productId)))
          .write(ProductsTableCompanion(
        stockQty: drift.Value(newQty),
        isAvailable: drift.Value(newQty > 0),
        updatedAt: drift.Value(DateTime.now()),
      ));

      // Log history
      final historyId = _uuid.v4();
      await _db.into(_db.stockHistoryTable).insert(
        StockHistoryTableCompanion.insert(
          id: historyId,
          productId: productId,
          previousQty: previousQty,
          newQty: newQty,
          changeType: changeType,
          changeAmount: changeAmount,
          notes: drift.Value(notes),
          userId: drift.Value(_supabase.auth.currentUser?.id),
        ),
      );

      // Queue sync for product stock update
      await _syncEngine.enqueue(
        tableName: 'products',
        recordId: productId,
        operation: 'UPDATE',
        payload: {
          'id': productId,
          'stock_qty': newQty,
          'is_available': newQty > 0,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      );

      // Queue sync for stock history
      await _syncEngine.enqueue(
        tableName: 'stock_history',
        recordId: historyId,
        operation: 'INSERT',
        payload: {
          'id': historyId,
          'product_id': productId,
          'item_type': 'PRODUCT',
          'previous_qty': previousQty,
          'new_qty': newQty,
          'change_type': changeType,
          'change_amount': changeAmount,
          'notes': notes,
          'user_id': _supabase.auth.currentUser?.id,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    });
  }

  /// Batch restock multiple products at once.
  Future<void> batchRestock(Map<String, int> restockQuantities) async {
    for (final entry in restockQuantities.entries) {
      final product = await (_db.select(_db.productsTable)
            ..where((t) => t.id.equals(entry.key)))
          .getSingle();

      final newQty = product.stockQty + entry.value;
      await updateProductStock(
        productId: entry.key,
        newQty: newQty,
        changeType: 'RESTOCK',
        notes: 'Batch restock: +${entry.value}',
      );
    }
  }

  /// Set low-stock threshold for a product.
  Future<void> setProductThreshold(String productId, int threshold) async {
    await (_db.update(_db.productsTable)
          ..where((t) => t.id.equals(productId)))
        .write(ProductsTableCompanion(
      lowStockThreshold: drift.Value(threshold),
      updatedAt: drift.Value(DateTime.now()),
    ));

    await _syncEngine.enqueue(
      tableName: 'products',
      recordId: productId,
      operation: 'UPDATE',
      payload: {
        'id': productId,
        'low_stock_threshold': threshold,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  // ─── Topping Stock ───

  /// Watch all toppings with stock info.
  Stream<List<AddonToppingsTableData>> watchAllToppings() {
    return (_db.select(_db.addonToppingsTable)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Count of low-stock toppings (for combined badge).
  Stream<int> watchLowStockToppingCount() {
    final query = _db.selectOnly(_db.addonToppingsTable)
      ..where(
        _db.addonToppingsTable.stockQty
            .isSmallerOrEqual(_db.addonToppingsTable.lowStockThreshold),
      )
      ..addColumns([_db.addonToppingsTable.id.count()]);

    return query
        .map((row) => row.read(_db.addonToppingsTable.id.count()) ?? 0)
        .watchSingle();
  }

  /// Update stock for a single topping and log history.
  Future<void> updateToppingStock({
    required String toppingId,
    required int newQty,
    required String changeType,
    String? notes,
  }) async {
    final topping = await (_db.select(_db.addonToppingsTable)
          ..where((t) => t.id.equals(toppingId)))
        .getSingle();

    final previousQty = topping.stockQty;
    final changeAmount = newQty - previousQty;

    await _db.transaction(() async {
      await (_db.update(_db.addonToppingsTable)
            ..where((t) => t.id.equals(toppingId)))
          .write(AddonToppingsTableCompanion(
        stockQty: drift.Value(newQty),
        isAvailable: drift.Value(newQty > 0),
      ));

      final historyId = _uuid.v4();
      await _db.into(_db.stockHistoryTable).insert(
        StockHistoryTableCompanion.insert(
          id: historyId,
          productId: toppingId,
          itemType: const drift.Value('TOPPING'),
          previousQty: previousQty,
          newQty: newQty,
          changeType: changeType,
          changeAmount: changeAmount,
          notes: drift.Value(notes),
          userId: drift.Value(_supabase.auth.currentUser?.id),
        ),
      );

      await _syncEngine.enqueue(
        tableName: 'addon_toppings',
        recordId: toppingId,
        operation: 'UPDATE',
        payload: {
          'id': toppingId,
          'stock_qty': newQty,
          'is_available': newQty > 0,
        },
      );

      await _syncEngine.enqueue(
        tableName: 'stock_history',
        recordId: historyId,
        operation: 'INSERT',
        payload: {
          'id': historyId,
          'product_id': toppingId,
          'item_type': 'TOPPING',
          'previous_qty': previousQty,
          'new_qty': newQty,
          'change_type': changeType,
          'change_amount': changeAmount,
          'notes': notes,
          'user_id': _supabase.auth.currentUser?.id,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    });
  }

  /// Update stock for multiple toppings by their name and log history.
  Future<void> updateToppingStockByName({
    required String toppingName,
    required int newQty,
    required String changeType,
    String? notes,
  }) async {
    final normalizedName = toppingName.trim().toLowerCase();
    final allToppings = await _db.select(_db.addonToppingsTable).get();
    final toppings = allToppings
        .where((t) => t.name.trim().toLowerCase() == normalizedName)
        .toList();

    if (toppings.isEmpty) return;

    // Use the first one's previousQty for history changeAmount (assuming they are in sync)
    final previousQty = toppings.first.stockQty;
    final changeAmount = newQty - previousQty;

    await _db.transaction(() async {
      for (final topping in toppings) {
        await (_db.update(_db.addonToppingsTable)
              ..where((t) => t.id.equals(topping.id)))
            .write(AddonToppingsTableCompanion(
          stockQty: drift.Value(newQty),
          isAvailable: drift.Value(newQty > 0),
        ));

        final historyId = _uuid.v4();
        await _db.into(_db.stockHistoryTable).insert(
          StockHistoryTableCompanion.insert(
            id: historyId,
            productId: topping.id,
            itemType: const drift.Value('TOPPING'),
            previousQty: previousQty,
            newQty: newQty,
            changeType: changeType,
            changeAmount: changeAmount,
            notes: drift.Value(notes),
            userId: drift.Value(_supabase.auth.currentUser?.id),
          ),
        );

        await _syncEngine.enqueue(
          tableName: 'addon_toppings',
          recordId: topping.id,
          operation: 'UPDATE',
          payload: {
            'id': topping.id,
            'stock_qty': newQty,
            'is_available': newQty > 0,
          },
        );

        await _syncEngine.enqueue(
          tableName: 'stock_history',
          recordId: historyId,
          operation: 'INSERT',
          payload: {
            'id': historyId,
            'product_id': topping.id,
            'item_type': 'TOPPING',
            'previous_qty': previousQty,
            'new_qty': newQty,
            'change_type': changeType,
            'change_amount': changeAmount,
            'notes': notes,
            'user_id': _supabase.auth.currentUser?.id,
            'created_at': DateTime.now().toUtc().toIso8601String(),
          },
        );
      }
    });
  }

  /// Delete all toppings with the given name from the database.
  Future<void> deleteToppingByName(String toppingName) async {
    final normalizedName = toppingName.trim().toLowerCase();
    final allToppings = await _db.select(_db.addonToppingsTable).get();
    final toppings = allToppings
        .where((t) => t.name.trim().toLowerCase() == normalizedName)
        .toList();

    if (toppings.isEmpty) return;

    await _db.transaction(() async {
      for (final topping in toppings) {
        await (_db.delete(_db.addonToppingsTable)
              ..where((t) => t.id.equals(topping.id)))
            .go();

        await _syncEngine.enqueue(
          tableName: 'addon_toppings',
          recordId: topping.id,
          operation: 'DELETE',
          payload: {
            'id': topping.id,
          },
        );
      }
    });
  }

  // ─── Stock History ───

  /// Watch stock history for a specific item.
  Stream<List<StockHistoryData>> watchStockHistory(String productId) {
    return (_db.select(_db.stockHistoryTable)
          ..where((t) => t.productId.equals(productId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])
          ..limit(50))
        .watch();
  }

  /// Get all stock history (recent first).
  Future<List<StockHistoryData>> getAllStockHistory({int limit = 100}) {
    return (_db.select(_db.stockHistoryTable)
          ..orderBy([(t) => drift.OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  // ─── Stock Deduction on Order ───

  /// Deduct stock for all items in an order (called after checkout).
  Future<void> deductStockForOrder(
    List<OrderItemDeduction> deductions,
  ) async {
    for (final deduction in deductions) {
      // Deduct product stock
      await updateProductStock(
        productId: deduction.productId,
        newQty: deduction.currentProductStock - deduction.quantity,
        changeType: 'SALE',
        notes: 'Order: ${deduction.orderNumber}',
      );

      // Deduct topping stock
      for (final topping in deduction.toppings) {
        await updateToppingStock(
          toppingId: topping.toppingId,
          newQty: topping.currentStock - deduction.quantity,
          changeType: 'SALE',
          notes: 'Order: ${deduction.orderNumber}',
        );
      }
    }
  }
}

/// Helper class for stock deduction on order.
class OrderItemDeduction {
  final String productId;
  final int quantity;
  final int currentProductStock;
  final String orderNumber;
  final List<ToppingDeduction> toppings;

  const OrderItemDeduction({
    required this.productId,
    required this.quantity,
    required this.currentProductStock,
    required this.orderNumber,
    this.toppings = const [],
  });
}

class ToppingDeduction {
  final String toppingId;
  final int currentStock;

  const ToppingDeduction({
    required this.toppingId,
    required this.currentStock,
  });
}
