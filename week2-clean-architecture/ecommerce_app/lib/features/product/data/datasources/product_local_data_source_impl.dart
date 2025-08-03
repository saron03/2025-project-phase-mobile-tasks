import 'dart:convert';
import 'package:collection/collection.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../models/product_model.dart';
import 'product_local_data_dource.dart';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String productsKey = 'CACHED_PRODUCTS';

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final List<String> productsJson =
        products.map((product) => json.encode(product.toJson())).toList();
    await sharedPreferences.setStringList(productsKey, productsJson);
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final List<String>? productsJson = sharedPreferences.getStringList(productsKey);
    if (productsJson != null) {
      return productsJson
          .map((jsonString) => ProductModel.fromJson(json.decode(jsonString)))
          .toList();
    }
    throw CacheFailure();
  }

  @override
  Future<ProductModel?> getCachedProduct(String id) async {
    final List<String>? productsJson = sharedPreferences.getStringList(productsKey);
    if (productsJson != null) {
      final products = productsJson
          .map((jsonString) => ProductModel.fromJson(json.decode(jsonString)))
          .toList();
      return products.firstWhereOrNull((product) => product.id == id);
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(productsKey);
  }
}