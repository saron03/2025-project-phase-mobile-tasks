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

  const testProduct = Product(
    id: '123',
    name: 'Test Product',
    description: 'A test product description',
    price: 99.99,
    imageUrl: 'https://example.com/image.jpg',
  );

  test('should get product from repository', () async {
    // Arrange
    when(mockRepository.getProduct(any))
        .thenAnswer((_) async => Right(testProduct));

    // Act
    final result = await usecase('123');

    // Assert
    expect(result, const Right(testProduct));
    verify(mockRepository.getProduct('123')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
