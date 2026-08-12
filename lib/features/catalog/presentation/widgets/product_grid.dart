import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';
import 'product_card_skeleton.dart';
import 'empty_catalog_state.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel>? products;
  final bool isLoading;
  final String languageCode;
  final void Function(ProductModel product) onProductTap;
  final void Function(ProductModel product)? onAddTap;

  const ProductGrid({
    super.key,
    this.products,
    this.isLoading = false,
    this.languageCode = 'id',
    required this.onProductTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeletonGrid(context);
    }

    if (products == null || products!.isEmpty) {
      return EmptyCatalogState(languageCode: languageCode);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: products!.length,
          itemBuilder: (context, index) {
            final product = products![index];
            return ProductCard(
              product: product,
              languageCode: languageCode,
              onTap: () => onProductTap(product),
              onAddTap: onAddTap != null ? () => onAddTap!(product) : null,
            );
          },
        );
      },
    );
  }

  Widget _buildSkeletonGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => const ProductCardSkeleton(),
        );
      },
    );
  }
}
