import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../datasources/catalog_remote_datasource.dart';
import '../datasources/catalog_local_datasource.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/default_ingredient_model.dart';
import '../models/addon_topping_model.dart';

class CatalogRepository {
  final CatalogRemoteDataSource _remote;
  final CatalogLocalDataSource _local;
  final Connectivity _connectivity;

  CatalogRepository({
    required this._remote,
    required this._local,
    required this._connectivity,
  });

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  // ─── Categories ───
  Future<List<CategoryModel>> getCategories() async {
    try {
      if (await _isOnline) {
        final categories = await _remote.getCategories();
        await _local.cacheCategories(categories);
        return categories;
      }
    } catch (_) {
      // Fall through to local
    }
    return _local.getCategories();
  }

  Stream<List<CategoryModel>> watchCategories() {
    // Trigger a remote refresh in the background
    getCategories();
    return _local.watchCategories();
  }

  // ─── Products ───
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      if (await _isOnline) {
        final products = await _remote.getProducts(categoryId: categoryId);
        await _local.cacheProducts(products);
        return products;
      }
    } catch (_) {
      // Fall through to local
    }
    return _local.getProducts(categoryId: categoryId);
  }

  Stream<List<ProductModel>> watchProducts({String? categoryId}) {
    // Trigger a remote refresh in the background
    getProducts(categoryId: categoryId);
    return _local.watchProducts(categoryId: categoryId);
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      if (await _isOnline) {
        final product = await _remote.getProductById(id);
        await _local.upsertProduct(product);
        return product;
      }
    } catch (_) {
      // Fall through to local
    }
    return _local.getProductById(id);
  }

  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    final product = await _remote.insertProduct(data);
    await _local.upsertProduct(product);
    return product;
  }

  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    final product = await _remote.updateProduct(id, data);
    await _local.upsertProduct(product);
    return product;
  }

  Future<void> deleteProduct(String id) async {
    await _remote.deleteProduct(id);
    await _local.deleteProduct(id);
  }

  // ─── Product Image ───
  Future<String> uploadProductImage(String fileName, File imageFile) async {
    return _remote.uploadProductImage(fileName, imageFile);
  }

  // ─── Default Ingredients ───
  Future<List<DefaultIngredientModel>> getIngredients(String productId) async {
    try {
      if (await _isOnline) {
        final ingredients = await _remote.getIngredients(productId);
        await _local.cacheIngredients(productId, ingredients);
        return ingredients;
      }
    } catch (_) {
      // Fall through to local
    }
    return _local.getIngredients(productId);
  }

  Stream<List<DefaultIngredientModel>> watchIngredients(String productId) {
    getIngredients(productId);
    return _local.watchIngredients(productId);
  }

  Future<DefaultIngredientModel> createIngredient(
    Map<String, dynamic> data,
  ) async {
    return _remote.insertIngredient(data);
  }

  Future<DefaultIngredientModel> updateIngredient(
    String id,
    Map<String, dynamic> data,
  ) async {
    return _remote.updateIngredient(id, data);
  }

  Future<void> deleteIngredient(String id) async {
    await _remote.deleteIngredient(id);
  }

  // ─── Addon Toppings ───
  Future<List<AddonToppingModel>> getToppings(String productId) async {
    try {
      if (await _isOnline) {
        final toppings = await _remote.getToppings(productId);
        await _local.cacheToppings(productId, toppings);
        return toppings;
      }
    } catch (_) {
      // Fall through to local
    }
    return _local.getToppings(productId);
  }

  Stream<List<AddonToppingModel>> watchToppings(String productId) {
    getToppings(productId);
    return _local.watchToppings(productId);
  }

  Future<AddonToppingModel> createTopping(Map<String, dynamic> data) async {
    return _remote.insertTopping(data);
  }

  Future<AddonToppingModel> updateTopping(
    String id,
    Map<String, dynamic> data,
  ) async {
    return _remote.updateTopping(id, data);
  }

  Future<void> deleteTopping(String id) async {
    await _remote.deleteTopping(id);
  }
}
