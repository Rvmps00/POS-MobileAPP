import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/printer/printer_providers.dart';
import '../../../../core/printer/receipt_builder.dart';
import '../../../cart/data/models/cart_state_model.dart';

class OrderSuccessDialog extends ConsumerStatefulWidget {
  final String orderNumber;
  final CartState cartState;
  final int cashReceived;
  final int cashChange;
  final int grandTotal;
  final String paymentMethod;
  final String cashierName;
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final String storeFooter;
  final String lang;
  final bool initialPrintSuccess;

  const OrderSuccessDialog({
    super.key,
    required this.orderNumber,
    required this.cartState,
    required this.cashReceived,
    required this.cashChange,
    required this.grandTotal,
    required this.paymentMethod,
    required this.cashierName,
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
    required this.storeFooter,
    required this.lang,
    required this.initialPrintSuccess,
  });

  @override
  ConsumerState<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}

class _OrderSuccessDialogState extends ConsumerState<OrderSuccessDialog> {
  late int _printCount;
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    _printCount = widget.initialPrintSuccess ? 1 : 0;
  }

  Future<void> _handlePrintAgain() async {
    if (_isPrinting) return;
    setState(() => _isPrinting = true);

    try {
      final printerService = ref.read(printerServiceProvider);
      if (!await printerService.isConnected) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.lang == 'en'
                    ? 'Printer is not connected.'
                    : 'Printer belum terhubung.',
              ),
              backgroundColor: Colors.orange.shade800,
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      final bytes = await ReceiptBuilder.buildReceipt(
        orderNumber: widget.orderNumber,
        cartState: widget.cartState,
        cashReceived: widget.cashReceived,
        cashChange: widget.cashChange,
        cashierName: widget.cashierName,
        paymentMethod: widget.paymentMethod,
        storeName: widget.storeName,
        storeAddress: widget.storeAddress,
        storePhone: widget.storePhone,
        footerMessage: widget.storeFooter,
        lang: widget.lang,
      );

      final success = await printerService.printBytes(bytes);
      if (mounted) {
        if (success) {
          setState(() => _printCount++);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.lang == 'en'
                    ? 'Receipt printed successfully (#$_printCount)'
                    : 'Struk berhasil dicetak (#$_printCount)',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.lang == 'en'
                    ? 'Failed to print receipt.'
                    : 'Gagal mencetak struk.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.lang == 'en'
                  ? 'Error printing receipt: $e'
                  : 'Gagal mencetak struk: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEn = widget.lang == 'en';
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Dialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success checkmark animation circle
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 42,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isEn ? 'Order Successful!' : 'Pesanan Berhasil!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Order Number and Order Type badges
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.orderNumber,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.cartState.orderType == OrderType.dineIn
                          ? (isEn ? 'Dine-in' : 'Makan di Tempat')
                          : (isEn ? 'Takeaway' : 'Bawa Pulang'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Payment and Change Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    // Grand Total Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEn ? 'Total Bill' : 'Total Tagihan',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          currencyFormatter.format(widget.grandTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Payment Method Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEn ? 'Payment Method' : 'Metode Bayar',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              widget.paymentMethod == 'QRIS'
                                  ? Icons.qr_code_2_rounded
                                  : Icons.payments_rounded,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.paymentMethod == 'QRIS'
                                  ? 'QRIS'
                                  : (isEn ? 'Cash' : 'Tunai'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (widget.paymentMethod == 'CASH') ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEn ? 'Cash Received' : 'Uang Diterima',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(widget.cashReceived),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEn ? 'Change Due' : 'Kembalian',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currencyFormatter.format(widget.cashChange),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Print Count Status Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.print_rounded,
                    size: 16,
                    color: _printCount > 0 ? Colors.green : colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _printCount > 0
                        ? (isEn
                            ? 'Printed: $_printCount ${_printCount == 1 ? "copy" : "copies"}'
                            : 'Tercetak: $_printCount kali')
                        : (isEn ? 'Not printed yet' : 'Belum dicetak'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _printCount > 0
                          ? Colors.green.shade700
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Action Buttons
              Row(
                children: [
                  // Print Again Button
                  Expanded(
                    flex: 5,
                    child: OutlinedButton.icon(
                      onPressed: _isPrinting ? null : _handlePrintAgain,
                      icon: _isPrinting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.print_outlined, size: 20),
                      label: Text(
                        isEn ? 'Print Again' : 'Cetak Lagi',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Exit / New Order Button
                  Expanded(
                    flex: 6,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: Text(
                        isEn ? 'New Order' : 'Pesanan Baru',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
