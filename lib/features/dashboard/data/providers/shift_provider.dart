import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:POSCO/core/database/app_database.dart';
import 'package:POSCO/features/catalog/data/providers/catalog_providers.dart';

import '../services/report_service.dart';
import 'dashboard_provider.dart';
import 'package:POSCO/features/orders/data/providers/order_provider.dart';

import 'package:intl/intl.dart';
import 'package:POSCO/core/printer/printer_providers.dart';
import 'package:POSCO/core/l10n/language_notifier.dart';

part 'shift_provider.g.dart';

final reportServiceProvider = Provider<ReportService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final supabase = Supabase.instance.client;
  return ReportService(db, supabase);
});

class ShiftModel {
  final String id;
  final DateTime startTime;
  final double startingCash;
  final DateTime? endTime;
  final double? actualEndingCash;
  
  ShiftModel({
    required this.id,
    required this.startTime,
    required this.startingCash,
    this.endTime,
    this.actualEndingCash,
  });
}

@riverpod
class ShiftNotifier extends _$ShiftNotifier {
  AppDatabase get _db => ref.read(appDatabaseProvider);
  
  @override
  Future<ShiftModel?> build() async {

    // Try to find an OPEN shift
    final entry = await (_db.select(_db.shiftsTable)
      ..where((t) => t.status.equals('OPEN'))
      ..limit(1))
      .getSingleOrNull();
      
    if (entry == null) return null;
    return ShiftModel(
      id: entry.id,
      startTime: entry.startTime,
      startingCash: entry.startingCash,
      endTime: entry.endTime,
      actualEndingCash: entry.actualEndingCash,
    );
  }

  Future<void> startShift(double startingCash) async {
    final newShift = ShiftsTableCompanion.insert(
      id: const Uuid().v4(),
      startTime: DateTime.now(),
      startingCash: startingCash,
      status: const drift.Value('OPEN'),
    );
    await _db.into(_db.shiftsTable).insert(newShift);
    ref.invalidateSelf();
  }

  Future<void> endShift(double actualEndingCash) async {
    final currentShift = state.value;
    if (currentShift != null) {
      final now = DateTime.now();
      
      // We will calculate expected ending cash here later by summing up cash orders.
      final expectedCash = currentShift.startingCash;
      
      await (_db.update(_db.shiftsTable)..where((t) => t.id.equals(currentShift.id)))
        .write(ShiftsTableCompanion(
          endTime: drift.Value(now),
          actualEndingCash: drift.Value(actualEndingCash),
          expectedEndingCash: drift.Value(expectedCash),
          status: const drift.Value('CLOSED'),
        ));
        
      // --- REPORTING & EFFICIENCY LOGIC ---
      try {
        final metrics = await ref.read(dashboardMetricsProvider(currentShift.id).future);
        final reportService = ref.read(reportServiceProvider);
        final prefs = ref.read(sharedPreferencesProvider);
        final storeName = prefs.getString('store_name') ?? 'POINT OF SALE';
        final lang = ref.read(languageProvider).languageCode;
        final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

        final shiftForReport = ShiftModel(
          id: currentShift.id,
          startTime: currentShift.startTime,
          startingCash: currentShift.startingCash,
          endTime: now,
          actualEndingCash: actualEndingCash,
        );
        
        // 1. Generate PDF Report and save to File
        final pdfBytes = await reportService.generateEndOfDayPdf(
          shiftForReport,
          metrics,
          lang: lang,
          storeName: storeName,
        );
        final pdfFile = await reportService.savePdfToFile(pdfBytes);
        
        // 2. Generate CSV for old orders (older than 30 days)
        final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
        final csvFile = await reportService.generateOrdersCsv(cutoffDate);
        
        // 3. Format items sold list for email body
        final itemsSummary = StringBuffer();
        if (metrics.soldItems.isEmpty) {
          itemsSummary.writeln('  (Tidak ada item terjual / No items sold)');
        } else {
          for (int i = 0; i < metrics.soldItems.length; i++) {
            final item = metrics.soldItems[i];
            itemsSummary.writeln(
              '  ${i + 1}. ${item.localizedName(lang)} - ${item.quantity}x (${currencyFormatter.format(item.totalSales)})',
            );
          }
        }

        // Format expenses list for email body
        final expensesSummary = StringBuffer();
        if (metrics.expenses.isEmpty) {
          expensesSummary.writeln('  (Tidak ada pengeluaran dicatat / No expenses recorded)');
        } else {
          for (int i = 0; i < metrics.expenses.length; i++) {
            final exp = metrics.expenses[i];
            expensesSummary.writeln(
              '  ${i + 1}. ${exp.title} - ${currencyFormatter.format(exp.amount)} [${exp.category}]',
            );
          }
        }

        final profitStatus = metrics.isProfit ? 'LABA BERSIH (PROFIT)' : 'RUGI BERSIH (DEFICIT)';
        final profitSign = metrics.isProfit ? '+' : '-';

        final emailBody = '''
Halo / Hello,

Berikut adalah Laporan Akhir Sesi (End of Shift Report) untuk toko: $storeName

==================================================
RINGKASAN KEUANGAN & LABA/RUGI:
==================================================
- Pendapatan Kotor (Gross): ${currencyFormatter.format(metrics.revenue)}
  * Tunai (Cash): ${currencyFormatter.format(metrics.cashRevenue)}
  * QRIS / Digital: ${currencyFormatter.format(metrics.qrisRevenue)}
- Total Pengeluaran (Expenses): ${currencyFormatter.format(metrics.totalExpenses)}
--------------------------------------------------
- HASIL: $profitStatus
- JUMLAH BERSIH: $profitSign ${currencyFormatter.format(metrics.netProfit.abs())}
==================================================

KAS KASIR (DRAWER):
- Modal Awal: ${currencyFormatter.format(currentShift.startingCash)}
- Uang Fisik Kasir: ${currencyFormatter.format(actualEndingCash)}
- Total Pesanan: ${metrics.orderCount}
- Total Item Terjual: ${metrics.itemsSold}

RINCIAN PENGELUARAN:
$expensesSummary
RINCIAN ITEM TERJUAL:
$itemsSummary
Terlampir dokumen resmi laporan PDF dan cadangan data CSV pesanan.

Terima kasih.
''';

        // 4. Email files to owner
        final targetEmail = Supabase.instance.client.auth.currentUser?.email ?? dotenv.env['SMTP_EMAIL'] ?? 'unknown@example.com';
        await reportService.sendReportEmail(
          '$storeName - End of Shift Report (${DateFormat('dd MMM yyyy').format(now)})',
          emailBody,
          [pdfFile, csvFile],
          targetEmail,
        );
        
        // 5. Prune DB (Keep Supabase free tier happy!)
        await reportService.pruneOldData(cutoffDate);
        
        // 6. Reset Queue Number for the next shift/day
        await ref.read(orderRepositoryProvider).resetQueue();
      } catch (e) {
        print('Error generating reports: $e');
      }
        
      ref.invalidateSelf();
    }
  }
}
