import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/catalog_providers.dart';

class CategoryTabBar extends ConsumerWidget {
  final String languageCode;

  const CategoryTabBar({super.key, this.languageCode = 'id'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // "All" tab
            _buildTab(
              context: context,
              label: languageCode == 'en' ? 'All' : 'Semua',
              isSelected: selectedCategory == null,
              onTap: () =>
                  ref.read(selectedCategoryProvider.notifier).select(null),
              colorScheme: colorScheme,
            ),
            const SizedBox(width: 8),
            // Category tabs
            ...categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildTab(
                  context: context,
                  label:
                      '${category.localizedName(languageCode)} ${category.icon ?? ''}',
                  isSelected: selectedCategory == category.id,
                  onTap: () => ref
                      .read(selectedCategoryProvider.notifier)
                      .select(category.id),
                  colorScheme: colorScheme,
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => SizedBox(
        height: 44,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (e, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
