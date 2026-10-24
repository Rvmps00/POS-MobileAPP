import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:POSCO/core/database/app_database.dart';
import '../../../../core/l10n/language_notifier.dart';
import '../data/providers/order_provider.dart';
import '../../../../core/printer/printer_providers.dart';
import '../../../../core/printer/receipt_builder.dart';
import '../../auth/data/providers/auth_provider.dart';

class OrderDetailScreen extends ConsumerWidget {
  final OrdersTableData order;

  const OrderDetailScreen({super.key, required this.order});

  void _confirmCancel(BuildContext context, WidgetRef ref, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'en' ? 'Cancel Order' : 'Batalkan Pesanan'),
        content: Text(
          lang == 'en'
              ? 'Are you sure you want to cancel this order? This action cannot be undone.'
              : 'Apakah Anda yakin ingin membatalkan pesanan ini? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'en' ? 'No' : 'Tidak'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(orderActionsProvider).cancelOrder(order.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    lang == 'en'
                        ? 'Order Cancelled Successfully'
                        : 'Pesanan Berhasil Dibatalkan',
                  ),
                ),
              );
              Navigator.pop(context); // Go back to history list
            },
            child: Text(lang == 'en' ? 'Yes, Cancel' : 'Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    final itemsAsync = ref.watch(orderItemsProvider(order.id));
    final isCancelled = order.status == 'CANCELLED';

    final orderTypeLabel = order.orderType == 'DINE_IN'
        ? (lang == 'en' ? 'Dine-in' : 'Makan di tempat')
        : (lang == 'en' ? 'Takeaway' : 'Bawa pulang');

    final statusLabel = isCancelled
        ? (lang == 'en' ? 'CANCELLED' : 'DIBATALKAN')
        : (lang == 'en' ? 'COMPLETED' : 'SELESAI');

    return Scaffold(
      appBar: AppBar(
        title: Text(order.orderNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: lang == 'en' ? 'Reprint Receipt' : 'Cetak Ulang Struk',
            onPressed: () async {
              final printerService = ref.read(printerServiceProvider);
              if (await printerService.isConnected) {
                final prefs = ref.read(sharedPreferencesProvider);
                final storeName = prefs.getString('store_name') ?? 'POINT OF SALE';
                final storeAddress = prefs.getString('store_address') ?? '';
                final storePhone = prefs.getString('store_phone') ?? '';
                final storeFooter = prefs.getString('store_footer') ?? 'Terima Kasih!\nSelamat Menikmati 🙏';
                
                final activeStaff = ref.read(activeStaffProvider);
                final cashierName = activeStaff?.fullName ?? 'Kasir';

                final items = itemsAsync.value ?? [];

                final bytes = await ReceiptBuilder.buildReceiptFromOrder(
                  order: order,
                  items: items,
                  cashierName: cashierName,
                  storeName: storeName,
                  storeAddress: storeAddress,
                  storePhone: storePhone,
                  footerMessage: storeFooter,
                  lang: lang,
                );

                final printSuccess = await printerService.printBytes(bytes);
                if (!printSuccess && context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text(lang == 'en' ? 'Failed to print receipt.' : 'Gagal mencetak struk.'),
                       backgroundColor: Colors.red,
                     ),
                   );
                } else if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text(lang == 'en' ? 'Receipt printed successfully.' : 'Struk berhasil dicetak.'),
                     ),
                   );
                }
              } else if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                     content: Text(lang == 'en' ? 'Printer not connected.' : 'Printer belum terhubung.'),
                     backgroundColor: Colors.red,
                   ),
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
                        lang == 'en'
                            ? 'This order has been cancelled.'
                            : 'Pesanan ini telah dibatalkan.',
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
                      _buildInfoRow(lang == 'en' ? 'Type' : 'Tipe', orderTypeLabel),
                      const SizedBox(height: 8),
                      _buildInfoRow(lang == 'en' ? 'Date' : 'Tanggal', dateFormatter.format(order.createdAt)),
                      const SizedBox(height: 8),
                      _buildInfoRow(lang == 'en' ? 'Table' : 'Meja', order.tableNumber?.toString() ?? '-'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Status', statusLabel),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(lang == 'en' ? 'Items' : 'Daftar Item', style: Theme.of(context).textTheme.titleLarge),
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
                          if (item.selectedVariation != null)
                            Text('${lang == 'en' ? 'Variation' : 'Variasi'}: ${item.selectedVariation}'),
                          if (item.notes != null && item.notes!.isNotEmpty)
                            Text('${lang == 'en' ? 'Note' : 'Catatan'}: ${item.notes}'),
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
                      _buildSummaryRow(lang == 'en' ? 'Tax' : 'Pajak', currencyFormatter.format(order.taxAmount)),
                      const Divider(),
                      _buildSummaryRow(lang == 'en' ? 'Grand Total' : 'Total Akhir', currencyFormatter.format(order.grandTotal), isBold: true),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        lang == 'en' ? 'Payment Method' : 'Metode Pembayaran',
                        order.paymentMethod == 'QRIS' ? 'QRIS' : (lang == 'en' ? 'Cash' : 'Tunai'),
                      ),
                      if (order.paymentMethod != 'QRIS') ...[
                        const SizedBox(height: 8),
                        _buildSummaryRow(lang == 'en' ? 'Cash Received' : 'Uang Diterima', currencyFormatter.format(order.cashReceived)),
                        const SizedBox(height: 8),
                        _buildSummaryRow(lang == 'en' ? 'Change' : 'Kembalian', currencyFormatter.format(order.cashChange)),
                      ],
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
                  label: Text(lang == 'en' ? 'Cancel Order' : 'Batalkan Pesanan'),
                  onPressed: () => _confirmCancel(context, ref, lang),
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
