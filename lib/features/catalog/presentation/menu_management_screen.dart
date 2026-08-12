import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/language_notifier.dart';
import '../data/providers/catalog_providers.dart';
import 'widgets/product_grid.dart';

class MenuManagementScreen extends ConsumerWidget {
  const MenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final colorScheme = Theme.of(context).colorScheme;

    // Watch all products, ignoring the selected category filter
    final productsAsync = ref.watch(productsProvider(null));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Menu Management' : 'Kelola Menu'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: productsAsync.when(
        data: (products) => ProductGrid(
          products: products,
          languageCode: lang,
          onProductTap: (product) => context.go('/menu/${product.id}/edit'),
          // Hide the "Add" (+ button on card) by passing null, or we can use it to edit as well
          onAddTap: (product) => context.go('/menu/${product.id}/edit'),
        ),
        loading: () => ProductGrid(
          isLoading: true,
          languageCode: lang,
          onProductTap: (_) {},
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                lang == 'en' ? 'Failed to load menu' : 'Gagal memuat menu',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(productsProvider),
                child: Text(lang == 'en' ? 'Retry' : 'Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/menu/add'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
