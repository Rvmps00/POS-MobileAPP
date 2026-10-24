import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/printer/printer_providers.dart';
import '../../../core/l10n/language_notifier.dart';
import '../data/providers/shift_provider.dart';
import '../data/providers/dashboard_provider.dart';

class ReportPreviewScreen extends ConsumerStatefulWidget {
  final double actualCash;

  const ReportPreviewScreen({super.key, required this.actualCash});

  @override
  ConsumerState<ReportPreviewScreen> createState() => _ReportPreviewScreenState();
}

class _ReportPreviewScreenState extends ConsumerState<ReportPreviewScreen> {
  bool _isEnding = false;

  Future<void> _confirmEndShift() async {
    final lang = ref.read(languageProvider).languageCode;
    setState(() => _isEnding = true);
    
    // Call endShift to commit everything, send email, and reset queue
    await ref.read(shiftProvider.notifier).endShift(widget.actualCash);
    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang == 'en'
              ? 'Shift Ended Successfully! Emails Sent.'
              : 'Shift berhasil diakhiri! Email telah dikirim.',
        ),
      ),
    );
    // Go back to dashboard root
    context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider).languageCode;
    final shiftState = ref.watch(shiftProvider).value;
    final metricsAsync = ref.watch(dashboardMetricsProvider(null));
    final reportService = ref.watch(reportServiceProvider);
    final prefs = ref.watch(sharedPreferencesProvider);
    final storeName = prefs.getString('store_name') ?? 'POINT OF SALE';
    final receiverEmail = Supabase.instance.client.auth.currentUser?.email ?? dotenv.env['SMTP_EMAIL'] ?? 'Not Configured';

    if (shiftState == null || metricsAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final metrics = metricsAsync.value!;
    final previewShift = ShiftModel(
      id: shiftState.id,
      startTime: shiftState.startTime,
      startingCash: shiftState.startingCash,
      endTime: DateTime.now(),
      actualEndingCash: widget.actualCash,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Report Preview' : 'Pratinjau Laporan'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            width: double.infinity,
            child: Text(
              '${lang == 'en' ? 'The report and CSV backup will be sent to:' : 'Laporan dan cadangan CSV akan dikirim ke:'}\n$receiverEmail',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => reportService.generateEndOfDayPdf(
                previewShift,
                metrics,
                lang: lang,
                storeName: storeName,
              ),
              allowPrinting: false,
              allowSharing: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: _isEnding ? null : () => _confirmEndShift(),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isEnding 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(lang == 'en' ? 'Confirm End Shift & Send Email' : 'Konfirmasi Akhiri Shift & Kirim Email'),
          ),
        ),
      ),
    );
  }
}
