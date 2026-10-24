import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

import '../../features/cart/data/models/cart_state_model.dart';
import '../database/app_database.dart';

class ReceiptBuilder {
  /// Format money (no decimals, dot separator)
  static String formatRp(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  /// Extracts the last 3 digits of the order number as the queue number.
  static String getQueueNumber(String orderNumber) {
    final parts = orderNumber.split('-');
    if (parts.length >= 3) {
      return parts.last;
    }
    return '000';
  }

  static Future<List<int>> buildReceipt({
    required String orderNumber,
    required CartState cartState,
    required int cashReceived,
    required int cashChange,
    required String cashierName,
    String paymentMethod = 'CASH',
    String storeName = 'POINT OF SALE',
    String storeAddress = '',
    String storePhone = '',
    String footerMessage = 'Terima Kasih!\nSelamat Menikmati 🙏',
    String lang = 'id',
  }) async {
    final isEn = lang == 'en';
    final profile = await CapabilityProfile.load();
    // 58mm paper is standard 32 characters per line
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    // Initialize
    bytes += generator.reset();

    // === HEADER ===
    bytes += generator.text(
      storeName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    if (storeAddress.isNotEmpty) {
      bytes += generator.text(storeAddress, styles: const PosStyles(align: PosAlign.center));
    }
    if (storePhone.isNotEmpty) {
      bytes += generator.text(storePhone, styles: const PosStyles(align: PosAlign.center));
    }
    bytes += generator.emptyLines(1);

    // === QUEUE NUMBER ===
    final queueNumber = getQueueNumber(orderNumber);
    bytes += generator.text(
      isEn ? 'QUEUE: $queueNumber' : 'ANTRIAN: $queueNumber',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.emptyLines(1);

    // === ORDER INFO ===
    bytes += generator.hr(ch: '=');
    final dateStr = DateFormat('dd/MM/yyyy  HH:mm').format(DateTime.now());
    bytes += generator.text(isEn ? 'Time  : $dateStr' : 'Waktu : $dateStr');
    bytes += generator.text(isEn ? 'Cashier: $cashierName' : 'Kasir: $cashierName');
    bytes += generator.text('Order : $orderNumber');
    
    final typeStr = cartState.orderType.name == 'dineIn' 
        ? (isEn ? 'Dine-in' : 'Makan di Tempat') 
        : (isEn ? 'Takeaway' : 'Bawa Pulang');
    if (cartState.orderType.name == 'dineIn' && cartState.tableNumber != null) {
      bytes += generator.text('${isEn ? 'Type' : 'Tipe'} : $typeStr    ${isEn ? 'Table' : 'Meja'}: ${cartState.tableNumber}');
    } else {
      bytes += generator.text('${isEn ? 'Type' : 'Tipe'} : $typeStr');
    }
    bytes += generator.hr();

    // === ITEMS ===
    for (final item in cartState.items) {
      // Print Product Name and Total for this line
      final qtyStr = 'x${item.quantity}';
      final totalStr = formatRp(item.lineTotal);
      
      bytes += generator.row([
        PosColumn(
          text: item.product.localizedName(lang),
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: qtyStr,
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: totalStr,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (item.selectedVariation != null) {
        bytes += generator.text('  (${item.selectedVariation})');
      }

      // Modifiers
      for (final topping in item.addedToppings) {
        final tPrice = topping.price > 0 ? '(+${formatRp(topping.price)})' : '(FREE)';
        bytes += generator.text('  + ${topping.localizedName(lang)} $tPrice');
      }
      for (final ing in item.removedIngredients) {
        bytes += generator.text(isEn ? '  - No ${ing.localizedName(lang)}' : '  - Tanpa ${ing.localizedName(lang)}');
      }
      if (item.notes != null && item.notes!.isNotEmpty) {
        bytes += generator.text(isEn ? '  Notes: ${item.notes}' : '  Catatan: ${item.notes}');
      }
    }
    bytes += generator.hr();

    // === TOTALS ===
    bytes += generator.row([
      PosColumn(text: 'Subtotal:', width: 6),
      PosColumn(text: formatRp(cartState.subtotal), width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (cartState.taxAmount > 0) {
      bytes += generator.row([
        PosColumn(text: isEn ? 'Tax (10%):' : 'Pajak (10%):', width: 6),
        PosColumn(text: formatRp(cartState.taxAmount), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    
    bytes += generator.text('                  ============', styles: const PosStyles(align: PosAlign.right));
    bytes += generator.row([
      PosColumn(text: 'TOTAL:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: formatRp(cartState.grandTotal), width: 6, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.text('                  ============', styles: const PosStyles(align: PosAlign.right));
    bytes += generator.emptyLines(1);

    // === PAYMENT ===
    final payMethodLabel = paymentMethod == 'CASH' ? (isEn ? 'Cash' : 'Tunai') : paymentMethod;
    bytes += generator.row([
      PosColumn(text: isEn ? 'Payment:' : 'Pembayaran:', width: 6),
      PosColumn(text: payMethodLabel, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (paymentMethod == 'CASH') {
      bytes += generator.row([
        PosColumn(text: isEn ? 'Cash:' : 'Tunai:', width: 6),
        PosColumn(text: formatRp(cashReceived), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.row([
        PosColumn(text: isEn ? 'Change:' : 'Kembali:', width: 6),
        PosColumn(text: formatRp(cashChange), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += generator.hr();

    // === FOOTER ===
    bytes += generator.text(
      footerMessage,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(2);
    
    // Cut paper (if supported by printer, usually not for mini portable ones, but safe to send)
    // bytes += generator.cut(); 

    return bytes;
  }

  static Future<List<int>> buildReceiptFromOrder({
    required OrdersTableData order,
    required List<OrderItemsTableData> items,
    required String cashierName,
    String storeName = 'POINT OF SALE',
    String storeAddress = '',
    String storePhone = '',
    String footerMessage = 'Terima Kasih!\nSelamat Menikmati 🙏',
    String lang = 'id',
  }) async {
    final isEn = lang == 'en';
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();

    // === HEADER ===
    bytes += generator.text(
      storeName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    if (storeAddress.isNotEmpty) {
      bytes += generator.text(storeAddress, styles: const PosStyles(align: PosAlign.center));
    }
    if (storePhone.isNotEmpty) {
      bytes += generator.text(storePhone, styles: const PosStyles(align: PosAlign.center));
    }
    bytes += generator.emptyLines(1);

    // === QUEUE NUMBER ===
    final queueNumber = getQueueNumber(order.orderNumber);
    bytes += generator.text(
      isEn ? 'QUEUE: $queueNumber' : 'ANTRIAN: $queueNumber',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.emptyLines(1);

    // === ORDER INFO ===
    bytes += generator.hr(ch: '=');
    bytes += generator.text(isEn ? '*** REPRINT ***' : '*** CETAK ULANG ***', styles: const PosStyles(align: PosAlign.center, bold: true));
    final dateStr = DateFormat('dd/MM/yyyy  HH:mm').format(order.createdAt);
    bytes += generator.text(isEn ? 'Time  : $dateStr' : 'Waktu : $dateStr');
    bytes += generator.text(isEn ? 'Cashier: $cashierName' : 'Kasir: $cashierName');
    bytes += generator.text('Order : ${order.orderNumber}');
    
    final typeStr = order.orderType == 'DINE_IN' 
        ? (isEn ? 'Dine-in' : 'Makan di Tempat') 
        : (isEn ? 'Takeaway' : 'Bawa Pulang');
    if (order.orderType == 'DINE_IN' && order.tableNumber != null) {
      bytes += generator.text('${isEn ? 'Type' : 'Tipe'} : $typeStr    ${isEn ? 'Table' : 'Meja'}: ${order.tableNumber}');
    } else {
      bytes += generator.text('${isEn ? 'Type' : 'Tipe'} : $typeStr');
    }
    bytes += generator.hr();

    // === ITEMS ===
    for (final item in items) {
      final qtyStr = 'x${item.quantity}';
      final totalStr = formatRp(item.lineTotal);
      
      bytes += generator.row([
        PosColumn(
          text: item.productName,
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: qtyStr,
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: totalStr,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      if (item.selectedVariation != null && item.selectedVariation!.isNotEmpty) {
        bytes += generator.text('  (${item.selectedVariation})');
      }

      if (item.notes != null && item.notes!.isNotEmpty) {
        bytes += generator.text(isEn ? '  Notes: ${item.notes}' : '  Catatan: ${item.notes}');
      }
    }
    bytes += generator.hr();

    // === TOTALS ===
    bytes += generator.row([
      PosColumn(text: 'Subtotal:', width: 6),
      PosColumn(text: formatRp(order.subtotal), width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (order.taxAmount > 0) {
      bytes += generator.row([
        PosColumn(text: isEn ? 'Tax (10%):' : 'Pajak (10%):', width: 6),
        PosColumn(text: formatRp(order.taxAmount), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    
    bytes += generator.text('                  ============', styles: const PosStyles(align: PosAlign.right));
    bytes += generator.row([
      PosColumn(text: 'TOTAL:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: formatRp(order.grandTotal), width: 6, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.text('                  ============', styles: const PosStyles(align: PosAlign.right));
    bytes += generator.emptyLines(1);

    // === PAYMENT ===
    final method = order.paymentMethod;
    final payMethodLabel = method == 'CASH' ? (isEn ? 'Cash' : 'Tunai') : method;
    bytes += generator.row([
      PosColumn(text: isEn ? 'Payment:' : 'Pembayaran:', width: 6),
      PosColumn(text: payMethodLabel, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    if (method == 'CASH') {
      bytes += generator.row([
        PosColumn(text: isEn ? 'Cash:' : 'Tunai:', width: 6),
        PosColumn(text: formatRp(order.cashReceived ?? order.grandTotal), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
      bytes += generator.row([
        PosColumn(text: isEn ? 'Change:' : 'Kembali:', width: 6),
        PosColumn(text: formatRp(order.cashChange ?? 0), width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    bytes += generator.hr();

    // === FOOTER ===
    bytes += generator.text(
      footerMessage,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(2);

    return bytes;
  }

  static Future<List<int>> buildTestReceipt() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.reset();
    bytes += generator.text(
      'TEST PRINT',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.emptyLines(1);
    bytes += generator.text('Printer is working properly.', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.emptyLines(2);

    return bytes;
  }
}
