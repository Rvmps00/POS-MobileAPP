import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/language_notifier.dart';
import '../data/providers/inventory_providers.dart';

class BatchRestockScreen extends ConsumerStatefulWidget {
  const BatchRestockScreen({super.key});

  @override
  ConsumerState<BatchRestockScreen> createState() => _BatchRestockScreenState();
}

class _BatchRestockScreenState extends ConsumerState<BatchRestockScreen> {
  final Map<String, int> _restockQuantities = {};
  final Set<String> _selectedIds = {};
  bool _isSubmitting = false;

  Future<void> _submitBatchRestock() async {
    if (_restockQuantities.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.batchRestock(_restockQuantities);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_restockQuantities.length} items restocked successfully!',
            ),
          ),
        );
        context.pop();
      }
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
    final productsAsync = ref.watch(inventoryProductsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(lang == 'en' ? 'Batch Restock' : 'Restok Massal'),
        actions: [
          if (_restockQuantities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitBatchRestock,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check, size: 18),
                label: Text(
                  lang == 'en'
                      ? 'Save (${_restockQuantities.length})'
                      : 'Simpan (${_restockQuantities.length})',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final isSelected = _selectedIds.contains(product.id);
              final restockQty = _restockQuantities[product.id] ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected
                      ? BorderSide(color: colorScheme.primary, width: 2)
                      : BorderSide.none,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Select checkbox
                      Checkbox(
                        value: isSelected,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedIds.add(product.id);
                              _restockQuantities[product.id] = 10;
                            } else {
                              _selectedIds.remove(product.id);
                              _restockQuantities.remove(product.id);
                            }
                          });
                        },
                      ),
                      // Product info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${lang == 'en' ? 'Current' : 'Stok'}: ${product.stockQty}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quantity input (only if selected)
                      if (isSelected) ...[
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (restockQty > 1) {
                              setState(() {
                                _restockQuantities[product.id] =
                                    restockQty - 1;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          width: 48,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            controller: TextEditingController(
                              text: restockQty.toString(),
                            ),
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null && parsed > 0) {
                                setState(() {
                                  _restockQuantities[product.id] = parsed;
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              _restockQuantities[product.id] = restockQty + 1;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
