import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/l10n/language_notifier.dart';
import '../../../../core/sync/connectivity_service.dart';
import '../data/providers/inventory_providers.dart';
import 'stock_edit_dialog.dart';

enum InventoryFilter { all, lowStock, outOfStock }

enum InventorySortBy { name, stockAsc, stockDesc, category }

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  InventoryFilter _filter = InventoryFilter.all;
  InventorySortBy _sortBy = InventorySortBy.name;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductsTableData> _filterAndSortProducts(
    List<ProductsTableData> products,
  ) {
    var filtered = products.where((p) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!p.name.toLowerCase().contains(query) &&
            !(p.nameEn?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      // Status filter
      switch (_filter) {
        case InventoryFilter.lowStock:
          return p.stockQty > 0 && p.stockQty <= p.lowStockThreshold;
        case InventoryFilter.outOfStock:
          return p.stockQty <= 0;
        case InventoryFilter.all:
          return true;
      }
    }).toList();

    // Sort
    switch (_sortBy) {
      case InventorySortBy.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case InventorySortBy.stockAsc:
        filtered.sort((a, b) => a.stockQty.compareTo(b.stockQty));
        break;
      case InventorySortBy.stockDesc:
        filtered.sort((a, b) => b.stockQty.compareTo(a.stockQty));
        break;
      case InventorySortBy.category:
        filtered.sort(
          (a, b) => (a.categoryId ?? '').compareTo(b.categoryId ?? ''),
        );
        break;
    }

    return filtered;
  }

  List<AddonToppingsTableData> _filterToppings(
    List<AddonToppingsTableData> toppings,
  ) {
    return toppings.where((t) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!t.name.toLowerCase().contains(query) &&
            !(t.nameEn?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }
      switch (_filter) {
        case InventoryFilter.lowStock:
          return t.stockQty > 0 && t.stockQty <= t.lowStockThreshold;
        case InventoryFilter.outOfStock:
          return t.stockQty <= 0;
        case InventoryFilter.all:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Text(lang == 'en' ? 'Inventory' : 'Inventori'),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: const [
          // Filter and Sort moved to bottom
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar and Sort
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: lang == 'en' ? 'Search...' : 'Cari...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter dropdown
                    PopupMenuButton<InventoryFilter>(
                      icon: Badge(
                        isLabelVisible: _filter != InventoryFilter.all,
                        child: const Icon(Icons.filter_list),
                      ),
                      tooltip: lang == 'en' ? 'Filter' : 'Saring',
                      onSelected: (filter) => setState(() => _filter = filter),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: InventoryFilter.all,
                          child: Text(lang == 'en' ? 'All Items' : 'Semua'),
                        ),
                        PopupMenuItem(
                          value: InventoryFilter.lowStock,
                          child: Text(lang == 'en' ? 'Low Stock' : 'Stok Rendah'),
                        ),
                        PopupMenuItem(
                          value: InventoryFilter.outOfStock,
                          child: Text(lang == 'en' ? 'Out of Stock' : 'Habis'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    // Sort dropdown
                    PopupMenuButton<InventorySortBy>(
                      icon: const Icon(Icons.unfold_more),
                      tooltip: lang == 'en' ? 'Sort' : 'Urutkan',
                      onSelected: (sort) => setState(() => _sortBy = sort),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: InventorySortBy.name,
                          child: Text(lang == 'en' ? 'Name' : 'Nama'),
                        ),
                        PopupMenuItem(
                          value: InventorySortBy.stockAsc,
                          child: Text(lang == 'en' ? 'Stock (Low→High)' : 'Stok (Rendah)'),
                        ),
                        PopupMenuItem(
                          value: InventorySortBy.stockDesc,
                          child: Text(lang == 'en' ? 'Stock (High→Low)' : 'Stok (Tinggi)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tabs and Batch Restock
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: lang == 'en' ? 'Products' : 'Produk',
                          icon: const Icon(Icons.restaurant_menu, size: 18),
                        ),
                        Tab(
                          text: lang == 'en' ? 'Toppings' : 'Topping',
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_business),
                    tooltip: lang == 'en' ? 'Batch Restock' : 'Restok Massal',
                    onPressed: () => context.go('/inventory/batch-restock'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(colorScheme, lang),
          _buildToppingsTab(colorScheme, lang),
        ],
      ),
    );
  }

  Widget _buildProductsTab(ColorScheme colorScheme, String lang) {
    final productsAsync = ref.watch(inventoryProductsProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (products) {
        final filtered = _filterAndSortProducts(products);
        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  lang == 'en' ? 'No products found' : 'Produk tidak ditemukan',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final product = filtered[index];
            return _ProductStockCard(
              product: product,
              colorScheme: colorScheme,
              lang: lang,
              onTap: () => _showStockEditDialog(
                product.id,
                product.name,
                product.stockQty,
                product.lowStockThreshold,
                'PRODUCT',
              ),
              onHistoryTap: () =>
                  context.go('/inventory/${product.id}/history'),
            );
          },
        );
      },
    );
  }

  Widget _buildToppingsTab(ColorScheme colorScheme, String lang) {
    final toppingsAsync = ref.watch(inventoryToppingsProvider);

    return toppingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (toppings) {
        final filtered = _filterToppings(toppings);
        
        // Group toppings by name (case-insensitive and trimmed)
        final grouped = <String, AddonToppingsTableData>{};
        for (final t in filtered) {
          final normalizedName = t.name.trim().toLowerCase();
          if (!grouped.containsKey(normalizedName)) {
            grouped[normalizedName] = t;
          }
        }
        final groupedList = grouped.values.toList();
        // Sort grouped list based on selected sort
        switch (_sortBy) {
          case InventorySortBy.name:
          case InventorySortBy.category:
            groupedList.sort((a, b) => a.name.compareTo(b.name));
            break;
          case InventorySortBy.stockAsc:
            groupedList.sort((a, b) => a.stockQty.compareTo(b.stockQty));
            break;
          case InventorySortBy.stockDesc:
            groupedList.sort((a, b) => b.stockQty.compareTo(a.stockQty));
            break;
        }

        if (groupedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline,
                    size: 64, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  lang == 'en'
                      ? 'No toppings found'
                      : 'Topping tidak ditemukan',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: groupedList.length,
          itemBuilder: (context, index) {
            final topping = groupedList[index];
            return _ToppingStockCard(
              topping: topping,
              colorScheme: colorScheme,
              lang: lang,
              onTap: () => _showStockEditDialog(
                topping.name, // Use name instead of ID so we can edit all matching toppings
                topping.name,
                topping.stockQty,
                topping.lowStockThreshold,
                'TOPPING',
              ),
              onDeleteTap: () => _showDeleteToppingDialog(topping.name, lang),
            );
          },
        );
      },
    );
  }

  void _showStockEditDialog(
    String itemId,
    String itemName,
    int currentStock,
    int threshold,
    String itemType,
  ) {
    showDialog(
      context: context,
      builder: (context) => StockEditDialog(
        itemId: itemId,
        itemName: itemName,
        currentStock: currentStock,
        threshold: threshold,
        itemType: itemType,
      ),
    );
  }

  void _showDeleteToppingDialog(String toppingName, String lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang == 'en' ? 'Delete Topping' : 'Hapus Topping'),
        content: Text(lang == 'en'
            ? 'Are you sure you want to delete all toppings named "$toppingName"?'
            : 'Apakah Anda yakin ingin menghapus semua topping bernama "$toppingName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang == 'en' ? 'Cancel' : 'Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(inventoryRepositoryProvider)
                    .deleteToppingByName(toppingName);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(lang == 'en'
                          ? 'Topping deleted'
                          : 'Topping berhasil dihapus'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              lang == 'en' ? 'Delete' : 'Hapus',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Product Stock Card ───
class _ProductStockCard extends StatelessWidget {
  final ProductsTableData product;
  final ColorScheme colorScheme;
  final String lang;
  final VoidCallback onTap;
  final VoidCallback onHistoryTap;

  const _ProductStockCard({
    required this.product,
    required this.colorScheme,
    required this.lang,
    required this.onTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        product.stockQty > 0 && product.stockQty <= product.lowStockThreshold;
    final isOutOfStock = product.stockQty <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? Image.network(
                        product.imageUrl!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 48,
                          height: 48,
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.restaurant_menu,
                              color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.restaurant_menu,
                            color: colorScheme.onSurfaceVariant),
                      ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lang == 'en' ? 'Stock' : 'Stok'}: ${product.stockQty} • ${lang == 'en' ? 'Threshold' : 'Batas'}: ${product.lowStockThreshold}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOutOfStock
                            ? colorScheme.error
                            : isLowStock
                                ? Colors.orange
                                : colorScheme.onSurfaceVariant,
                        fontWeight: isOutOfStock || isLowStock
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOutOfStock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    lang == 'en' ? 'OUT' : 'HABIS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onError,
                    ),
                  ),
                )
              else if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    lang == 'en' ? 'LOW' : 'RENDAH',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Actions
              IconButton(
                icon: const Icon(Icons.history, size: 20),
                tooltip: lang == 'en' ? 'History' : 'Riwayat',
                onPressed: onHistoryTap,
              ),
              Icon(Icons.add_circle, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Topping Stock Card ───
class _ToppingStockCard extends StatelessWidget {
  final AddonToppingsTableData topping;
  final ColorScheme colorScheme;
  final String lang;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;

  const _ToppingStockCard({
    required this.topping,
    required this.colorScheme,
    required this.lang,
    required this.onTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock =
        topping.stockQty > 0 && topping.stockQty <= topping.lowStockThreshold;
    final isOutOfStock = topping.stockQty <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topping.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lang == 'en' ? 'Stock' : 'Stok'}: ${topping.stockQty} • ${lang == 'en' ? 'Threshold' : 'Batas'}: ${topping.lowStockThreshold}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOutOfStock
                            ? colorScheme.error
                            : isLowStock
                                ? Colors.orange
                                : colorScheme.onSurfaceVariant,
                        fontWeight: isOutOfStock || isLowStock
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOutOfStock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    lang == 'en' ? 'OUT' : 'HABIS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onError,
                    ),
                  ),
                )
              else if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    'LOW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                tooltip: lang == 'en' ? 'Delete' : 'Hapus',
                onPressed: onDeleteTap,
              ),
              Icon(Icons.add_circle, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
