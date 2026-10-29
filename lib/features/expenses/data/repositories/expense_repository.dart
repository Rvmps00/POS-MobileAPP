import 'dart:async';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_engine.dart';

class ExpenseRepository {
  final AppDatabase _db;
  final SyncEngine _syncEngine;
  final _uuid = const Uuid();

  ExpenseRepository(this._db, this._syncEngine);

  /// Watch expenses within a given date range
  Stream<List<ExpensesTableData>> watchExpenses(DateTime start, DateTime end) {
    return (_db.select(_db.expensesTable)
          ..where((t) => t.expenseDate.isBetweenValues(start, end))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.expenseDate)]))
        .watch();
  }

  /// Watch completed orders gross income within a given date range
  Stream<int> watchGrossIncome(DateTime start, DateTime end) {
    return (_db.select(_db.ordersTable)
          ..where((t) => t.createdAt.isBetweenValues(start, end) & t.status.equals('COMPLETED')))
        .watch()
        .map((orders) => orders.fold<int>(0, (sum, order) => sum + order.grandTotal));
  }

  /// Watch cash drawer expenses during an active shift
  Stream<int> watchCashDrawerExpensesForShift(String shiftId) {
    return (_db.select(_db.expensesTable)
          ..where((t) => t.shiftId.equals(shiftId) & t.paymentSource.equals('CASH_DRAWER')))
        .watch()
        .map((expenses) => expenses.fold<int>(0, (sum, e) => sum + e.amount));
  }

  /// Get single expense by ID
  Future<ExpensesTableData?> getExpenseById(String id) {
    return (_db.select(_db.expensesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Create a new expense
  Future<String> createExpense({
    required String title,
    required int amount,
    required String category,
    required String paymentSource,
    String? notes,
    String? receiptImagePath,
    DateTime? expenseDate,
    String? shiftId,
    String? createdByStaffId,
    String? createdByName,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final date = expenseDate ?? now;

    final companion = ExpensesTableCompanion.insert(
      id: id,
      title: title,
      amount: amount,
      category: category,
      paymentSource: drift.Value(paymentSource),
      notes: drift.Value(notes),
      receiptImagePath: drift.Value(receiptImagePath),
      expenseDate: date,
      shiftId: drift.Value(shiftId),
      createdByStaffId: drift.Value(createdByStaffId),
      createdByName: drift.Value(createdByName),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    );

    await _db.into(_db.expensesTable).insert(companion);

    // Enqueue for cloud sync
    await _syncEngine.enqueue(
      tableName: 'expenses',
      recordId: id,
      operation: 'INSERT',
      payload: {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category,
        'payment_source': paymentSource,
        'notes': notes,
        'receipt_image_path': receiptImagePath,
        'expense_date': date.toIso8601String(),
        'shift_id': shiftId,
        'created_by_staff_id': createdByStaffId,
        'created_by_name': createdByName,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
    );
    _syncEngine.triggerSync();

    return id;
  }

  /// Update an existing expense
  Future<void> updateExpense({
    required String id,
    required String title,
    required int amount,
    required String category,
    required String paymentSource,
    String? notes,
    String? receiptImagePath,
    DateTime? expenseDate,
  }) async {
    final now = DateTime.now();
    final companion = ExpensesTableCompanion(
      title: drift.Value(title),
      amount: drift.Value(amount),
      category: drift.Value(category),
      paymentSource: drift.Value(paymentSource),
      notes: drift.Value(notes),
      receiptImagePath: drift.Value(receiptImagePath),
      expenseDate: expenseDate != null ? drift.Value(expenseDate) : const drift.Value.absent(),
      updatedAt: drift.Value(now),
    );

    await (_db.update(_db.expensesTable)..where((t) => t.id.equals(id))).write(companion);

    // Enqueue update for sync
    final payload = <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'payment_source': paymentSource,
      'notes': notes,
      'receipt_image_path': receiptImagePath,
      'updated_at': now.toIso8601String(),
    };
    if (expenseDate != null) {
      payload['expense_date'] = expenseDate.toIso8601String();
    }

    await _syncEngine.enqueue(
      tableName: 'expenses',
      recordId: id,
      operation: 'UPDATE',
      payload: payload,
    );
    _syncEngine.triggerSync();
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    await (_db.delete(_db.expensesTable)..where((t) => t.id.equals(id))).go();

    await _syncEngine.enqueue(
      tableName: 'expenses',
      recordId: id,
      operation: 'DELETE',
      payload: {'id': id},
    );
    _syncEngine.triggerSync();
  }
}
