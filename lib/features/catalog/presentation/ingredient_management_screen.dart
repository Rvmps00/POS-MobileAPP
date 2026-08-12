import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/default_ingredient_model.dart';
import '../data/providers/catalog_providers.dart';

class IngredientManagementScreen extends ConsumerStatefulWidget {
  final String productId;

  const IngredientManagementScreen({super.key, required this.productId});

  @override
  ConsumerState<IngredientManagementScreen> createState() =>
      _IngredientManagementScreenState();
}

class _IngredientManagementScreenState
    extends ConsumerState<IngredientManagementScreen> {
  Future<void> _addIngredient() async {
    final result = await _showIngredientDialog();
    if (result == null) return;

    final repo = ref.read(catalogRepositoryProvider);
    await repo.createIngredient({
      'product_id': widget.productId,
      'name': result['name'],
      'name_en': result['name_en'],
      'is_removable': result['is_removable'] ?? true,
      'sort_order': 0,
    });
    ref.invalidate(ingredientsProvider(widget.productId));
  }

  Future<void> _editIngredient(DefaultIngredientModel ingredient) async {
    final result = await _showIngredientDialog(ingredient: ingredient);
    if (result == null) return;

    final repo = ref.read(catalogRepositoryProvider);
    await repo.updateIngredient(ingredient.id, {
      'name': result['name'],
      'name_en': result['name_en'],
      'is_removable': result['is_removable'],
    });
    ref.invalidate(ingredientsProvider(widget.productId));
  }

  Future<void> _deleteIngredient(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Bahan?'),
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
    await repo.deleteIngredient(id);
    ref.invalidate(ingredientsProvider(widget.productId));
  }

  Future<Map<String, dynamic>?> _showIngredientDialog({
    DefaultIngredientModel? ingredient,
  }) async {
    final nameCtrl = TextEditingController(text: ingredient?.name ?? '');
    final nameEnCtrl = TextEditingController(text: ingredient?.nameEn ?? '');
    bool isRemovable = ingredient?.isRemovable ?? true;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(ingredient == null ? 'Tambah Bahan' : 'Edit Bahan'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Bahan *',
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
              SwitchListTile(
                title: const Text('Bisa dihilangkan?'),
                value: isRemovable,
                onChanged: (v) => setDialogState(() => isRemovable = v),
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
                  'is_removable': isRemovable,
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
    final ingredientsAsync = ref.watch(ingredientsProvider(widget.productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Bahan Bawaan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addIngredient,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Bahan'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      body: ingredientsAsync.when(
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.list_alt_outlined,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  const Text('Belum ada bahan bawaan'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16).copyWith(bottom: 80),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final item = ingredients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    item.isRemovable
                        ? Icons.check_circle_outline
                        : Icons.lock_outline,
                    color: item.isRemovable
                        ? Colors.green
                        : colorScheme.onSurfaceVariant,
                  ),
                  title: Text(item.name),
                  subtitle: Text(item.nameEn ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: () => _editIngredient(item),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: colorScheme.error,
                        ),
                        onPressed: () => _deleteIngredient(item.id),
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
