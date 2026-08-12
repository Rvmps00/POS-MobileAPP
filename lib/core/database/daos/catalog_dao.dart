import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/products_table.dart';
import '../tables/default_ingredients_table.dart';
import '../tables/addon_toppings_table.dart';

part 'catalog_dao.g.dart';

@DriftAccessor(tables: [
  CategoriesTable,
  ProductsTable,
  DefaultIngredientsTable,
  AddonToppingsTable,
])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  // ─── Categories ───
  Future<List<CategoriesTableData>> getAllCategories() =>
      (select(categoriesTable)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<CategoriesTableData>> watchAllCategories() =>
      (select(categoriesTable)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<void> upsertCategory(CategoriesTableCompanion category) =>
      into(categoriesTable).insertOnConflictUpdate(category);

  Future<void> upsertCategories(List<CategoriesTableCompanion> categories) async {
    await batch((batch) {
      for (final category in categories) {
        batch.insert(categoriesTable, category, onConflict: DoUpdate((_) => category));
      }
    });
  }

  Future<int> deleteCategory(String id) =>
      (delete(categoriesTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearCategories() => delete(categoriesTable).go();

  // ─── Products ───
  Future<List<ProductsTableData>> getAllProducts() =>
      (select(productsTable)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  Stream<List<ProductsTableData>> watchAllProducts() =>
      (select(productsTable)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<List<ProductsTableData>> getProductsByCategory(String categoryId) =>
      (select(productsTable)
            ..where((t) => t.categoryId.equals(categoryId))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Stream<List<ProductsTableData>> watchProductsByCategory(String categoryId) =>
      (select(productsTable)
            ..where((t) => t.categoryId.equals(categoryId))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<ProductsTableData?> getProductById(String id) =>
      (select(productsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertProduct(ProductsTableCompanion product) =>
      into(productsTable).insertOnConflictUpdate(product);

  Future<void> upsertProducts(List<ProductsTableCompanion> products) async {
    await batch((batch) {
      for (final product in products) {
        batch.insert(productsTable, product, onConflict: DoUpdate((_) => product));
      }
    });
  }

  Future<int> deleteProduct(String id) =>
      (delete(productsTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearProducts() => delete(productsTable).go();

  // ─── Default Ingredients ───
  Future<List<DefaultIngredientsTableData>> getIngredientsByProduct(String productId) =>
      (select(defaultIngredientsTable)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<DefaultIngredientsTableData>> watchIngredientsByProduct(String productId) =>
      (select(defaultIngredientsTable)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<void> upsertIngredient(DefaultIngredientsTableCompanion ingredient) =>
      into(defaultIngredientsTable).insertOnConflictUpdate(ingredient);

  Future<void> upsertIngredients(List<DefaultIngredientsTableCompanion> ingredients) async {
    await batch((batch) {
      for (final ingredient in ingredients) {
        batch.insert(defaultIngredientsTable, ingredient, onConflict: DoUpdate((_) => ingredient));
      }
    });
  }

  Future<int> deleteIngredient(String id) =>
      (delete(defaultIngredientsTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearIngredientsByProduct(String productId) =>
      (delete(defaultIngredientsTable)..where((t) => t.productId.equals(productId))).go();

  // ─── Addon Toppings ───
  Future<List<AddonToppingsTableData>> getToppingsByProduct(String productId) =>
      (select(addonToppingsTable)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<AddonToppingsTableData>> watchToppingsByProduct(String productId) =>
      (select(addonToppingsTable)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<void> upsertTopping(AddonToppingsTableCompanion topping) =>
      into(addonToppingsTable).insertOnConflictUpdate(topping);

  Future<void> upsertToppings(List<AddonToppingsTableCompanion> toppings) async {
    await batch((batch) {
      for (final topping in toppings) {
        batch.insert(addonToppingsTable, topping, onConflict: DoUpdate((_) => topping));
      }
    });
  }

  Future<int> deleteTopping(String id) =>
      (delete(addonToppingsTable)..where((t) => t.id.equals(id))).go();

  Future<void> clearToppingsByProduct(String productId) =>
      (delete(addonToppingsTable)..where((t) => t.productId.equals(productId))).go();
}
