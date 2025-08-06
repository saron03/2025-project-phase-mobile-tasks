import 'package:dartz/dartz.dart';

import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<Product> insertProduct(Product product);
  
  Future<Unit> updateProduct(Product product);
  Future<Unit> deleteProduct(String id);
  Future<Product> getProduct(String? id);
  Future<List<Product>> getAllProducts();
}