import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/cart_item_model.dart';
import '../../../catalog/presentation/widgets/quantity_selector.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final String languageCode;
  final Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.languageCode,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Dismissible(
      key: ValueKey('${item.product.id}_${item.hashCode}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.localizedName(languageCode),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      // Added Toppings
                      if (item.addedToppings.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        ...item.addedToppings.map(
                          (t) => Text(
                            '+ ${t.localizedName(languageCode)} (${currencyFormatter.format(t.price)})',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                      // Removed Ingredients
                      if (item.removedIngredients.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        ...item.removedIngredients.map(
                          (i) => Text(
                            '- Tanpa ${i.localizedName(languageCode)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.error,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                      // Notes
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note,
                              size: 14,
                              color: colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.notes!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.secondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  currencyFormatter.format(item.lineTotal),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 36,
                  child: QuantitySelector(
                    quantity: item.quantity,
                    onChanged: onUpdateQuantity,
                    min: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
