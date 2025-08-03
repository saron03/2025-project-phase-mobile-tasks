import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_remote_data_source_impl_test.mocks.dart';
@GenerateMocks([http.Client])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  const baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1/products';
  const testProduct = ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );
  final testProductJson = {
    'id': '1',
    'name': 'Test Product',
    'description': 'desc',
    'price': 100.0,
    'imageUrl': 'test.png',
  };

  group('getProduct', () {
    test('should return ProductModel when the response code is 200', () async {
      // Arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(testProductJson), 200));

      // Act
      final result = await dataSource.getProduct('1');

      // Assert
      verify(mockHttpClient.get(
        Uri.parse('$baseUrl/1'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, testProduct);
    });

    test('should throw ServerFailure when the response code is not 200', () async {
      // Arrange
      when(mockHttpClient.get(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() => dataSource.getProduct('1'), throwsA(isA<ServerFailure>()));
    });

    test('should throw ServerFailure when id is null', () async {
      // Act & Assert
      expect(() => dataSource.getProduct(null), throwsA(isA<ServerFailure>()));
    });
  });

  group('insertProduct', () {
    test('should return ProductModel when the response code is 201', () async {
      // Arrange
      when(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(testProductJson), 201));

      // Act
      final result = await dataSource.insertProduct(testProduct);

      // Assert
      verify(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testProductJson),
      ));
      expect(result, testProduct);
    });

    test('should throw ServerFailure when the response code is not 201', () async {
      // Arrange
      when(mockHttpClient.post(
        Uri.parse(baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Bad Request', 400));

      // Act & Assert
      expect(() => dataSource.insertProduct(testProduct), throwsA(isA<ServerFailure>()));
    });
  });

  group('updateProduct', () {
    test('should return Unit when the response code is 200', () async {
      // Arrange
      when(mockHttpClient.put(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 200));

      // Act
      final result = await dataSource.updateProduct(testProduct);

      // Assert
      verify(mockHttpClient.put(
        Uri.parse('$baseUrl/1'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(testProductJson),
      ));
      expect(result, unit);
    });

    test('should throw ServerFailure when the response code is not 200', () async {
      // Arrange
      when(mockHttpClient.put(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Bad Request', 400));

      // Act & Assert
      expect(() => dataSource.updateProduct(testProduct), throwsA(isA<ServerFailure>()));
    });
  });

  group('deleteProduct', () {
    test('should return Unit when the response code is 200', () async {
      // Arrange
      when(mockHttpClient.delete(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      // Act
      final result = await dataSource.deleteProduct('1');

      // Assert
      verify(mockHttpClient.delete(
        Uri.parse('$baseUrl/1'),
        headers: {'Content-Type': 'application/json'},
      ));
      expect(result, unit);
    });

    test('should throw ServerFailure when the response code is not 200', () async {
      // Arrange
      when(mockHttpClient.delete(
        Uri.parse('$baseUrl/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      // Act & Assert
      expect(() => dataSource.deleteProduct('1'), throwsA(isA<ServerFailure>()));
    });
  });
}