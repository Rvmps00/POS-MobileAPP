import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/language_notifier.dart';
import '../../catalog/data/providers/catalog_providers.dart';
import '../../catalog/data/models/product_model.dart';
import 'widgets/category_tab_bar.dart';
import 'widgets/product_grid.dart';
import 'widgets/floating_cart_bar.dart';
import 'widgets/order_panel.dart';
import 'topping_customizer_sheet.dart';
import '../../cart/data/providers/cart_provider.dart';
import '../../auth/data/providers/auth_provider.dart';

class MainPosScreen extends ConsumerWidget {
  const MainPosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 768;
          if (isTablet) {
            return _TabletLayout(languageCode: lang);
          }
          return _MobileLayout(languageCode: lang);
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────
// MOBILE LAYOUT
// ──────────────────────────────────────────────
class _MobileLayout extends ConsumerWidget {
  final String languageCode;

  const _MobileLayout({required this.languageCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final productsAsync = ref.watch(filteredProductsProvider);
    final cartState = ref.watch(cartProvider);

    return Stack(
      children: [
        Column(
          children: [
            // AppBar
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.restaurant,
                          color: colorScheme.onSurface,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lesehan Surya POS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    // Switch User Button
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      tooltip: languageCode == 'en' ? 'Switch User' : 'Ganti Pengguna',
                      onPressed: () {
                        ref.read(activeStaffProvider.notifier).clearActiveStaff();
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Category Tabs
            CategoryTabBar(languageCode: languageCode),
            const SizedBox(height: 8),
            // Product Grid
            Expanded(
              child: productsAsync.when(
                data: (products) => ProductGrid(
                  products: products,
                  languageCode: languageCode,
                  onProductTap: (product) =>
                      _showCustomizer(context, ref, product),
                  onAddTap: (product) => _showCustomizer(context, ref, product),
                ),
                loading: () => ProductGrid(
                  isLoading: true,
                  languageCode: languageCode,
                  onProductTap: (_) {},
                ),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        languageCode == 'en'
                            ? 'Failed to load products'
                            : 'Gagal memuat produk',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            ref.invalidate(filteredProductsProvider),
                        child: Text(
                          languageCode == 'en' ? 'Retry' : 'Coba Lagi',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Floating Cart Bar (connects to cart in Phase 3)
        if (cartState.items.isNotEmpty)
          FloatingCartBar(
            itemCount: cartState.items.length,
            totalPrice: cartState.grandTotal,
            languageCode: languageCode,
            onTap: () => context.push('/pos/cart'),
          ),
      ],
    );
  }

  void _showCustomizer(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ToppingCustomizerSheet(product: product, languageCode: languageCode),
    );
  }
}

// ──────────────────────────────────────────────
// TABLET LAYOUT
// ──────────────────────────────────────────────
class _TabletLayout extends ConsumerWidget {
  final String languageCode;

  const _TabletLayout({required this.languageCode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final productsAsync = ref.watch(filteredProductsProvider);

    return Row(
      children: [
        // Left side — Product Canvas
        Expanded(
          child: Column(
            children: [
              // AppBar
              Container(
                height: 72,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.primary),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lesehan Surya POS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Online indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Switch User Button
                    IconButton(
                      icon: const Icon(Icons.person_outline),
                      tooltip: languageCode == 'en' ? 'Switch User' : 'Ganti Pengguna',
                      onPressed: () {
                        ref.read(activeStaffProvider.notifier).clearActiveStaff();
                      },
                    ),
                  ],
                ),
              ),
              // Category Tabs
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceBright.withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(color: colorScheme.surfaceContainerHigh),
                  ),
                ),
                child: CategoryTabBar(languageCode: languageCode),
              ),
              // Product Grid
              Expanded(
                child: productsAsync.when(
                  data: (products) => ProductGrid(
                    products: products,
                    languageCode: languageCode,
                    onProductTap: (product) =>
                        _showCustomizer(context, ref, product),
                    onAddTap: (product) =>
                        _showCustomizer(context, ref, product),
                  ),
                  loading: () => ProductGrid(
                    isLoading: true,
                    languageCode: languageCode,
                    onProductTap: (_) {},
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      languageCode == 'en'
                          ? 'Error loading products'
                          : 'Gagal memuat produk',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Right side — Order Panel
        OrderPanel(languageCode: languageCode),
      ],
    );
  }

  void _showCustomizer(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ToppingCustomizerSheet(product: product, languageCode: languageCode),
    );
  }
}
