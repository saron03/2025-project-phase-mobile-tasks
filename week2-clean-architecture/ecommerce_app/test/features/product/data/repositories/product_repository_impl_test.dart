import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/platform/netwrok_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_dource.dart' show ProductLocalDataSource;
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_impl_test.mocks.dart';

// Generate mocks using Mockito
@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const testId = '1';
  const testProduct = ProductModel(
    id: testId,
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );
  final testProductList = [testProduct];

  group('getAllProducts', () {
    test('fetches from remote and caches when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts()).thenAnswer((_) async => testProductList);
      when(mockLocalDataSource.cacheProducts(testProductList)).thenAnswer((_) async => unit);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getAllProducts());
      verify(mockLocalDataSource.cacheProducts(testProductList));
      expect(result, Right(testProductList));
    });

    test('fetches from cache when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts()).thenAnswer((_) async => testProductList);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getCachedProducts());
      verifyNever(mockRemoteDataSource.getAllProducts());
      expect(result, Right(testProductList));
    });

    test('returns CacheFailure if no cached products when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProducts()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getCachedProducts());
      verifyNever(mockRemoteDataSource.getAllProducts());
      expect(result, Left(CacheFailure()));
    });

    test('returns ServerFailure when remote data source throws', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProducts()).thenThrow(ServerFailure());

      // Act
      final result = await repository.getAllProducts();

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getAllProducts());
      expect(result, Left(ServerFailure()));
    });
  });

  group('getProduct', () {
    test('fetches from remote and caches when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getProduct(testId)).thenAnswer((_) async => testProduct);
      when(mockLocalDataSource.cacheProducts([testProduct])).thenAnswer((_) async => unit);

      // Act
      final result = await repository.getProduct(testId);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.getProduct(testId));
      verify(mockLocalDataSource.cacheProducts([testProduct]));
      expect(result, const Right(testProduct));
    });

    test('fetches from cache when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProduct(testId)).thenAnswer((_) async => testProduct);

      // Act
      final result = await repository.getProduct(testId);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getCachedProduct(testId));
      verifyNever(mockRemoteDataSource.getProduct(testId));
      expect(result, const Right(testProduct));
    });

    test('returns CacheFailure if no cached product when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getCachedProduct(testId)).thenAnswer((_) async => null);

      // Act
      final result = await repository.getProduct(testId);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockLocalDataSource.getCachedProduct(testId));
      verifyNever(mockRemoteDataSource.getProduct(testId));
      expect(result, Left(CacheFailure()));
    });
  });

  group('insertProduct', () {
    test('inserts via remote and caches when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.insertProduct(testProduct)).thenAnswer((_) async => testProduct);
      when(mockLocalDataSource.cacheProducts([testProduct])).thenAnswer((_) async => unit);

      // Act
      final result = await repository.insertProduct(testProduct);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.insertProduct(testProduct));
      verify(mockLocalDataSource.cacheProducts([testProduct]));
      expect(result, const Right(testProduct));
    });

    test('returns NetworkFailure when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.insertProduct(testProduct);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.insertProduct(testProduct));
      expect(result, Left(NetworkFailure()));
    });
  });

  group('updateProduct', () {
    test('updates via remote and caches when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct(testProduct)).thenAnswer((_) async => unit);
      when(mockLocalDataSource.cacheProducts([testProduct])).thenAnswer((_) async => unit);

      // Act
      final result = await repository.updateProduct(testProduct);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.updateProduct(testProduct));
      verify(mockLocalDataSource.cacheProducts([testProduct]));
      expect(result, const Right(unit));
    });

    test('returns NetworkFailure when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.updateProduct(testProduct);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.updateProduct(testProduct));
      expect(result, Left(NetworkFailure()));
    });
  });

  group('deleteProduct', () {
    test('deletes via remote and clears cache when online', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct(testId)).thenAnswer((_) async => unit);
      when(mockLocalDataSource.clearCache()).thenAnswer((_) async => unit);

      // Act
      final result = await repository.deleteProduct(testId);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.deleteProduct(testId));
      verify(mockLocalDataSource.clearCache());
      expect(result, const Right(unit));
    });

    test('returns NetworkFailure when offline', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteProduct(testId);

      // Assert
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockRemoteDataSource.deleteProduct(testId));
      expect(result, Left(NetworkFailure()));
    });
  });
}