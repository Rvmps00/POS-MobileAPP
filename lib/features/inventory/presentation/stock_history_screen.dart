import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/language_notifier.dart';
import '../data/providers/inventory_providers.dart';

class StockHistoryScreen extends ConsumerWidget {
  final String productId;

  const StockHistoryScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final historyAsync = ref.watch(stockHistoryProvider(productId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(lang == 'en' ? 'Stock History' : 'Riwayat Stok'),
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64,
                      color: colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    lang == 'en'
                        ? 'No stock history yet'
                        : 'Belum ada riwayat stok',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return _HistoryCard(
                entry: entry,
                colorScheme: colorScheme,
                lang: lang,
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final StockHistoryData entry;
  final ColorScheme colorScheme;
  final String lang;

  const _HistoryCard({
    required this.entry,
    required this.colorScheme,
    required this.lang,
  });

  IconData _getIcon() {
    switch (entry.changeType) {
      case 'SALE':
        return Icons.shopping_cart;
      case 'RESTOCK':
        return Icons.add_shopping_cart;
      case 'WASTE':
        return Icons.delete_outline;
      case 'ADJUSTMENT':
      default:
        return Icons.tune;
    }
  }

  Color _getColor() {
    switch (entry.changeType) {
      case 'SALE':
        return Colors.blue;
      case 'RESTOCK':
        return Colors.green;
      case 'WASTE':
        return colorScheme.error;
      case 'ADJUSTMENT':
      default:
        return Colors.orange;
    }
  }

  String _getChangeTypeLabel() {
    if (lang == 'en') return entry.changeType;
    switch (entry.changeType) {
      case 'SALE':
        return 'Penjualan';
      case 'RESTOCK':
        return 'Restok';
      case 'WASTE':
        return 'Buang';
      case 'ADJUSTMENT':
      default:
        return 'Koreksi';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = entry.changeAmount > 0;
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIcon(), color: _getColor(), size: 20),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getChangeTypeLabel(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _getColor(),
                        ),
                      ),
                      Text(
                        '${isPositive ? '+' : ''}${entry.changeAmount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isPositive ? Colors.green : colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.previousQty} → ${entry.newQty}',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (entry.notes != null && entry.notes!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      entry.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    dateFormatter.format(entry.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
