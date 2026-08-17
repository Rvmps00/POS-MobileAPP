import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pos_mobile_app/core/database/app_database.dart';
import 'package:pos_mobile_app/features/catalog/data/providers/catalog_providers.dart';

import '../services/report_service.dart';
import 'dashboard_provider.dart';
import 'package:pos_mobile_app/features/orders/data/providers/order_provider.dart';

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
  
  ShiftModel({required this.id, required this.startTime, required this.startingCash});
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
    return ShiftModel(id: entry.id, startTime: entry.startTime, startingCash: entry.startingCash);
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
      
      // We will calculate expected ending cash here later by summing up cash orders.
      final expectedCash = currentShift.startingCash;
      
      await (_db.update(_db.shiftsTable)..where((t) => t.id.equals(currentShift.id)))
        .write(ShiftsTableCompanion(
          endTime: drift.Value(DateTime.now()),
          actualEndingCash: drift.Value(actualEndingCash),
          expectedEndingCash: drift.Value(expectedCash),
          status: const drift.Value('CLOSED'),
        ));
        
      // --- REPORTING & EFFICIENCY LOGIC ---
      try {
        final metrics = await ref.read(dashboardMetricsProvider(null).future);
        final reportService = ref.read(reportServiceProvider);
        
        // 1. Generate PDF Report and save to File
        final pdfBytes = await reportService.generateEndOfDayPdf(currentShift, metrics);
        final pdfFile = await reportService.savePdfToFile(pdfBytes);
        
        // 2. Generate CSV for old orders (older than 30 days)
        final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
        final csvFile = await reportService.generateOrdersCsv(cutoffDate);
        
        // 3. Email files to owner
        await reportService.sendReportEmail(
          'Lesehan Surya - End of Shift Report',
          'Hello,\n\nAttached is the end of shift report for today. We have also attached a CSV backup of orders older than 30 days.\n\nThank you.',
          [pdfFile, csvFile],
        );
        
        // 4. Prune DB (Keep Supabase free tier happy!)
        await reportService.pruneOldData(cutoffDate);
        
        
        // 5. Reset Queue Number for the next shift/day
        await ref.read(orderRepositoryProvider).resetQueue();
      } catch (e) {
        print('Error generating reports: $e');
      }
        
      ref.invalidateSelf();
    }
  }
}
