import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onAddTap;
  final String languageCode;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddTap,
    this.languageCode = 'id',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isOutOfStock = product.isOutOfStock;

    return GestureDetector(
      onTap: isOutOfStock ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image area
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    color: colorScheme.surfaceContainer,
                    child: product.imageUrl != null &&
                            product.imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Center(
                              child: Icon(
                                Icons.restaurant_outlined,
                                size: 40,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Center(
                              child: Icon(
                                Icons.restaurant_outlined,
                                size: 40,
                                color: colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.restaurant_outlined,
                              size: 40,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                  ),
                ),
                // Info area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.localizedName(languageCode),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                product.formattedPrice,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            if (!isOutOfStock)
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: Material(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(100),
                                  child: InkWell(
                                    onTap: onAddTap ?? onTap,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Out of stock overlay
            if (isOutOfStock)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        languageCode == 'en' ? 'Out of Stock' : 'Habis',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
