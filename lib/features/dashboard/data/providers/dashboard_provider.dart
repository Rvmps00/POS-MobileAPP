import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import 'package:POSCO/core/database/app_database.dart';
import 'package:POSCO/features/catalog/data/providers/catalog_providers.dart';

class SoldItemReport {
  final String productId;
  final String productName;
  final String? productNameEn;
  final int quantity;
  final int totalSales;

  const SoldItemReport({
    required this.productId,
    required this.productName,
    this.productNameEn,
    required this.quantity,
    required this.totalSales,
  });

  String localizedName(String lang) {
    if (lang == 'en' && productNameEn != null && productNameEn!.isNotEmpty) {
      return productNameEn!;
    }
    return productName;
  }
}

class DashboardMetrics {
  final double revenue;
  final int orderCount;
  final double averageOrderValue;
  final int itemsSold;
  final Map<int, double> hourlySales;
  final List<SoldItemReport> soldItems;
  final double cashRevenue;
  final double qrisRevenue;
  final double totalExpenses;
  final double netProfit;
  final List<ExpensesTableData> expenses;

  bool get isProfit => netProfit >= 0;

  DashboardMetrics({
    required this.revenue,
    required this.orderCount,
    required this.averageOrderValue,
    required this.itemsSold,
    required this.hourlySales,
    this.soldItems = const [],
    this.cashRevenue = 0.0,
    this.qrisRevenue = 0.0,
    this.totalExpenses = 0.0,
    this.netProfit = 0.0,
    this.expenses = const [],
  });
}

final dashboardMetricsProvider = FutureProvider.family<DashboardMetrics, String?>((ref, shiftId) async {
  final db = ref.watch(appDatabaseProvider);
  
  DateTime startRange;
  DateTime endRange;

  if (shiftId != null) {
    final shift = await (db.select(db.shiftsTable)..where((t) => t.id.equals(shiftId))).getSingleOrNull();
    if (shift != null) {
      startRange = shift.startTime;
      endRange = shift.endTime ?? DateTime.now();
    } else {
      final now = DateTime.now();
      startRange = DateTime(now.year, now.month, now.day);
      endRange = startRange.add(const Duration(days: 1));
    }
  } else {
    final now = DateTime.now();
    startRange = DateTime(now.year, now.month, now.day);
    endRange = startRange.add(const Duration(days: 1));
  }

  // Query orders in range
  final ordersQuery = db.select(db.ordersTable)
    ..where((t) => t.createdAt.isBetweenValues(startRange, endRange))
    ..where((t) => t.status.equals('COMPLETED'));
    
  final orders = await ordersQuery.get();
  
  double totalRevenue = 0;
  double cashRevenue = 0;
  double qrisRevenue = 0;
  Map<int, double> hourlySales = {};
  for (int i = 0; i < 24; i++) {
    hourlySales[i] = 0.0;
  }

  for (final order in orders) {
    totalRevenue += order.grandTotal;
    if (order.paymentMethod.toUpperCase() == 'QRIS') {
      qrisRevenue += order.grandTotal;
    } else {
      cashRevenue += order.grandTotal;
    }
    final hour = order.createdAt.hour;
    hourlySales[hour] = (hourlySales[hour] ?? 0) + order.grandTotal;
  }
  
  int orderCount = orders.length;
  double averageOrderValue = orderCount > 0 ? totalRevenue / orderCount : 0;
  
  int itemsSold = 0;
  final Map<String, SoldItemReport> aggregatedItems = {};

  if (orders.isNotEmpty) {
    final orderIds = orders.map((e) => e.id).toList();
    final itemsQuery = db.select(db.orderItemsTable)
      ..where((t) => t.orderId.isIn(orderIds));
    final items = await itemsQuery.get();

    final products = await db.select(db.productsTable).get();
    final productMap = {for (final p in products) p.id: p};
    
    for (final item in items) {
      itemsSold += item.quantity.toInt();
      final p = productMap[item.productId];
      final key = item.productId.isNotEmpty ? item.productId : item.productName;
      if (aggregatedItems.containsKey(key)) {
        final existing = aggregatedItems[key]!;
        aggregatedItems[key] = SoldItemReport(
          productId: existing.productId,
          productName: existing.productName,
          productNameEn: existing.productNameEn,
          quantity: existing.quantity + item.quantity.toInt(),
          totalSales: existing.totalSales + item.lineTotal,
        );
      } else {
        aggregatedItems[key] = SoldItemReport(
          productId: item.productId,
          productName: item.productName,
          productNameEn: p?.nameEn,
          quantity: item.quantity.toInt(),
          totalSales: item.lineTotal,
        );
      }
    }
  }

  final soldItems = aggregatedItems.values.toList()
    ..sort((a, b) => b.quantity.compareTo(a.quantity));

  // Query expenses in range (or shiftId)
  final expensesQuery = db.select(db.expensesTable);
  if (shiftId != null) {
    expensesQuery.where((t) => t.shiftId.equals(shiftId) | t.expenseDate.isBetweenValues(startRange, endRange));
  } else {
    expensesQuery.where((t) => t.expenseDate.isBetweenValues(startRange, endRange));
  }
  expensesQuery.orderBy([(t) => drift.OrderingTerm.desc(t.expenseDate)]);
  final expenses = await expensesQuery.get();

  double totalExpenses = 0;
  for (final exp in expenses) {
    totalExpenses += exp.amount.toDouble();
  }
  final netProfit = totalRevenue - totalExpenses;

  return DashboardMetrics(
    revenue: totalRevenue,
    orderCount: orderCount,
    averageOrderValue: averageOrderValue,
    itemsSold: itemsSold,
    hourlySales: hourlySales,
    soldItems: soldItems,
    cashRevenue: cashRevenue,
    qrisRevenue: qrisRevenue,
    totalExpenses: totalExpenses,
    netProfit: netProfit,
    expenses: expenses,
  );
});
