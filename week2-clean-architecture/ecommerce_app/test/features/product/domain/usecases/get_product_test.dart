import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_test.mocks.dart';

// Tell Mockito to generate a mock for ProductRepository
@GenerateMocks([ProductRepository])
void main() {
  late GetProduct usecase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    usecase = GetProduct(mockRepository);
  });

  const testId = '123';
  const testProduct = Product(
    id: testId,
    name: 'Test Product',
    description: 'A test product description',
    price: 99.99,
    imageUrl: 'https://example.com/image.jpg',
  );

  group('GetProduct', () {
    test('should get product from repository when successful', () async {
      // Arrange
      when(mockRepository.getProduct(any))
          .thenAnswer((_) async => const Right(testProduct));

      // Act
      final result = await usecase(testId);

      // Assert
      expect(result, const Right(testProduct));
      verify(mockRepository.getProduct(testId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails with ServerFailure', () async {
      // Arrange
      when(mockRepository.getProduct(any))
          .thenAnswer((_) async => const Left(ServerFailure()));

      // Act
      final result = await usecase(testId);

      // Assert
      expect(result, const Left(ServerFailure()));
      verify(mockRepository.getProduct(testId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when repository fails with CacheFailure', () async {
      // Arrange
      when(mockRepository.getProduct(any))
          .thenAnswer((_) async => const Left(CacheFailure()));

      // Act
      final result = await usecase(testId);

      // Assert
      expect(result, const Left(CacheFailure()));
      verify(mockRepository.getProduct(testId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}