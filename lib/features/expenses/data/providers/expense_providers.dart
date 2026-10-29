import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../catalog/data/providers/catalog_providers.dart';
import '../repositories/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final syncEngine = ref.watch(syncEngineProvider);
  return ExpenseRepository(db, syncEngine);
});

enum ExpensePeriod {
  today,
  thisWeek,
  thisMonth,
  custom,
}

class DateRange {
  final DateTime start;
  final DateTime end;
  final String labelId;
  final String labelEn;

  const DateRange({
    required this.start,
    required this.end,
    required this.labelId,
    required this.labelEn,
  });
}

class ExpensePeriodNotifier extends Notifier<ExpensePeriod> {
  @override
  ExpensePeriod build() => ExpensePeriod.today;
  void setPeriod(ExpensePeriod period) => state = period;
}

final expensePeriodProvider =
    NotifierProvider<ExpensePeriodNotifier, ExpensePeriod>(ExpensePeriodNotifier.new);

class CustomDateRangeNotifier extends Notifier<DateTimeRange?> {
  @override
  DateTimeRange? build() => null;
  void setRange(DateTimeRange? range) => state = range;
}

final customDateRangeProvider =
    NotifierProvider<CustomDateRangeNotifier, DateTimeRange?>(CustomDateRangeNotifier.new);

final activeDateRangeProvider = Provider<DateRange>((ref) {
  final period = ref.watch(expensePeriodProvider);
  final customRange = ref.watch(customDateRangeProvider);
  final now = DateTime.now();

  switch (period) {
    case ExpensePeriod.today:
      final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      return DateRange(start: start, end: end, labelId: 'Hari Ini', labelEn: 'Today');

    case ExpensePeriod.thisWeek:
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      return DateRange(start: start, end: end, labelId: 'Minggu Ini', labelEn: 'This Week');

    case ExpensePeriod.thisMonth:
      final start = DateTime(now.year, now.month, 1, 0, 0, 0);
      final nextMonth = now.month == 12 ? DateTime(now.year + 1, 1, 1) : DateTime(now.year, now.month + 1, 1);
      final lastDay = nextMonth.subtract(const Duration(days: 1));
      final end = DateTime(lastDay.year, lastDay.month, lastDay.day, 23, 59, 59, 999);
      return DateRange(start: start, end: end, labelId: 'Bulan Ini', labelEn: 'This Month');

    case ExpensePeriod.custom:
      if (customRange != null) {
        final start = DateTime(customRange.start.year, customRange.start.month, customRange.start.day, 0, 0, 0);
        final end = DateTime(customRange.end.year, customRange.end.month, customRange.end.day, 23, 59, 59, 999);
        return DateRange(start: start, end: end, labelId: 'Rentang Kustom', labelEn: 'Custom Range');
      }
      final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      return DateRange(start: start, end: end, labelId: 'Hari Ini', labelEn: 'Today');
  }
});

final expensesStreamProvider = StreamProvider<List<ExpensesTableData>>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  final range = ref.watch(activeDateRangeProvider);
  return repo.watchExpenses(range.start, range.end);
});

final grossIncomeStreamProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  final range = ref.watch(activeDateRangeProvider);
  return repo.watchGrossIncome(range.start, range.end);
});

class FinancialSummary {
  final int grossIncome;
  final int totalExpenses;
  final int netTotal; // grossIncome - totalExpenses
  final int expenseCount;
  final int cashDrawerExpenses;
  final bool isSurplus;

  const FinancialSummary({
    required this.grossIncome,
    required this.totalExpenses,
    required this.netTotal,
    required this.expenseCount,
    required this.cashDrawerExpenses,
    required this.isSurplus,
  });
}

final financialSummaryProvider = Provider<FinancialSummary>((ref) {
  final grossIncome = ref.watch(grossIncomeStreamProvider).value ?? 0;
  final expenses = ref.watch(expensesStreamProvider).value ?? [];

  int totalExpenses = 0;
  int cashDrawerExpenses = 0;

  for (final e in expenses) {
    totalExpenses += e.amount;
    if (e.paymentSource == 'CASH_DRAWER') {
      cashDrawerExpenses += e.amount;
    }
  }

  final netTotal = grossIncome - totalExpenses;

  return FinancialSummary(
    grossIncome: grossIncome,
    totalExpenses: totalExpenses,
    netTotal: netTotal,
    expenseCount: expenses.length,
    cashDrawerExpenses: cashDrawerExpenses,
    isSurplus: netTotal >= 0,
  );
});

final shiftCashDrawerExpensesProvider = StreamProvider.family<int, String>((ref, shiftId) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchCashDrawerExpensesForShift(shiftId);
});

class ExpenseCategoryItem {
  final String id;
  final String nameId;
  final String nameEn;
  final IconData icon;
  final Color color;

  const ExpenseCategoryItem({
    required this.id,
    required this.nameId,
    required this.nameEn,
    required this.icon,
    required this.color,
  });

  String localizedName(String lang) => lang == 'en' ? nameEn : nameId;
}

const expenseCategories = <ExpenseCategoryItem>[
  ExpenseCategoryItem(
    id: 'INGREDIENTS',
    nameId: 'Bahan Baku',
    nameEn: 'Ingredients',
    icon: Icons.shopping_basket_outlined,
    color: Colors.orange,
  ),
  ExpenseCategoryItem(
    id: 'OPERATIONAL',
    nameId: 'Operasional',
    nameEn: 'Operational',
    icon: Icons.bolt,
    color: Colors.amber,
  ),
  ExpenseCategoryItem(
    id: 'SALARY',
    nameId: 'Gaji & Uang Makan',
    nameEn: 'Salary & Wage',
    icon: Icons.payments_outlined,
    color: Colors.teal,
  ),
  ExpenseCategoryItem(
    id: 'SUPPLIES',
    nameId: 'Perlengkapan',
    nameEn: 'Supplies',
    icon: Icons.cleaning_services_outlined,
    color: Colors.indigo,
  ),
  ExpenseCategoryItem(
    id: 'OTHER',
    nameId: 'Lain-lain',
    nameEn: 'Other',
    icon: Icons.more_horiz,
    color: Colors.blueGrey,
  ),
];

ExpenseCategoryItem getCategoryMeta(String id) {
  return expenseCategories.firstWhere(
    (c) => c.id == id,
    orElse: () => expenseCategories.last,
  );
}

class ExpensePaymentSourceItem {
  final String id;
  final String nameId;
  final String nameEn;
  final IconData icon;

  const ExpensePaymentSourceItem({
    required this.id,
    required this.nameId,
    required this.nameEn,
    required this.icon,
  });

  String localizedName(String lang) => lang == 'en' ? nameEn : nameId;
}

const expensePaymentSources = <ExpensePaymentSourceItem>[
  ExpensePaymentSourceItem(
    id: 'CASH_DRAWER',
    nameId: 'Kas Kasir',
    nameEn: 'Cash Drawer',
    icon: Icons.point_of_sale,
  ),
  ExpensePaymentSourceItem(
    id: 'BANK_TRANSFER',
    nameId: 'Rekening Bank',
    nameEn: 'Bank Transfer',
    icon: Icons.account_balance,
  ),
  ExpensePaymentSourceItem(
    id: 'OWNER_POCKET',
    nameId: 'Pribadi / Owner',
    nameEn: 'Owner Pocket',
    icon: Icons.person_outline,
  ),
];

ExpensePaymentSourceItem getPaymentSourceMeta(String id) {
  return expensePaymentSources.firstWhere(
    (s) => s.id == id,
    orElse: () => expensePaymentSources.first,
  );
}
