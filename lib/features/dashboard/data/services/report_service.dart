import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;

import 'package:POSCO/core/database/app_database.dart';
import '../providers/shift_provider.dart';
import '../providers/dashboard_provider.dart';

class ReportService {
  final AppDatabase db;
  final SupabaseClient supabase;

  ReportService(this.db, this.supabase);

  // 1. Generate End of Day PDF
  Future<Uint8List> generateEndOfDayPdf(
    ShiftModel shift,
    DashboardMetrics metrics, {
    String lang = 'id',
    String storeName = 'POINT OF SALE',
  }) async {
    final pdf = pw.Document();
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        storeName.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        lang == 'en' ? 'END OF SHIFT REPORT' : 'LAPORAN AKHIR SESI',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        '${lang == 'en' ? 'Printed' : 'Dicetak'}: ${dateFormatter.format(DateTime.now())}',
                        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 12),
            ],
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              '${lang == 'en' ? 'Page' : 'Halaman'} ${context.pageNumber} / ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          );
        },
        build: (pw.Context context) {
          final isEnglish = lang == 'en';
          return [
            // Shift Information Card
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    isEnglish ? 'Shift Details' : 'Informasi Shift',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${isEnglish ? 'Shift Started' : 'Sesi Dimulai'}: ${dateFormatter.format(shift.startTime)}',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '${isEnglish ? 'Shift Ended' : 'Sesi Berakhir'}: ${dateFormatter.format(shift.endTime ?? DateTime.now())}',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '${isEnglish ? 'Starting Cash' : 'Modal Awal'}: ${currencyFormatter.format(shift.startingCash)}',
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                            if (shift.actualEndingCash != null) ...[
                              pw.SizedBox(height: 4),
                              pw.Text(
                                '${isEnglish ? 'Actual Ending Cash' : 'Uang Fisik Akhir'}: ${currencyFormatter.format(shift.actualEndingCash!)}',
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Financial Summary Card
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    isEnglish ? 'Sales & Payment Summary' : 'Ringkasan Penjualan & Pembayaran',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(isEnglish ? 'Total Revenue:' : 'Total Pendapatan:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      pw.Text(currencyFormatter.format(metrics.revenue), style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                    ],
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 12, top: 4),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(isEnglish ? 'Cash (Tunai):' : 'Tunai (Cash):', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                            pw.Text(currencyFormatter.format(metrics.cashRevenue), style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                        pw.SizedBox(height: 2),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(isEnglish ? 'QRIS / Digital:' : 'QRIS / Digital:', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                            pw.Text(currencyFormatter.format(metrics.qrisRevenue), style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(isEnglish ? 'Total Orders:' : 'Total Pesanan:', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('${metrics.orderCount}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(isEnglish ? 'Total Items Sold:' : 'Total Item Terjual:', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text('${metrics.itemsSold}', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(isEnglish ? 'Average Order Value:' : 'Rata-rata Pesanan:', style: const pw.TextStyle(fontSize: 9)),
                      pw.Text(currencyFormatter.format(metrics.averageOrderValue), style: const pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Itemized Sold Items Section
            pw.Text(
              isEnglish ? 'Items Sold Breakdown' : 'Rincian Item Terjual',
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              isEnglish ? 'List of all products and quantities sold during this shift' : 'Daftar semua produk dan jumlah yang terjual pada sesi ini',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 8),

            if (metrics.soldItems.isEmpty)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Center(
                  child: pw.Text(
                    isEnglish ? 'No items sold during this shift.' : 'Belum ada item yang terjual pada sesi ini.',
                    style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                  ),
                ),
              )
            else
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
                headerHeight: 22,
                cellHeight: 20,
                cellStyle: const pw.TextStyle(fontSize: 8),
                oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                headers: [
                  '#',
                  isEnglish ? 'Item Name' : 'Nama Item',
                  isEnglish ? 'Qty Sold' : 'Jumlah',
                  isEnglish ? 'Total Sales' : 'Total Penjualan',
                ],
                data: [
                  for (int i = 0; i < metrics.soldItems.length; i++)
                    [
                      '${i + 1}',
                      metrics.soldItems[i].localizedName(lang),
                      '${metrics.soldItems[i].quantity}x',
                      currencyFormatter.format(metrics.soldItems[i].totalSales),
                    ],
                  // Total summary row
                  [
                    '',
                    isEnglish ? 'TOTAL' : 'TOTAL',
                    '${metrics.itemsSold}x',
                    currencyFormatter.format(metrics.revenue),
                  ],
                ],
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
                columnWidths: {
                  0: const pw.FixedColumnWidth(25),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1.8),
                },
              ),
          ];
        },
      ),
    );

    return await pdf.save();
  }

  Future<File> savePdfToFile(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/end_of_day_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  // 2. Generate CSV for Monthly Backup
  Future<File> generateOrdersCsv(DateTime olderThan) async {
    // Fetch orders
    final orders = await (db.select(db.ordersTable)..where((t) => t.createdAt.isSmallerThanValue(olderThan))).get();
    
    List<List<dynamic>> rows = [
      ['Order ID', 'Order Number', 'Date', 'Type', 'Table', 'Subtotal', 'Tax', 'Grand Total', 'Status']
    ];

    for (final order in orders) {
      rows.add([
        order.id,
        order.orderNumber,
        order.createdAt,
        order.orderType,
        order.tableNumber ?? '-',
        order.subtotal,
        order.taxAmount,
        order.grandTotal,
        order.status,
      ]);
    }

    String csvData = rows.map((row) {
      return row.map((field) {
        final fieldString = field.toString().replaceAll('"', '""');
        return '"$fieldString"';
      }).join(',');
    }).join('\n');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/orders_backup_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);
    return file;
  }

  // 3. Email Report
  Future<bool> sendReportEmail(String subject, String body, List<File> attachments, String targetEmail) async {
    final email = dotenv.env['SMTP_EMAIL'];
    final password = dotenv.env['SMTP_PASSWORD'];

    if (email == null || email.isEmpty || password == null || password.isEmpty) {
      print('SMTP credentials not configured in .env');
      return false;
    }

    final smtpServer = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'POS (Point of Sale)')
      ..recipients.add(targetEmail) 
      ..subject = subject
      ..text = body;

    for (var file in attachments) {
      message.attachments.add(FileAttachment(file));
    }

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  // 4. Prune Old Data
  Future<void> pruneOldData(DateTime olderThan) async {
    final dateStr = olderThan.toIso8601String();
    
    // Cloud Delete (Supabase)
    try {
      await supabase.from('orders').delete().lt('created_at', dateStr);
      print('Supabase pruning successful');
    } catch (e) {
      print('Supabase pruning failed: $e');
      // If cloud fails, we might still want to prune local, but typically we want them to stay in sync.
    }

    // Local Delete
    // Temporarily disabled to prevent accidental wipes due to SQLite DateTime type comparison issues
    // await (db.delete(db.ordersTable)..where((t) => t.createdAt.isSmallerThanValue(olderThan))).go();
  }
}
