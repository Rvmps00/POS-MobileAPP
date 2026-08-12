import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/catalog_dao.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/default_ingredient_model.dart';
import '../models/addon_topping_model.dart';

class CatalogLocalDataSource {
  final CatalogDao _dao;

  CatalogLocalDataSource(this._dao);

  // ─── Categories ───
  Future<List<CategoryModel>> getCategories() async {
    final rows = await _dao.getAllCategories();
    return rows.map(_categoryFromRow).toList();
  }

  Stream<List<CategoryModel>> watchCategories() {
    return _dao.watchAllCategories().map(
      (rows) => rows.map(_categoryFromRow).toList(),
    );
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final companions = categories.map(_categoryToCompanion).toList();
    await _dao.upsertCategories(companions);
  }

  Future<void> clearCategories() => _dao.clearCategories();

  // ─── Products ───
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    final rows = categoryId != null
        ? await _dao.getProductsByCategory(categoryId)
        : await _dao.getAllProducts();
    return rows.map(_productFromRow).toList();
  }

  Stream<List<ProductModel>> watchProducts({String? categoryId}) {
    final stream = categoryId != null
        ? _dao.watchProductsByCategory(categoryId)
        : _dao.watchAllProducts();
    return stream.map((rows) => rows.map(_productFromRow).toList());
  }

  Future<ProductModel?> getProductById(String id) async {
    final row = await _dao.getProductById(id);
    return row != null ? _productFromRow(row) : null;
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    final companions = products.map(_productToCompanion).toList();
    await _dao.upsertProducts(companions);
  }

  Future<void> upsertProduct(ProductModel product) async {
    await _dao.upsertProduct(_productToCompanion(product));
  }

  Future<void> deleteProduct(String id) => _dao.deleteProduct(id);

  Future<void> clearProducts() => _dao.clearProducts();

  // ─── Default Ingredients ───
  Future<List<DefaultIngredientModel>> getIngredients(String productId) async {
    final rows = await _dao.getIngredientsByProduct(productId);
    return rows.map(_ingredientFromRow).toList();
  }

  Stream<List<DefaultIngredientModel>> watchIngredients(String productId) {
    return _dao
        .watchIngredientsByProduct(productId)
        .map((rows) => rows.map(_ingredientFromRow).toList());
  }

  Future<void> cacheIngredients(
    String productId,
    List<DefaultIngredientModel> ingredients,
  ) async {
    await _dao.clearIngredientsByProduct(productId);
    final companions = ingredients.map(_ingredientToCompanion).toList();
    await _dao.upsertIngredients(companions);
  }

  // ─── Addon Toppings ───
  Future<List<AddonToppingModel>> getToppings(String productId) async {
    final rows = await _dao.getToppingsByProduct(productId);
    return rows.map(_toppingFromRow).toList();
  }

  Stream<List<AddonToppingModel>> watchToppings(String productId) {
    return _dao
        .watchToppingsByProduct(productId)
        .map((rows) => rows.map(_toppingFromRow).toList());
  }

  Future<void> cacheToppings(
    String productId,
    List<AddonToppingModel> toppings,
  ) async {
    await _dao.clearToppingsByProduct(productId);
    final companions = toppings.map(_toppingToCompanion).toList();
    await _dao.upsertToppings(companions);
  }

  // ─── Mappers ───
  CategoryModel _categoryFromRow(CategoriesTableData row) {
    return CategoryModel(
      id: row.id,
      name: row.name,
      nameEn: row.nameEn,
      icon: row.icon,
      sortOrder: row.sortOrder,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  CategoriesTableCompanion _categoryToCompanion(CategoryModel model) {
    return CategoriesTableCompanion(
      id: Value(model.id),
      name: Value(model.name),
      nameEn: Value(model.nameEn),
      icon: Value(model.icon),
      sortOrder: Value(model.sortOrder),
      isActive: Value(model.isActive),
      createdAt: Value(model.createdAt ?? DateTime.now()),
      updatedAt: Value(model.updatedAt ?? DateTime.now()),
    );
  }

  ProductModel _productFromRow(ProductsTableData row) {
    return ProductModel(
      id: row.id,
      name: row.name,
      nameEn: row.nameEn,
      description: row.description,
      basePrice: row.basePrice,
      categoryId: row.categoryId,
      imageUrl: row.imageUrl,
      isAvailable: row.isAvailable,
      stockQty: row.stockQty,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  ProductsTableCompanion _productToCompanion(ProductModel model) {
    return ProductsTableCompanion(
      id: Value(model.id),
      name: Value(model.name),
      nameEn: Value(model.nameEn),
      description: Value(model.description),
      basePrice: Value(model.basePrice),
      categoryId: Value(model.categoryId),
      imageUrl: Value(model.imageUrl),
      isAvailable: Value(model.isAvailable),
      stockQty: Value(model.stockQty),
      createdAt: Value(model.createdAt ?? DateTime.now()),
      updatedAt: Value(model.updatedAt ?? DateTime.now()),
    );
  }

  DefaultIngredientModel _ingredientFromRow(DefaultIngredientsTableData row) {
    return DefaultIngredientModel(
      id: row.id,
      productId: row.productId,
      name: row.name,
      nameEn: row.nameEn,
      isRemovable: row.isRemovable,
      sortOrder: row.sortOrder,
    );
  }

  DefaultIngredientsTableCompanion _ingredientToCompanion(
    DefaultIngredientModel model,
  ) {
    return DefaultIngredientsTableCompanion(
      id: Value(model.id),
      productId: Value(model.productId),
      name: Value(model.name),
      nameEn: Value(model.nameEn),
      isRemovable: Value(model.isRemovable),
      sortOrder: Value(model.sortOrder),
    );
  }

  AddonToppingModel _toppingFromRow(AddonToppingsTableData row) {
    return AddonToppingModel(
      id: row.id,
      productId: row.productId,
      name: row.name,
      nameEn: row.nameEn,
      price: row.price,
      isAvailable: row.isAvailable,
      sortOrder: row.sortOrder,
    );
  }

  AddonToppingsTableCompanion _toppingToCompanion(AddonToppingModel model) {
    return AddonToppingsTableCompanion(
      id: Value(model.id),
      productId: Value(model.productId),
      name: Value(model.name),
      nameEn: Value(model.nameEn),
      price: Value(model.price),
      isAvailable: Value(model.isAvailable),
      sortOrder: Value(model.sortOrder),
    );
  }
}
