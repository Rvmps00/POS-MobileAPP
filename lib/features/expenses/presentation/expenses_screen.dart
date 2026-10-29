import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/language_notifier.dart';
import '../data/providers/expense_providers.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  Future<void> _selectCustomRange(BuildContext context, WidgetRef ref) async {
    final currentCustom = ref.read(customDateRangeProvider);
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: currentCustom ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          ),
    );

    if (picked != null) {
      ref.read(customDateRangeProvider.notifier).setRange(picked);
      ref.read(expensePeriodProvider.notifier).setPeriod(ExpensePeriod.custom);
    }
  }

  void _showReceiptDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Bukti Struk / Receipt'),
              leading: const CloseButton(),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Gambar tidak dapat dimuat / Image unavailable'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider).languageCode;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM, HH:mm');

    final period = ref.watch(expensePeriodProvider);
    final activeRange = ref.watch(activeDateRangeProvider);
    final summary = ref.watch(financialSummaryProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      appBar: AppBar(
        title: Text(
          lang == 'en' ? 'Expenses & Cashflow' : 'Pengeluaran & Kas',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(expensesStreamProvider);
          ref.invalidate(grossIncomeStreamProvider);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Period Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _PeriodChip(
                    label: lang == 'en' ? 'Today' : 'Hari Ini',
                    isSelected: period == ExpensePeriod.today,
                    onTap: () => ref.read(expensePeriodProvider.notifier).setPeriod(ExpensePeriod.today),
                  ),
                  const SizedBox(width: 8),
                  _PeriodChip(
                    label: lang == 'en' ? 'This Week' : 'Minggu Ini',
                    isSelected: period == ExpensePeriod.thisWeek,
                    onTap: () => ref.read(expensePeriodProvider.notifier).setPeriod(ExpensePeriod.thisWeek),
                  ),
                  const SizedBox(width: 8),
                  _PeriodChip(
                    label: lang == 'en' ? 'This Month' : 'Bulan Ini',
                    isSelected: period == ExpensePeriod.thisMonth,
                    onTap: () => ref.read(expensePeriodProvider.notifier).setPeriod(ExpensePeriod.thisMonth),
                  ),
                  const SizedBox(width: 8),
                  _PeriodChip(
                    label: period == ExpensePeriod.custom
                        ? '${DateFormat('dd/MM').format(activeRange.start)} - ${DateFormat('dd/MM').format(activeRange.end)}'
                        : (lang == 'en' ? 'Custom' : 'Kustom'),
                    icon: Icons.calendar_month_outlined,
                    isSelected: period == ExpensePeriod.custom,
                    onTap: () => _selectCustomRange(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Top Financial Cards (Gross Income, Expenses, Total)
            Row(
              children: [
                // Gross Income (White card with subtle shadow)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.trending_up, size: 18, color: Color(0xFF2563EB)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lang == 'en' ? 'Gross Income' : 'Pendapatan Kotor',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            currencyFormatter.format(summary.grossIncome),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Expenses (White card with subtle shadow)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDC2626).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.trending_down, size: 18, color: Color(0xFFDC2626)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                lang == 'en' ? 'Expenses' : 'Pengeluaran',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFDC2626),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            currencyFormatter.format(summary.totalExpenses),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Total / Net Balance Card (White card with subtle shadow)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            summary.isSurplus ? Icons.account_balance_wallet : Icons.warning_amber_rounded,
                            size: 18,
                            color: summary.isSurplus ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            lang == 'en' ? 'Total (Net Balance)' : 'Total (Laba Bersih)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: summary.isSurplus ? const Color(0xFF1D4ED8) : const Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary.isSurplus
                            ? (lang == 'en' ? 'Surplus / Profit' : 'Surplus / Untung')
                            : (lang == 'en' ? 'Deficit / Minus' : 'Defisit / Minus'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: summary.isSurplus ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (summary.netTotal < 0 ? '- ' : '+ ') +
                          currencyFormatter.format(summary.netTotal.abs()),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: summary.isSurplus ? const Color(0xFF1D4ED8) : const Color(0xFFB91C1C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (summary.cashDrawerExpenses > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${lang == 'en' ? 'Cash Drawer (Kas Kasir) used:' : 'Kas Kasir terpakai:'} ${currencyFormatter.format(summary.cashDrawerExpenses)}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Expense List Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang == 'en' ? 'Expense History' : 'Daftar Pengeluaran',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${summary.expenseCount} ${lang == 'en' ? 'entries' : 'transaksi'}',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Expense Items List
            expensesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, st) => Center(child: Text('Error: $err')),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lang == 'en' ? 'No expenses recorded for this period' : 'Belum ada pengeluaran pada periode ini',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang == 'en'
                                ? 'Tap the button below to record an expense'
                                : 'Ketuk tombol di bawah untuk mencatat pengeluaran',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    final catMeta = getCategoryMeta(item.category);
                    final sourceMeta = getPaymentSourceMeta(item.paymentSource);

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => context.push('/expenses/${item.id}/edit'),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // Category Avatar
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: catMeta.color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(catMeta.icon, color: catMeta.color, size: 22),
                              ),
                              const SizedBox(width: 12),

                              // Title & Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            catMeta.localizedName(lang),
                                            style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '• ${sourceMeta.localizedName(lang)}',
                                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateFormatter.format(item.expenseDate),
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                    ),
                                  ],
                                ),
                              ),

                              // Amount & Receipt Icon
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '- ${currencyFormatter.format(item.amount)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  if (item.receiptImagePath != null) ...[
                                    const SizedBox(height: 6),
                                    InkWell(
                                      onTap: () => _showReceiptDialog(context, item.receiptImagePath!),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.image_outlined, size: 12, color: Colors.blue),
                                            SizedBox(width: 4),
                                            Text('Nota', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 80), // Padding for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/add'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          lang == 'en' ? 'Record Expense' : 'Catat Pengeluaran',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withOpacity(0.5),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
