import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/language_notifier.dart';
import '../data/providers/inventory_providers.dart';

class StockEditDialog extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  final int currentStock;
  final int threshold;
  final String itemType; // PRODUCT or TOPPING

  const StockEditDialog({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.currentStock,
    required this.threshold,
    required this.itemType,
  });

  @override
  ConsumerState<StockEditDialog> createState() => _StockEditDialogState();
}

class _StockEditDialogState extends ConsumerState<StockEditDialog> {
  late int _newQty;
  late int _threshold;
  String _changeType = 'ADJUSTMENT';
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _newQty = widget.currentStock;
    _threshold = widget.threshold;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      if (widget.itemType == 'PRODUCT') {
        await repo.updateProductStock(
          productId: widget.itemId,
          newQty: _newQty,
          changeType: _changeType,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
        );
        // Update threshold if changed
        if (_threshold != widget.threshold) {
          await repo.setProductThreshold(widget.itemId, _threshold);
        }
      } else {
        await repo.updateToppingStockByName(
          toppingName: widget.itemId, // we pass the name in itemId for toppings
          newQty: _newQty,
          changeType: _changeType,
          notes: _notesController.text.isNotEmpty
              ? _notesController.text
              : null,
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${lang == 'en' ? 'Current stock' : 'Stok saat ini'}: ${widget.currentStock}',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),

              // Quantity adjustment
              Text(
                lang == 'en' ? 'New Quantity' : 'Jumlah Baru',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAdjustButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_newQty > 0) setState(() => _newQty--);
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100, // Widened to prevent overflow
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28, // Decreased to ensure it fits without clipping
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      controller: TextEditingController(
                        text: _newQty.toString(),
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null && parsed >= 0) {
                          setState(() => _newQty = parsed);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildAdjustButton(
                    icon: Icons.add,
                    onTap: () => setState(() => _newQty++),
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Quick adjust buttons
              Center(
                child: Wrap(
                  spacing: 4, // Reduced spacing
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildQuickButton('+5', () => setState(() => _newQty += 5), colorScheme),
                    _buildQuickButton('+10', () => setState(() => _newQty += 10), colorScheme),
                    _buildQuickButton('+25', () => setState(() => _newQty += 25), colorScheme),
                    _buildQuickButton('+50', () => setState(() => _newQty += 50), colorScheme),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Change type
              Text(
                lang == 'en' ? 'Change Type' : 'Jenis Perubahan',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'RESTOCK',
                    icon: Icon(Icons.add_shopping_cart, size: 24), // Removed text label
                  ),
                  ButtonSegment(
                    value: 'ADJUSTMENT',
                    icon: Icon(Icons.tune, size: 24), // Removed text label
                  ),
                  ButtonSegment(
                    value: 'WASTE',
                    icon: Icon(Icons.delete_outline, size: 24), // Removed text label
                  ),
                ],
                selected: {_changeType},
                onSelectionChanged: (set) =>
                    setState(() => _changeType = set.first),
              ),
              const SizedBox(height: 16),

              // Threshold (products only)
              if (widget.itemType == 'PRODUCT') ...[
                Text(
                  lang == 'en'
                      ? 'Low Stock Threshold'
                      : 'Batas Stok Rendah',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _threshold.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: _threshold.toString(),
                        onChanged: (v) =>
                            setState(() => _threshold = v.toInt()),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '$_threshold',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Notes
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: lang == 'en' ? 'Notes (optional)' : 'Catatan (opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          lang == 'en' ? 'Update Stock' : 'Perbarui Stok',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustButton({
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icon, size: 28),
        ),
      ),
    );
  }

  Widget _buildQuickButton(
    String label,
    VoidCallback onTap,
    ColorScheme colorScheme,
  ) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w700,
        fontSize: 14, // Reverted to 14
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
