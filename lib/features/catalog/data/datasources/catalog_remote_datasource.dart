import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/default_ingredient_model.dart';
import '../models/addon_topping_model.dart';

class CatalogRemoteDataSource {
  final SupabaseClient _client;

  CatalogRemoteDataSource(this._client);

  // ─── Categories ───
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client
        .from('categories')
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return (response as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<CategoryModel> insertCategory(Map<String, dynamic> data) async {
    final response =
        await _client.from('categories').insert(data).select().single();
    return CategoryModel.fromJson(response);
  }

  Future<CategoryModel> updateCategory(
      String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('categories')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return CategoryModel.fromJson(response);
  }

  Future<void> deleteCategory(String id) async {
    await _client.from('categories').delete().eq('id', id);
  }

  // ─── Products ───
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    var query = _client.from('products').select();
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    final response = await query.order('name');
    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> getProductById(String id) async {
    final response =
        await _client.from('products').select().eq('id', id).single();
    return ProductModel.fromJson(response);
  }

  Future<ProductModel> insertProduct(Map<String, dynamic> data) async {
    final response =
        await _client.from('products').insert(data).select().single();
    return ProductModel.fromJson(response);
  }

  Future<ProductModel> updateProduct(
      String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('products')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return ProductModel.fromJson(response);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // ─── Default Ingredients ───
  Future<List<DefaultIngredientModel>> getIngredients(
      String productId) async {
    final response = await _client
        .from('default_ingredients')
        .select()
        .eq('product_id', productId)
        .order('sort_order');
    return (response as List)
        .map((e) => DefaultIngredientModel.fromJson(e))
        .toList();
  }

  Future<DefaultIngredientModel> insertIngredient(
      Map<String, dynamic> data) async {
    final response = await _client
        .from('default_ingredients')
        .insert(data)
        .select()
        .single();
    return DefaultIngredientModel.fromJson(response);
  }

  Future<DefaultIngredientModel> updateIngredient(
      String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('default_ingredients')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return DefaultIngredientModel.fromJson(response);
  }

  Future<void> deleteIngredient(String id) async {
    await _client.from('default_ingredients').delete().eq('id', id);
  }

  // ─── Addon Toppings ───
  Future<List<AddonToppingModel>> getToppings(String productId) async {
    final response = await _client
        .from('addon_toppings')
        .select()
        .eq('product_id', productId)
        .order('sort_order');
    return (response as List)
        .map((e) => AddonToppingModel.fromJson(e))
        .toList();
  }

  Future<AddonToppingModel> insertTopping(Map<String, dynamic> data) async {
    final response =
        await _client.from('addon_toppings').insert(data).select().single();
    return AddonToppingModel.fromJson(response);
  }

  Future<AddonToppingModel> updateTopping(
      String id, Map<String, dynamic> data) async {
    final response = await _client
        .from('addon_toppings')
        .update(data)
        .eq('id', id)
        .select()
        .single();
    return AddonToppingModel.fromJson(response);
  }

  Future<void> deleteTopping(String id) async {
    await _client.from('addon_toppings').delete().eq('id', id);
  }

  // ─── Image Upload ───
  Future<String> uploadProductImage(String fileName, File imageFile) async {
    final path = 'products/$fileName';
    await _client.storage.from('product-images').upload(
          path,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );
    final publicUrl =
        _client.storage.from('product-images').getPublicUrl(path);
    return publicUrl;
  }

  Future<void> deleteProductImage(String path) async {
    await _client.storage.from('product-images').remove([path]);
  }
}
