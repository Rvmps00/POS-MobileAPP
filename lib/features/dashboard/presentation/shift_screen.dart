import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'report_preview_screen.dart';

import '../data/providers/shift_provider.dart';

class ShiftScreen extends ConsumerStatefulWidget {
  const ShiftScreen({super.key});

  @override
  ConsumerState<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends ConsumerState<ShiftScreen> {
  final _cashController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  void _submitStartShift() async {
    final amount = double.tryParse(_cashController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (amount < 0) return;

    setState(() => _isLoading = true);
    await ref.read(shiftProvider.notifier).startShift(amount);
    setState(() => _isLoading = false);
    _cashController.clear();
  }

  void _submitEndShift() async {
    // Usually you'd want a popup dialog asking for actual cash counted in the drawer.
    // For now we'll do a simple prompt.
    final amountStr = await showDialog<String>(
      context: context,
      builder: (context) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('End Shift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter actual cash in drawer:'),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(prefixText: 'Rp '),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, ctrl.text),
              child: const Text('End Shift'),
            ),
          ],
        );
      },
    );

    if (amountStr != null && amountStr.isNotEmpty) {
      final actualCash = double.tryParse(amountStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportPreviewScreen(actualCash: actualCash),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final shiftState = ref.watch(shiftProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Shift Management')),
      body: shiftState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (shift) {
          if (shift == null) {
            // Start Shift UI
            return Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storefront, size: 64, color: colorScheme.primary),
                      const SizedBox(height: 16),
                      Text('Start New Shift', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _cashController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Starting Cash in Drawer',
                          prefixText: 'Rp ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _submitStartShift,
                          icon: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.play_arrow),
                          label: const Text('Start Shift'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Active Shift UI
          return Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Shift Active',
                        style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Started At'),
                      subtitle: Text(dateFormatter.format(shift.startTime)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.payments_outlined),
                      title: const Text('Starting Cash'),
                      subtitle: Text(currencyFormatter.format(shift.startingCash)),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        onPressed: _isLoading ? null : _submitEndShift,
                        icon: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.stop),
                        label: const Text('End Shift'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
