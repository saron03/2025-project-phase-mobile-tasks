import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/utils/api_service.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'product_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    dataSource = ProductRemoteDataSourceImpl(apiService: mockApiService);
  });

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
  final testProductList = [testProduct];
  final testProductListJson = {'products': [testProductJson]}; // Wrap in "products" key

  group('getAllProducts', () {
    test('should return List<ProductModel> when ApiService returns a valid map with products', () async {
      // Arrange
      when(mockApiService.get('products')).thenAnswer((_) async => testProductListJson);

      // Act
      final result = await dataSource.getAllProducts();

      // Assert
      verify(mockApiService.get('products'));
      expect(result, testProductList);
    });

    test('should throw ServerFailure when ApiService throws', () async {
      // Arrange
      when(mockApiService.get('products')).thenThrow(ServerFailure());

      // Act & Assert
      expect(() => dataSource.getAllProducts(), throwsA(isA<ServerFailure>()));
    });

    test('should throw ServerFailure when ApiService returns invalid data', () async {
      // Arrange
      when(mockApiService.get('products')).thenAnswer((_) async => {'invalid': 'data'});

      // Act & Assert
      expect(() => dataSource.getAllProducts(), throwsA(isA<ServerFailure>()));
    });
  });

  group('getProduct', () {
    test('should return ProductModel when ApiService returns data', () async {
      // Arrange
      when(mockApiService.get('products/1')).thenAnswer((_) async => testProductJson);

      // Act
      final result = await dataSource.getProduct('1');

      // Assert
      verify(mockApiService.get('products/1'));
      expect(result, testProduct);
    });

    test('should throw ServerFailure when ApiService throws', () async {
      // Arrange
      when(mockApiService.get('products/1')).thenThrow(ServerFailure());

      // Act & Assert
      expect(() => dataSource.getProduct('1'), throwsA(isA<ServerFailure>()));
    });

    test('should throw ServerFailure when id is null', () async {
      // Act & Assert
      expect(() => dataSource.getProduct(null), throwsA(isA<ServerFailure>()));
    });
  });

  group('insertProduct', () {
    test('should return ProductModel when ApiService returns data', () async {
      // Arrange
      when(mockApiService.post('products', testProductJson))
          .thenAnswer((_) async => testProductJson);

      // Act
      final result = await dataSource.insertProduct(testProduct);

      // Assert
      verify(mockApiService.post('products', testProductJson));
      expect(result, testProduct);
    });

    test('should throw ServerFailure when ApiService throws', () async {
      // Arrange
      when(mockApiService.post('products', testProductJson)).thenThrow(ServerFailure());

      // Act & Assert
      expect(() => dataSource.insertProduct(testProduct), throwsA(isA<ServerFailure>()));
    });
  });

  group('updateProduct', () {
    test('should return Unit when ApiService succeeds', () async {
      // Arrange
      when(mockApiService.put('products/1', testProductJson))
          .thenAnswer((_) async => {});

      // Act
      final result = await dataSource.updateProduct(testProduct);

      // Assert
      verify(mockApiService.put('products/1', testProductJson));
      expect(result, unit);
    });

    test('should throw ServerFailure when ApiService throws', () async {
      // Arrange
      when(mockApiService.put('products/1', testProductJson)).thenThrow(ServerFailure());

      // Act & Assert
      expect(() => dataSource.updateProduct(testProduct), throwsA(isA<ServerFailure>()));
    });
  });

  group('deleteProduct', () {
    test('should return Unit when ApiService succeeds', () async {
      // Arrange
      when(mockApiService.delete('products/1')).thenAnswer((_) async => {});

      // Act
      final result = await dataSource.deleteProduct('1');

      // Assert
      verify(mockApiService.delete('products/1'));
      expect(result, unit);
    });

    test('should throw ServerFailure when ApiService throws', () async {
      // Arrange
      when(mockApiService.delete('products/1')).thenThrow(ServerFailure());

      // Act & Assert
      expect(() => dataSource.deleteProduct('1'), throwsA(isA<ServerFailure>()));
    });
  });
}