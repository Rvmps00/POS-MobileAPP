import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/addon_topping_model.dart';
import '../data/providers/catalog_providers.dart';

class ToppingManagementScreen extends ConsumerStatefulWidget {
  final String productId;

  const ToppingManagementScreen({super.key, required this.productId});

  @override
  ConsumerState<ToppingManagementScreen> createState() =>
      _ToppingManagementScreenState();
}

class _ToppingManagementScreenState
    extends ConsumerState<ToppingManagementScreen> {
  Future<void> _addTopping() async {
    final result = await _showToppingDialog();
    if (result == null) return;

    final repo = ref.read(catalogRepositoryProvider);
    await repo.createTopping({
      'product_id': widget.productId,
      'name': result['name'],
      'name_en': result['name_en'],
      'price': result['price'] ?? 0,
      'is_available': result['is_available'] ?? true,
      'sort_order': 0,
    });
    ref.invalidate(toppingsProvider(widget.productId));
  }

  Future<void> _editTopping(AddonToppingModel topping) async {
    final result = await _showToppingDialog(topping: topping);
    if (result == null) return;

    final repo = ref.read(catalogRepositoryProvider);
    await repo.updateTopping(topping.id, {
      'name': result['name'],
      'name_en': result['name_en'],
      'price': result['price'],
      'is_available': result['is_available'],
    });
    ref.invalidate(toppingsProvider(widget.productId));
  }

  Future<void> _deleteTopping(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Topping?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final repo = ref.read(catalogRepositoryProvider);
    await repo.deleteTopping(id);
    ref.invalidate(toppingsProvider(widget.productId));
  }

  String _formatPrice(int price) {
    if (price == 0) return 'GRATIS';
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '+Rp $formatted';
  }

  Future<Map<String, dynamic>?> _showToppingDialog({
    AddonToppingModel? topping,
  }) async {
    final nameCtrl = TextEditingController(text: topping?.name ?? '');
    final nameEnCtrl = TextEditingController(text: topping?.nameEn ?? '');
    final priceCtrl = TextEditingController(
      text: topping?.price.toString() ?? '0',
    );
    bool isAvailable = topping?.isAvailable ?? true;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(topping == null ? 'Tambah Topping' : 'Edit Topping'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Topping *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameEnCtrl,
                decoration: InputDecoration(
                  labelText: 'Name (English)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                decoration: InputDecoration(
                  labelText: 'Harga (0 = Gratis)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Tersedia'),
                value: isAvailable,
                onChanged: (v) => setDialogState(() => isAvailable = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx, {
                  'name': nameCtrl.text.trim(),
                  'name_en': nameEnCtrl.text.trim().isEmpty
                      ? null
                      : nameEnCtrl.text.trim(),
                  'price': int.tryParse(priceCtrl.text.trim()) ?? 0,
                  'is_available': isAvailable,
                });
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final toppingsAsync = ref.watch(toppingsProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Tambahan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTopping,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Topping'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: toppingsAsync.when(
        data: (toppings) {
          if (toppings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  const Text('Belum ada tambahan/topping'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16).copyWith(bottom: 80),
            itemCount: toppings.length,
            itemBuilder: (context, index) {
              final item = toppings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.isFree
                          ? Colors.green.withValues(alpha: 0.1)
                          : colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatPrice(item.price),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: item.isFree
                            ? Colors.green.shade700
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.nameEn ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!item.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Habis',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _editTopping(item),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: colorScheme.error,
                        ),
                        onPressed: () => _deleteTopping(item.id),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
