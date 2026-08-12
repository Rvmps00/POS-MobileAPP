import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../data/models/product_model.dart';
import '../data/models/default_ingredient_model.dart';
import '../data/models/addon_topping_model.dart';
import '../data/providers/catalog_providers.dart';
import '../../cart/data/models/cart_item_model.dart';
import '../../cart/data/providers/cart_provider.dart';
import 'widgets/ingredient_toggle_tile.dart';
import 'widgets/topping_selection_tile.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/price_display.dart';

class ToppingCustomizerSheet extends ConsumerStatefulWidget {
  final ProductModel product;
  final String languageCode;

  const ToppingCustomizerSheet({
    super.key,
    required this.product,
    this.languageCode = 'id',
  });

  @override
  ConsumerState<ToppingCustomizerSheet> createState() =>
      _ToppingCustomizerSheetState();
}

class _ToppingCustomizerSheetState
    extends ConsumerState<ToppingCustomizerSheet> {
  int _quantity = 1;
  final Set<String> _removedIngredients = {};
  final Set<String> _selectedToppings = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int _calculateTotal(List<AddonToppingModel> toppings) {
    int toppingTotal = 0;
    for (final topping in toppings) {
      if (_selectedToppings.contains(topping.id)) {
        toppingTotal += topping.price;
      }
    }
    return (widget.product.basePrice + toppingTotal) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ingredientsAsync = ref.watch(ingredientsProvider(widget.product.id));
    final toppingsAsync = ref.watch(toppingsProvider(widget.product.id));
    final lang = widget.languageCode;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Product Header
                    _buildProductHeader(colorScheme, lang),
                    const SizedBox(height: 24),
                    // Default Ingredients
                    ingredientsAsync.when(
                      data: (ingredients) {
                        if (ingredients.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return _buildIngredientsSection(
                          ingredients,
                          colorScheme,
                          lang,
                        );
                      },
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    // Addon Toppings
                    toppingsAsync.when(
                      data: (toppings) {
                        if (toppings.isEmpty) return const SizedBox.shrink();
                        return _buildToppingsSection(
                          toppings,
                          colorScheme,
                          lang,
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),
                    // Quantity
                    _buildQuantitySection(colorScheme, lang),
                    const SizedBox(height: 24),
                    // Notes
                    _buildNotesSection(colorScheme, lang),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
              // Bottom bar — Total + Add to Cart
              _buildBottomBar(colorScheme, lang, toppingsAsync),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductHeader(ColorScheme colorScheme, String lang) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child:
              widget.product.imageUrl != null &&
                  widget.product.imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: widget.product.imageUrl!,
                  fit: BoxFit.cover,
                )
              : Icon(
                  Icons.restaurant_outlined,
                  size: 36,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
        ),
        const SizedBox(width: 16),
        // Product info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.localizedName(lang),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              if (widget.product.nameEn != null && lang == 'id')
                Text(
                  widget.product.nameEn!,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                widget.product.formattedPrice,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(
    List<DefaultIngredientModel> ingredients,
    ColorScheme colorScheme,
    String lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          lang == 'en' ? 'Default Ingredients' : 'Bahan Bawaan',
          colorScheme,
        ),
        const SizedBox(height: 8),
        ...ingredients.map(
          (ingredient) => IngredientToggleTile(
            ingredient: ingredient,
            isRemoved: _removedIngredients.contains(ingredient.id),
            languageCode: lang,
            onChanged: (removed) {
              setState(() {
                if (removed) {
                  _removedIngredients.add(ingredient.id);
                } else {
                  _removedIngredients.remove(ingredient.id);
                }
              });
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildToppingsSection(
    List<AddonToppingModel> toppings,
    ColorScheme colorScheme,
    String lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          lang == 'en' ? 'Add Toppings' : 'Tambahan',
          colorScheme,
        ),
        const SizedBox(height: 8),
        ...toppings.map(
          (topping) => ToppingSelectionTile(
            topping: topping,
            isSelected: _selectedToppings.contains(topping.id),
            languageCode: lang,
            onChanged: (selected) {
              setState(() {
                if (selected) {
                  _selectedToppings.add(topping.id);
                } else {
                  _selectedToppings.remove(topping.id);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySection(ColorScheme colorScheme, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(lang == 'en' ? 'Quantity' : 'Jumlah', colorScheme),
        const SizedBox(height: 12),
        Center(
          child: QuantitySelector(
            quantity: _quantity,
            onChanged: (q) => setState(() => _quantity = q),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ColorScheme colorScheme, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(lang == 'en' ? 'Notes' : 'Catatan', colorScheme),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: lang == 'en'
                ? 'Add special instructions...'
                : 'Tambah catatan khusus...',
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    ColorScheme colorScheme,
    String lang,
    AsyncValue<List<AddonToppingModel>> toppingsAsync,
  ) {
    final toppings = toppingsAsync.value ?? [];
    final total = _calculateTotal(toppings);

    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                PriceDisplay(price: total),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Add to Cart button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                final removedIngs =
                    (ref.read(ingredientsProvider(widget.product.id)).value ??
                            [])
                        .where((ing) => _removedIngredients.contains(ing.id))
                        .toList();

                final addedTops = toppings
                    .where((top) => _selectedToppings.contains(top.id))
                    .toList();

                final item = CartItemModel(
                  product: widget.product,
                  quantity: _quantity,
                  removedIngredients: removedIngs,
                  addedToppings: addedTops,
                  notes: _notesController.text.trim(),
                );

                ref.read(cartProvider.notifier).addItem(item);

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                lang == 'en' ? 'Add to Cart' : 'Tambah ke Keranjang',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
