import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_engine.dart';
import '../../../cart/data/models/cart_state_model.dart';
import '../../../inventory/data/repositories/inventory_repository.dart';

import 'package:uuid/uuid.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final SyncEngine _syncEngine;
  final InventoryRepository _inventoryRepo;
  final SharedPreferences _prefs;
  final _uuid = const Uuid();

  OrderRepository(this._db, this._supabase, this._syncEngine, this._inventoryRepo, this._prefs);

  /// Generates order number format: LS-YYYYMMDD-NNN
  Future<String> generateOrderNumber() async {
    final today = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(today);

    // Get current queue date and sequence from SharedPreferences
    final lastQueueDate = _prefs.getString('queue_date');
    int nextSequence = 1;
    
    if (lastQueueDate == dateStr) {
      // Same day, increment sequence
      nextSequence = (_prefs.getInt('queue_sequence') ?? 0) + 1;
    } else {
      // New day (or reset), reset sequence to 1 and save new date
      await _prefs.setString('queue_date', dateStr);
    }
    
    // Save new sequence
    await _prefs.setInt('queue_sequence', nextSequence);

    final sequenceStr = nextSequence.toString().padLeft(3, '0');
    return 'LS-$dateStr-$sequenceStr';
  }

  Future<String> saveOrder({
    required CartState cartState,
    required int cashReceived,
    required int cashChange,
  }) async {
    final orderNumber = await generateOrderNumber();
    final orderId = _uuid.v4();
    final cashierId = _supabase.auth.currentUser?.id;
    final now = DateTime.now();

    final orderData = OrdersTableCompanion.insert(
      id: orderId,
      orderNumber: orderNumber,
      orderType: cartState.orderType.name == 'dineIn' ? 'DINE_IN' : 'TAKEAWAY',
      tableNumber: drift.Value(cartState.tableNumber),
      subtotal: cartState.subtotal,
      taxAmount: cartState.taxAmount,
      grandTotal: cartState.grandTotal,
      paymentMethod: const drift.Value('CASH'),
      paymentStatus: const drift.Value('PAID'),
      cashReceived: drift.Value(cashReceived),
      cashChange: drift.Value(cashChange),
      cashierId: drift.Value(cashierId),
    );

    final itemCompanions = cartState.items.map((item) {
      return OrderItemsTableCompanion.insert(
        id: _uuid.v4(),
        orderId: orderId,
        productId: item.product.id,
        productName: item.product.name,
        quantity: item.quantity,
        basePrice: item.product.basePrice,
        toppingTotal: drift.Value(item.unitPrice - item.product.basePrice),
        lineTotal: item.lineTotal,
        removedIngredients: drift.Value(
          item.removedIngredients.map((e) => e.name).toList(),
        ),
        addedToppings: drift.Value(
          item.addedToppings
              .map((e) => {'name': e.name, 'price': e.price})
              .toList(),
        ),
        selectedVariation: drift.Value(item.selectedVariation),
        notes: drift.Value(item.notes),
      );
    }).toList();

    // Save to local Drift DB in a transaction
    await _db.transaction(() async {
      await _db.into(_db.ordersTable).insert(orderData);
      for (final item in itemCompanions) {
        await _db.into(_db.orderItemsTable).insert(item);
      }
    });

    // Deduct stock for each item in the order
    final deductions = <OrderItemDeduction>[];
    for (final item in cartState.items) {
      // Get current product stock
      final product = await (_db.select(_db.productsTable)
            ..where((t) => t.id.equals(item.product.id)))
          .getSingleOrNull();

      if (product != null) {
        // Build topping deductions
        final toppingDeductions = <ToppingDeduction>[];
        for (final topping in item.addedToppings) {
          final toppingData = await (_db.select(_db.addonToppingsTable)
                ..where((t) => t.id.equals(topping.id)))
              .getSingleOrNull();

          if (toppingData != null) {
            toppingDeductions.add(ToppingDeduction(
              toppingId: topping.id,
              currentStock: toppingData.stockQty,
            ));
          }
        }

        deductions.add(OrderItemDeduction(
          productId: item.product.id,
          quantity: item.quantity,
          currentProductStock: product.stockQty,
          orderNumber: orderNumber,
          toppings: toppingDeductions,
        ));
      }
    }

    // Deduct stock (logs history + queues sync automatically)
    await _inventoryRepo.deductStockForOrder(deductions);

    // Queue order sync to Supabase
    await _syncEngine.enqueue(
      tableName: 'orders',
      recordId: orderId,
      operation: 'INSERT',
      payload: {
        'id': orderId,
        'order_number': orderNumber,
        'order_type':
            cartState.orderType.name == 'dineIn' ? 'DINE_IN' : 'TAKEAWAY',
        'table_number': cartState.tableNumber,
        'subtotal': cartState.subtotal,
        'tax_amount': cartState.taxAmount,
        'grand_total': cartState.grandTotal,
        'payment_method': 'CASH',
        'payment_status': 'PAID',
        'cash_received': cashReceived,
        'cash_change': cashChange,
        'status': 'COMPLETED',
        'cashier_id': cashierId,
        'created_at': now.toUtc().toIso8601String(),
      },
    );

    // Queue order items sync
    for (final item in cartState.items) {
      final itemId = _uuid.v4();
      await _syncEngine.enqueue(
        tableName: 'order_items',
        recordId: itemId,
        operation: 'INSERT',
        payload: {
          'id': itemId,
          'order_id': orderId,
          'product_id': item.product.id,
          'product_name': item.product.name,
          'quantity': item.quantity,
          'base_price': item.product.basePrice,
          'topping_total': item.unitPrice - item.product.basePrice,
          'line_total': item.lineTotal,
          'removed_ingredients':
              item.removedIngredients.map((e) => e.name).toList(),
          'added_toppings': item.addedToppings
              .map((e) => {'name': e.name, 'price': e.price})
              .toList(),
          'selected_variation': item.selectedVariation,
          'notes': item.notes,
          'created_at': now.toUtc().toIso8601String(),
        },
      );
    }

    return orderNumber;
  }
}
