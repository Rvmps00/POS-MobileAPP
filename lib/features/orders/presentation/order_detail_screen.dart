import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:pos_mobile_app/core/database/app_database.dart';
import '../data/providers/order_provider.dart';
import '../../../../core/printer/printer_providers.dart';
import '../../../../core/printer/receipt_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderDetailScreen extends ConsumerWidget {
  final OrdersTableData order;

  const OrderDetailScreen({super.key, required this.order});

  void _confirmCancel(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(orderActionsProvider).cancelOrder(order.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order Cancelled Successfully')),
              );
              Navigator.pop(context); // Go back to history list
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    final itemsAsync = ref.watch(orderItemsProvider(order.id));
    final isCancelled = order.status == 'CANCELLED';

    return Scaffold(
      appBar: AppBar(
        title: Text(order.orderNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Reprint Receipt',
            onPressed: () async {
              final printerService = ref.read(printerServiceProvider);
              if (await printerService.isConnected) {
                final prefs = ref.read(sharedPreferencesProvider);
                final storeName = prefs.getString('store_name') ?? 'LESEHAN SURYA';
                final storeAddress = prefs.getString('store_address') ?? '';
                final storePhone = prefs.getString('store_phone') ?? '';
                final storeFooter = prefs.getString('store_footer') ?? 'Terima Kasih!\nSelamat Menikmati 🙏';
                
                final cashierEmail = Supabase.instance.client.auth.currentUser?.email;
                final cashierName = cashierEmail?.split('@').first ?? 'Kasir';

                final items = itemsAsync.value ?? [];

                final bytes = await ReceiptBuilder.buildReceiptFromOrder(
                  order: order,
                  items: items,
                  cashierName: cashierName,
                  storeName: storeName,
                  storeAddress: storeAddress,
                  storePhone: storePhone,
                  footerMessage: storeFooter,
                );

                final printSuccess = await printerService.printBytes(bytes);
                if (!printSuccess && context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Failed to print receipt.'), backgroundColor: Colors.red),
                   );
                } else if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Receipt printed successfully.')),
                   );
                }
              } else if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Printer not connected.'), backgroundColor: Colors.red),
                 );
              }
            },
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (items) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (isCancelled)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer),
                      const SizedBox(width: 8),
                      Text(
                        'This order has been cancelled.',
                        style: TextStyle(color: colorScheme.onErrorContainer, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Type', order.orderType),
                      const SizedBox(height: 8),
                      _buildInfoRow('Date', dateFormatter.format(order.createdAt)),
                      const SizedBox(height: 8),
                      _buildInfoRow('Table', order.tableNumber?.toString() ?? '-'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Status', order.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Items', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text('${item.quantity}x ${item.productName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.selectedVariation != null) Text('Variation: ${item.selectedVariation}'),
                          // Addon toppings and removed ingredients would be parsed here from JSON if needed
                          if (item.notes != null && item.notes!.isNotEmpty) Text('Note: ${item.notes}'),
                        ],
                      ),
                      trailing: Text(currencyFormatter.format(item.lineTotal)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', currencyFormatter.format(order.subtotal)),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Tax', currencyFormatter.format(order.taxAmount)),
                      const Divider(),
                      _buildSummaryRow('Grand Total', currencyFormatter.format(order.grandTotal), isBold: true),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Cash Received', currencyFormatter.format(order.cashReceived)),
                      _buildSummaryRow('Change', currencyFormatter.format(order.cashChange)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (!isCancelled)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Order'),
                  onPressed: () => _confirmCancel(context, ref),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
