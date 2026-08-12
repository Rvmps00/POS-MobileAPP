import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/database/app_database.dart';
import '../datasources/catalog_remote_datasource.dart';
import '../datasources/catalog_local_datasource.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/default_ingredient_model.dart';
import '../models/addon_topping_model.dart';
import '../repositories/catalog_repository.dart';

// ─── Database Provider ───
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// ─── Repository Provider ───
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final remote = CatalogRemoteDataSource(Supabase.instance.client);
  final local = CatalogLocalDataSource(db.catalogDao);
  return CatalogRepository(
    remote: remote,
    local: local,
    connectivity: Connectivity(),
  );
});

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? id) => state = id;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
      SelectedCategoryNotifier.new,
    );

// ─── Categories ───
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final categories = await repo.getCategories();
  categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return categories;
});

// ─── Products (filtered by category) ───
final productsProvider = FutureProvider.family<List<ProductModel>, String?>((
  ref,
  categoryId,
) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProducts(categoryId: categoryId);
});

// ─── Filtered Products (uses selectedCategoryProvider) ───
final filteredProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  final categoryId = ref.watch(selectedCategoryProvider);
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProducts(categoryId: categoryId);
});

// ─── Product Detail ───
final productDetailProvider = FutureProvider.family<ProductModel?, String>((
  ref,
  productId,
) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProductById(productId);
});

// ─── Ingredients for a Product ───
final ingredientsProvider =
    FutureProvider.family<List<DefaultIngredientModel>, String>((
      ref,
      productId,
    ) async {
      final repo = ref.watch(catalogRepositoryProvider);
      return repo.getIngredients(productId);
    });

// ─── Toppings for a Product ───
final toppingsProvider = FutureProvider.family<List<AddonToppingModel>, String>(
  (ref, productId) async {
    final repo = ref.watch(catalogRepositoryProvider);
    return repo.getToppings(productId);
  },
);
