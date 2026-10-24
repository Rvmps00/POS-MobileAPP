import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/language_notifier.dart';
import '../data/providers/order_provider.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    final ordersAsync = ref.watch(orderHistoryProvider(_searchQuery.isEmpty ? null : _searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Order History' : 'Riwayat Pesanan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: lang == 'en' ? 'Search by Receipt ID...' : 'Cari nomor struk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(orderHistoryProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight - 100,
                  child: Center(
                    child: Text(
                      lang == 'en' ? 'No orders found.' : 'Tidak ada pesanan ditemukan.',
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(orderHistoryProvider);
            },
            child: ListView.separated(
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final order = orders[index];
                final isCancelled = order.status == 'CANCELLED';
                final orderTypeLabel = order.orderType == 'DINE_IN'
                    ? (lang == 'en' ? 'Dine-in' : 'Makan di tempat')
                    : (lang == 'en' ? 'Takeaway' : 'Bawa pulang');

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Row(
                    children: [
                      Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (isCancelled) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lang == 'en' ? 'CANCELLED' : 'DIBATALKAN',
                            style: TextStyle(fontSize: 10, color: colorScheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text('${dateFormatter.format(order.createdAt)} • $orderTypeLabel'),
                  trailing: Text(
                    currencyFormatter.format(order.grandTotal),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCancelled ? colorScheme.outline : colorScheme.onSurface,
                      decoration: isCancelled ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
