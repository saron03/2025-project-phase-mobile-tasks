import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const productModel = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'https://example.com/image.png',
  );

  final productJson = {
    'id': '1',
    'name': 'Test Product',
    'description': 'Test Description',
    'price': 99.99,
    'imageUrl': 'https://example.com/image.png',
  };

  test('should convert JSON to ProductModel correctly', () {
    final result = ProductModel.fromJson(productJson);
    expect(result, equals(productModel));
  });

  test('should convert ProductModel to JSON correctly', () {
    final result = productModel.toJson();
    expect(result, equals(productJson));
  });
}
