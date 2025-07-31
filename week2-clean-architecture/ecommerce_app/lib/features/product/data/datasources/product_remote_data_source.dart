
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<Product?> getProduct(String id);
}

// Example implementation using an API
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<void> insertProduct(Product product) async {
    // API call to create product
  }

  @override
  Future<void> updateProduct(Product product) async {
    // API call to update product
  }

  @override
  Future<void> deleteProduct(String id) async {
    // API call to delete product
  }

  @override
  Future<Product?> getProduct(String id) async {
    // API call to fetch product by id
    return null;
  }
}
