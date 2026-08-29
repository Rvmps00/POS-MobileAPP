import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<void> _confirmEndShift(BuildContext context) async {
    setState(() => _isEnding = true);
    
    // Call endShift to commit everything, send email, and reset queue
    await ref.read(shiftProvider.notifier).endShift(widget.actualCash);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shift Ended Successfully! Emails Sent.')),
      );
      // Go back to dashboard root
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final shiftState = ref.watch(shiftProvider).value;
    final metricsAsync = ref.watch(dashboardMetricsProvider(null));
    final reportService = ref.watch(reportServiceProvider);
    final receiverEmail = Supabase.instance.client.auth.currentUser?.email ?? dotenv.env['SMTP_EMAIL'] ?? 'Not Configured';

    if (shiftState == null || metricsAsync.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final metrics = metricsAsync.value!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Preview'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            width: double.infinity,
            child: Text(
              'The report and CSV backup will be sent to:\n$receiverEmail',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => reportService.generateEndOfDayPdf(shiftState, metrics),
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
            onPressed: _isEnding ? null : () => _confirmEndShift(context),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isEnding 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Confirm End Shift & Send Email'),
          ),
        ),
      ),
    );
  }
}
