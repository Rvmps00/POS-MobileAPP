import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:POSCO/core/database/app_database.dart';
import 'package:POSCO/features/catalog/data/providers/catalog_providers.dart';



class DashboardMetrics {
  final double revenue;
  final int orderCount;
  final double averageOrderValue;
  final int itemsSold;
  final Map<int, double> hourlySales;

  DashboardMetrics({
    required this.revenue,
    required this.orderCount,
    required this.averageOrderValue,
    required this.itemsSold,
    required this.hourlySales,
  });
}

final dashboardMetricsProvider = FutureProvider.family<DashboardMetrics, String?>((ref, _) async {
  final db = ref.watch(appDatabaseProvider);
  
  // For now, let's just get everything for 'today'
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  // Query orders for today
  final ordersQuery = db.select(db.ordersTable)
    ..where((t) => t.createdAt.isBetweenValues(startOfDay, endOfDay))
    ..where((t) => t.status.equals('COMPLETED'));
    
  final orders = await ordersQuery.get();
  
  double totalRevenue = 0;
  Map<int, double> hourlySales = {};
  for (int i = 0; i < 24; i++) {
    hourlySales[i] = 0.0;
  }

  for (final order in orders) {
    totalRevenue += order.grandTotal;
    final hour = order.createdAt.hour;
    hourlySales[hour] = (hourlySales[hour] ?? 0) + order.grandTotal;
  }
  
  int orderCount = orders.length;
  double averageOrderValue = orderCount > 0 ? totalRevenue / orderCount : 0;
  
  // To get items sold, we could query order items for these orders
  // Let's do a simple count for now by joining or querying in a loop (since SQLite is fast)
  int itemsSold = 0;
  if (orders.isNotEmpty) {
    final orderIds = orders.map((e) => e.id).toList();
    final itemsQuery = db.select(db.orderItemsTable)
      ..where((t) => t.orderId.isIn(orderIds));
    final items = await itemsQuery.get();
    
    for (final item in items) {
      itemsSold += item.quantity.toInt();
    }
  }

  return DashboardMetrics(
    revenue: totalRevenue,
    orderCount: orderCount,
    averageOrderValue: averageOrderValue,
    itemsSold: itemsSold,
    hourlySales: hourlySales,
  );
});
