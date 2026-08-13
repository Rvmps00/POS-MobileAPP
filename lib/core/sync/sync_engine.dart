import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../database/app_database.dart';
import 'connectivity_service.dart';

/// Offline-first sync engine that:
/// 1. Queues all mutations locally in `sync_queue`
/// 2. Processes the queue when connectivity is restored
/// 3. Retries with exponential backoff (max 3 attempts)
/// 4. Uses last-write-wins for conflict resolution
class SyncEngine {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final ConnectivityService _connectivity;

  StreamSubscription<bool>? _connectivitySub;
  bool _isProcessing = false;

  SyncEngine(this._db, this._supabase, this._connectivity) {
    // Auto-trigger sync when transitioning from offline → online
    _connectivitySub = _connectivity.onlineStream.listen((isOnline) {
      if (isOnline && !_isProcessing) {
        processQueue();
      }
    });
  }

  /// Enqueue a mutation for later sync to Supabase.
  Future<void> enqueue({
    required String tableName,
    required String recordId,
    required String operation, // INSERT, UPDATE, DELETE
    required Map<String, dynamic> payload,
  }) async {
    await _db.into(_db.syncQueueTable).insert(
      SyncQueueTableCompanion.insert(
        tableName_: tableName,
        recordId: recordId,
        operation: operation,
        payload: json.encode(payload),
        createdAt: drift.Value(DateTime.now()),
      ),
    );

    // Attempt immediate sync if online
    if (_connectivity.isOnline && !_isProcessing) {
      processQueue();
    }
  }

  /// Process all pending items in FIFO order.
  Future<void> processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      while (true) {
        // Get next pending item
        final query = _db.select(_db.syncQueueTable)
          ..where(
            (t) => t.status.equals('PENDING') | t.status.equals('FAILED'),
          )
          ..where((t) => t.retryCount.isSmallerThanValue(3))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.id)])
          ..limit(1);

        final item = await query.getSingleOrNull();
        if (item == null) break;

        try {
          await _processItem(item);
          // Mark as synced
          await (_db.update(_db.syncQueueTable)
                ..where((t) => t.id.equals(item.id)))
              .write(
            const SyncQueueTableCompanion(
              status: drift.Value('SYNCED'),
            ),
          );
        } catch (e) {
          final newRetryCount = item.retryCount + 1;
          await (_db.update(_db.syncQueueTable)
                ..where((t) => t.id.equals(item.id)))
              .write(
            SyncQueueTableCompanion(
              status: drift.Value(
                newRetryCount >= 3 ? 'FAILED' : 'PENDING',
              ),
              retryCount: drift.Value(newRetryCount),
            ),
          );

          // Exponential backoff: 1s, 4s, 16s
          if (newRetryCount < 3) {
            final delay = Duration(
              seconds: (1 << (2 * (newRetryCount - 1))),
            );
            await Future.delayed(delay);
          } else {
            debugPrint('SyncEngine: Item ${item.id} failed after 3 retries: $e');
          }
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    final payload = json.decode(item.payload) as Map<String, dynamic>;

    switch (item.operation) {
      case 'INSERT':
        await _supabase.from(item.tableName_).upsert(payload);
        break;
      case 'UPDATE':
        final id = payload.remove('id');
        await _supabase.from(item.tableName_).update(payload).eq('id', id);
        break;
      case 'DELETE':
        await _supabase.from(item.tableName_).delete().eq('id', item.recordId);
        break;
    }
  }

  /// Count of pending sync items.
  Stream<int> watchPendingCount() {
    final query = _db.selectOnly(_db.syncQueueTable)
      ..where(
        _db.syncQueueTable.status.equals('PENDING') |
            _db.syncQueueTable.status.equals('FAILED'),
      )
      ..addColumns([_db.syncQueueTable.id.count()]);

    return query.map((row) => row.read(_db.syncQueueTable.id.count()) ?? 0).watchSingle();
  }

  /// Clean up synced items older than 24 hours.
  Future<void> cleanSyncedItems() async {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    await (_db.delete(_db.syncQueueTable)
          ..where((t) => t.status.equals('SYNCED'))
          ..where((t) => t.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}
