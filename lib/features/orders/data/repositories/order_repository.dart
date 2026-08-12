import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../cart/data/models/cart_state_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

import 'package:uuid/uuid.dart';

class OrderRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  OrderRepository(this._db, this._supabase);

  /// Generates order number format: LS-YYYYMMDD-NNN
  Future<String> generateOrderNumber() async {
    final today = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(today);

    // Find highest order number today from local db
    final todayStart = DateTime(today.year, today.month, today.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    final query = _db.select(_db.ordersTable)
      ..where((t) => t.createdAt.isBetweenValues(todayStart, tomorrowStart))
      ..orderBy([(t) => drift.OrderingTerm.desc(t.orderNumber)])
      ..limit(1);

    final lastOrder = await query.getSingleOrNull();

    int nextSequence = 1;
    if (lastOrder != null) {
      final parts = lastOrder.orderNumber.split('-');
      if (parts.length == 3) {
        nextSequence = (int.tryParse(parts[2]) ?? 0) + 1;
      }
    }

    final sequenceStr = nextSequence.toString().padLeft(3, '0');
    return 'LS-$dateStr-$sequenceStr';
  }

  Future<void> saveOrder({
    required CartState cartState,
    required int cashReceived,
    required int cashChange,
  }) async {
    final orderNumber = await generateOrderNumber();
    final orderId = _uuid.v4();
    final cashierId = _supabase.auth.currentUser?.id;

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
        productName: item.product.name, // Or whatever local name is primary
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

    // Try syncing to Supabase immediately (fire and forget / catch error)
    _syncToSupabase(orderId, cartState, cashReceived, cashChange).catchError((
      e,
    ) {
      print('Offline: Order $orderId queued for later sync. Error: $e');
    });
  }

  Future<void> _syncToSupabase(
    String orderId,
    CartState cartState,
    int cashReceived,
    int cashChange,
  ) async {
    // Read the saved order from local DB to get exactly what was saved (including generated dates if any)
    final savedOrder = await (_db.select(
      _db.ordersTable,
    )..where((t) => t.id.equals(orderId))).getSingle();
    final savedItems = await (_db.select(
      _db.orderItemsTable,
    )..where((t) => t.orderId.equals(orderId))).get();

    await _supabase.from('orders').insert({
      'id': savedOrder.id,
      'order_number': savedOrder.orderNumber,
      'order_type': savedOrder.orderType,
      'table_number': savedOrder.tableNumber,
      'subtotal': savedOrder.subtotal,
      'tax_amount': savedOrder.taxAmount,
      'grand_total': savedOrder.grandTotal,
      'payment_method': savedOrder.paymentMethod,
      'payment_status': savedOrder.paymentStatus,
      'cash_received': savedOrder.cashReceived,
      'cash_change': savedOrder.cashChange,
      'status': savedOrder.status,
      'cashier_id': savedOrder.cashierId,
      'notes': savedOrder.notes,
      'created_at': savedOrder.createdAt.toUtc().toIso8601String(),
    });

    final supabaseItems = savedItems
        .map(
          (item) => {
            'id': item.id,
            'order_id': item.orderId,
            'product_id': item.productId,
            'product_name': item.productName,
            'quantity': item.quantity,
            'base_price': item.basePrice,
            'topping_total': item.toppingTotal,
            'line_total': item.lineTotal,
            'removed_ingredients': item.removedIngredients,
            'added_toppings': item.addedToppings,
            'notes': item.notes,
            'created_at': item.createdAt.toUtc().toIso8601String(),
          },
        )
        .toList();

    if (supabaseItems.isNotEmpty) {
      await _supabase.from('order_items').insert(supabaseItems);
    }
  }
}
