import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
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
    try {
      final List<String> productsJson =
          products.map((product) => json.encode(product.toJson())).toList();
      await sharedPreferences.setStringList(productsKey, productsJson);
    } catch (e) {
      throw const CacheFailure();
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final List<String>? productsJson = sharedPreferences.getStringList(productsKey);
      if (productsJson != null) {
        return productsJson
            .map((jsonString) => ProductModel.fromJson(json.decode(jsonString)))
            .toList();
      }
      throw const CacheFailure();
    } catch (e) {
      throw const CacheFailure();
    }
  }

  @override
  Future<ProductModel?> getCachedProduct(String id) async {
    try {
      final List<String>? productsJson = sharedPreferences.getStringList(productsKey);
      if (productsJson != null) {
        final products = productsJson
            .map((jsonString) => ProductModel.fromJson(json.decode(jsonString)))
            .toList();
        return products.firstWhereOrNull((product) => product.id == id);
      }
      return null;
    } catch (e) {
      throw const CacheFailure();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(productsKey);
    } catch (e) {
      throw const CacheFailure();
    }
  }
}