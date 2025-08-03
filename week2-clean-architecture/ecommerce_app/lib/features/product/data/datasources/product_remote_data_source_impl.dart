import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductModel> getProduct(String? id) async {
    if (id == null) {
      throw ServerFailure();
    }
    final response = await client.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProductModel.fromJson(json);
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<ProductModel> insertProduct(Product product) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode((product as ProductModel).toJson()),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      return ProductModel.fromJson(json);
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<Unit> updateProduct(Product product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode((product as ProductModel).toJson()),
    );

    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<Unit> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerFailure();
    }
  }
}