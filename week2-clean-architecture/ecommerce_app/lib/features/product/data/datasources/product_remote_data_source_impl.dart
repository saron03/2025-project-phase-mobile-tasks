import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/product_api_service.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ProductModel> getProduct(String? id) async {
    if (id == null) {
      throw const ServerFailure();
    }
    try {
      final json = await apiService.get('products/$id');
      return ProductModel.fromJson(json);
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await apiService.get('products');

      // If response is wrapped in a "products" key
      // ignore: unnecessary_type_check
      final jsonList = response is Map<String, dynamic> 
          ? response['products'] 
          : response;

      if (jsonList is List) {
        return jsonList.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw const ServerFailure();
      }
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<ProductModel> insertProduct(Product product) async {
    try {
      final json = await apiService.post('products', (product as ProductModel).toJson());
      return ProductModel.fromJson(json);
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<Unit> updateProduct(Product product) async {
    try {
      await apiService.put('products/${product.id}', (product as ProductModel).toJson());
      return unit;
    } catch (e) {
      throw const ServerFailure();
    }
  }

  @override
  Future<Unit> deleteProduct(String id) async {
    try {
      await apiService.delete('products/$id');
      return unit;
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
