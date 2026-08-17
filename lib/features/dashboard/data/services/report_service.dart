import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart' as drift;

import 'package:pos_mobile_app/core/database/app_database.dart';
import '../providers/shift_provider.dart';
import '../providers/dashboard_provider.dart';

class ReportService {
  final AppDatabase db;
  final SupabaseClient supabase;

  ReportService(this.db, this.supabase);

  // 1. Generate End of Day PDF
  Future<Uint8List> generateEndOfDayPdf(ShiftModel shift, DashboardMetrics metrics) async {
    final pdf = pw.Document();
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('End of Shift Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Shift Started: ${dateFormatter.format(shift.startTime)}'),
              pw.Text('Shift Ended: ${dateFormatter.format(DateTime.now())}'),
              pw.SizedBox(height: 20),
              pw.Text('Starting Cash: ${currencyFormatter.format(shift.startingCash)}'),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Sales Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Revenue:'),
                  pw.Text(currencyFormatter.format(metrics.revenue)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Orders:'),
                  pw.Text('${metrics.orderCount}'),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Items Sold:'),
                  pw.Text('${metrics.itemsSold}'),
                ],
              ),
            ],
          );
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
  Future<bool> sendReportEmail(String subject, String body, List<File> attachments) async {
    final email = dotenv.env['SMTP_EMAIL'];
    final password = dotenv.env['SMTP_PASSWORD'];

    if (email == null || email.isEmpty || password == null || password.isEmpty) {
      print('SMTP credentials not configured in .env');
      return false;
    }

    final smtpServer = gmail(email, password);
    final message = Message()
      ..from = Address(email, 'Lesehan Surya POS')
      ..recipients.add(email) // Sending to self for records
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
    await (db.delete(db.ordersTable)..where((t) => t.createdAt.isSmallerThanValue(olderThan))).go();
  }
}
