import 'dart:convert';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'product_local_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  const String productsKey = 'CACHED_PRODUCTS';
  const testProduct = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );
  final testProducts = [testProduct];
  final testProductsJson = [
    json.encode(testProduct.toJson()),
  ];

  group('cacheProducts', () {
    test('should cache products in SharedPreferences', () async {
      // Arrange
      when(mockSharedPreferences.setStringList(productsKey, testProductsJson))
          .thenAnswer((_) async => true);

      // Act
      await dataSource.cacheProducts(testProducts);

      // Assert
      verify(mockSharedPreferences.setStringList(productsKey, testProductsJson));
    });
  });

  group('getCachedProducts', () {
    test('should return list of products when cache exists', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(productsKey))
          .thenReturn(testProductsJson);

      // Act
      final result = await dataSource.getCachedProducts();

      // Assert
      verify(mockSharedPreferences.getStringList(productsKey));
      expect(result, testProducts);
    });

    test('should throw CacheFailure when cache is empty', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(productsKey)).thenReturn(null);

      // Act & Assert
      expect(() => dataSource.getCachedProducts(), throwsA(isA<CacheFailure>()));
      verify(mockSharedPreferences.getStringList(productsKey));
    });
  });

  group('getCachedProduct', () {
    test('should return product when it exists in cache', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(productsKey))
          .thenReturn(testProductsJson);

      // Act
      final result = await dataSource.getCachedProduct('1');

      // Assert
      verify(mockSharedPreferences.getStringList(productsKey));
      expect(result, testProduct);
    });

    test('should return null when product is not in cache', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(productsKey))
          .thenReturn(testProductsJson);

      // Act
      final result = await dataSource.getCachedProduct('2');

      // Assert
      verify(mockSharedPreferences.getStringList(productsKey));
      expect(result, null);
    });

    test('should return null when cache is empty', () async {
      // Arrange
      when(mockSharedPreferences.getStringList(productsKey)).thenReturn(null);

      // Act
      final result = await dataSource.getCachedProduct('1');

      // Assert
      verify(mockSharedPreferences.getStringList(productsKey));
      expect(result, null);
    });
  });

  group('clearCache', () {
    test('should remove cached products from SharedPreferences', () async {
      // Arrange
      when(mockSharedPreferences.remove(productsKey)).thenAnswer((_) async => true);

      // Act
      await dataSource.clearCache();

      // Assert
      verify(mockSharedPreferences.remove(productsKey));
    });
  });
}