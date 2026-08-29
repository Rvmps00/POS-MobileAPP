import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/theme_notifier.dart';
import '../../../core/l10n/language_notifier.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../../core/printer/printer_providers.dart';
import '../../../core/printer/receipt_builder.dart';
import '../../cart/data/providers/cart_provider.dart';
import '../../cart/data/models/cart_state_model.dart';
import '../../orders/data/providers/order_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _cashReceived = 0;
  bool _isProcessing = false;
  String _paymentMethod = 'CASH';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateCashReceived(String value) {
    // Remove non-digit characters
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(cleanValue) ?? 0;
    setState(() {
      _cashReceived = amount;
      if (amount > 0) {
        _amountController.text = NumberFormat.currency(
          locale: 'id_ID',
          symbol: '',
          decimalDigits: 0,
        ).format(amount);
      } else {
        _amountController.text = '';
      }
    });
  }

  void _addQuickAmount(int amount) {
    final current = _cashReceived;
    final newValue = current + amount;
    _updateCashReceived(newValue.toString());
  }

  void _onNumpadTap(String value) {
    if (value == 'backspace') {
      final currentText = _cashReceived.toString();
      if (currentText.length > 1) {
        _updateCashReceived(currentText.substring(0, currentText.length - 1));
      } else {
        _updateCashReceived('0');
      }
    } else {
      final currentText = _cashReceived == 0 ? '' : _cashReceived.toString();
      _updateCashReceived(currentText + value);
    }
  }

  void _setExactAmount(int amount) {
    _updateCashReceived(amount.toString());
  }

  Future<void> _processOrder(int grandTotal) async {
    final effectiveCashReceived = _paymentMethod == 'QRIS' ? grandTotal : _cashReceived;
    final effectiveChange = _paymentMethod == 'QRIS' ? 0 : (_cashReceived - grandTotal);
    
    if (_paymentMethod == 'CASH' && _cashReceived < grandTotal) return;

    setState(() => _isProcessing = true);

    try {
      final cartState = ref.read(cartProvider);
      final orderRepo = ref.read(orderRepositoryProvider);
      final cashierId = ref.read(activeStaffProvider)?.id;

      final orderNumber = await orderRepo.saveOrder(
        cartState: cartState,
        cashReceived: effectiveCashReceived,
        cashChange: effectiveChange,
        paymentMethod: _paymentMethod,
        cashierId: cashierId,
      );

      // Print Receipt
      final printerService = ref.read(printerServiceProvider);
      if (await printerService.isConnected) {
        final prefs = ref.read(sharedPreferencesProvider);
        final storeName = prefs.getString('store_name') ?? 'POINT OF SALE';
        final storeAddress = prefs.getString('store_address') ?? '';
        final storePhone = prefs.getString('store_phone') ?? '';
        final storeFooter = prefs.getString('store_footer') ?? 'Terima Kasih!\nSelamat Menikmati 🙏';
        
        final activeStaff = ref.read(activeStaffProvider);
        final cashierName = activeStaff?.fullName ?? 'Kasir';

        final bytes = await ReceiptBuilder.buildReceipt(
          orderNumber: orderNumber,
          cartState: cartState,
          cashReceived: effectiveCashReceived,
          cashChange: effectiveChange,
          cashierName: cashierName,
          storeName: storeName,
          storeAddress: storeAddress,
          storePhone: storePhone,
          footerMessage: storeFooter,
        );

        final printSuccess = await printerService.printBytes(bytes);
        if (!printSuccess && mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Failed to print receipt.'), backgroundColor: Colors.red),
           );
        }
      }

      // Clear cart and invalidate history
      ref.read(cartProvider.notifier).clearCart();
      ref.invalidate(orderHistoryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Completed Successfully!')),
        );
        // Go back to POS
        context.go('/pos');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final cartState = ref.watch(cartProvider);

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final grandTotal = cartState.grandTotal;
    final change = _paymentMethod == 'QRIS' ? 0 : (_cashReceived - grandTotal);
    final canProcess =
        (_paymentMethod == 'QRIS' || _cashReceived >= grandTotal) &&
        !_isProcessing &&
        cartState.items.isNotEmpty;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Checkout (Cash)' : 'Pembayaran (Tunai)'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 768;
          final content = [
            // Left Side: Order Summary
            isTablet
                ? Expanded(
                    flex: 2,
                    child: _buildLeftSide(
                      lang,
                      cartState,
                      colorScheme,
                      currencyFormatter,
                      grandTotal,
                      isTablet,
                      context,
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: _buildLeftSide(
                      lang,
                      cartState,
                      colorScheme,
                      currencyFormatter,
                      grandTotal,
                      isTablet,
                      context,
                    ),
                  ),
            // Right Side: Payment
            isTablet
                ? Expanded(
                    flex: 3,
                    child: _buildRightSide(
                      lang,
                      colorScheme,
                      grandTotal,
                      change,
                      currencyFormatter,
                      canProcess,
                      isTablet,
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: _buildRightSide(
                      lang,
                      colorScheme,
                      grandTotal,
                      change,
                      currencyFormatter,
                      canProcess,
                      isTablet,
                    ),
                  ),
          ];

          if (isTablet) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: content,
            );
          }
        },
      ),
    );
  }

  Widget _buildLeftSide(
    String lang,
    CartState cartState,
    ColorScheme colorScheme,
    NumberFormat currencyFormatter,
    int grandTotal,
    bool isTablet,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: isTablet
            ? Border(
                right: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              )
            : Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 24 : 20, 
              right: isTablet ? 24 : 20, 
              top: isTablet ? 20 : 16, 
              bottom: isTablet ? 12 : 8,
            ),
            child: Text(
              lang == 'en' ? 'Order Summary' : 'Ringkasan Pesanan',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _buildOrderList(
              cartState,
              lang,
              colorScheme,
              currencyFormatter,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: isTablet ? 24 : 20,
              right: isTablet ? 24 : 20,
              top: isTablet ? 12 : 8,
              bottom: isTablet ? 16 : 12,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'en' ? 'Subtotal' : 'Subtotal',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(cartState.subtotal),
                      style: TextStyle(fontSize: isTablet ? 14 : 12),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 6 : 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'en'
                          ? 'Tax (${(cartState.taxRate * 100).toInt()}%)'
                          : 'Pajak (${(cartState.taxRate * 100).toInt()}%)',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(cartState.taxAmount),
                      style: TextStyle(fontSize: isTablet ? 14 : 12),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 8 : 4),
                  child: const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'en' ? 'Grand Total' : 'Total Akhir',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormatter.format(grandTotal),
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentBottomSheet(
    int grandTotal,
    ColorScheme colorScheme,
    String lang,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang == 'en' ? 'Enter Amount' : 'Masukkan Nominal',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Indicator for typed amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Rp ',
                        style: TextStyle(
                          fontSize: 24,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _amountController,
                          builder: (context, value, child) {
                            return Text(
                              value.text.isEmpty ? '0' : value.text,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Quick Fill Buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuickFillButton(
                      label: 'Exact',
                      amount: grandTotal,
                      colorScheme: colorScheme,
                      onTap: () {
                        _setExactAmount(grandTotal);
                        Navigator.pop(ctx);
                      },
                    ),
                    _QuickFillButton(
                      label: '+ Rp 50.000',
                      amount: 50000,
                      colorScheme: colorScheme,
                      onTap: () => _addQuickAmount(50000),
                    ),
                    _QuickFillButton(
                      label: '+ Rp 100.000',
                      amount: 100000,
                      colorScheme: colorScheme,
                      onTap: () => _addQuickAmount(100000),
                    ),
                    _QuickFillButton(
                      label: '+ Rp 200.000',
                      amount: 200000,
                      colorScheme: colorScheme,
                      onTap: () => _addQuickAmount(200000),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Number Pad
                _NumberPad(onTap: _onNumpadTap, colorScheme: colorScheme),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      lang == 'en' ? 'Done' : 'Selesai',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRightSide(
    String lang,
    ColorScheme colorScheme,
    int grandTotal,
    int change,
    NumberFormat currencyFormatter,
    bool canProcess,
    bool isTablet,
  ) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 32 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Method Selector
                  Text(
                    lang == 'en' ? 'Payment Method' : 'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: [
                        ButtonSegment<String>(
                          value: 'CASH',
                          label: Text(lang == 'en' ? 'Cash' : 'Tunai'),
                          icon: const Icon(Icons.money),
                        ),
                        const ButtonSegment<String>(
                          value: 'QRIS',
                          label: Text('QRIS'),
                          icon: Icon(Icons.qr_code_2),
                        ),
                      ],
                      selected: {_paymentMethod},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _paymentMethod = newSelection.first;
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        selectedBackgroundColor: colorScheme.primaryContainer,
                        selectedForegroundColor: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),

                  if (_paymentMethod == 'CASH') ...[
                    Text(
                      lang == 'en'
                          ? 'Cash Amount Received'
                          : 'Jumlah Uang Tunai Diterima',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Material(
                      color: Colors.transparent,
                      child: Ink(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        ),
                        child: InkWell(
                          onTap: () => _showPaymentBottomSheet(grandTotal, colorScheme, lang),
                          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 24 : 16,
                              vertical: isTablet ? 24 : 12,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Rp ',
                                  style: TextStyle(
                                    fontSize: isTablet ? 24 : 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _amountController.text.isEmpty
                                        ? '0'
                                        : _amountController.text,
                                    style: TextStyle(
                                      fontSize: isTablet ? 32 : 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.edit,
                                  color: colorScheme.primary,
                                  size: isTablet ? 24 : 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // QRIS Instructions
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isTablet ? 24 : 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: isTablet ? 48 : 32,
                            color: colorScheme.primary,
                          ),
                          SizedBox(height: isTablet ? 16 : 12),
                          Text(
                            lang == 'en' 
                                ? 'Please direct the customer to scan the QRIS standee.'
                                : 'Silakan arahkan pelanggan untuk scan QRIS.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Change Display
          if (_paymentMethod == 'CASH')
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 12),
              decoration: BoxDecoration(
                color: change >= 0
                    ? colorScheme.primaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(isTablet ? 24 : 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang == 'en' ? 'Change' : 'Kembalian',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 14,
                      fontWeight: FontWeight.w600,
                      color: change >= 0
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),
                  Text(
                    change >= 0 ? currencyFormatter.format(change) : 'Rp 0',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 20,
                      fontWeight: FontWeight.bold,
                      color: change >= 0
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: isTablet ? 16 : 12),
          // Confirm Order
          SizedBox(
            width: double.infinity,
            height: isTablet ? 64 : 48,
            child: ElevatedButton(
              onPressed: canProcess ? () => _processOrder(grandTotal) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isTablet ? 24 : 12),
                ),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      lang == 'en' 
                          ? (_paymentMethod == 'QRIS' ? 'Confirm QRIS Payment' : 'Confirm Order') 
                          : (_paymentMethod == 'QRIS' ? 'Konfirmasi Pembayaran QRIS' : 'Konfirmasi Pesanan'),
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
    CartState cartState,
    String lang,
    ColorScheme colorScheme,
    NumberFormat currencyFormatter,
  ) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shrinkWrap: true,
      itemCount: cartState.items.length,
      itemBuilder: (context, index) {
        final item = cartState.items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: isTablet ? 12 : 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.quantity}x',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.localizedName(lang),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (item.addedToppings.isNotEmpty)
                      Text(
                        '+ ${item.addedToppings.map((t) => t.localizedName(lang)).join(', ')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                        ),
                      ),
                    if (item.removedIngredients.isNotEmpty)
                      Text(
                        '- Tanpa ${item.removedIngredients.map((i) => i.localizedName(lang)).join(', ')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.error,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                currencyFormatter.format(item.lineTotal),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickFillButton extends StatelessWidget {
  final String label;
  final int amount;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _QuickFillButton({
    required this.label,
    required this.amount,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final Function(String) onTap;
  final ColorScheme colorScheme;

  const _NumberPad({required this.onTap, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '000',
      '0',
      'backspace',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        return Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => onTap(key),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.center,
                child: key == 'backspace'
                    ? Icon(Icons.backspace_outlined, color: colorScheme.onSurface)
                    : Text(
                        key,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
