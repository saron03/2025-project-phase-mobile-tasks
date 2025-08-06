import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );
  final testProducts = [testProduct];

  group('ProductState', () {
    test('IntialState should have empty props', () {
      // Arrange
      final state = IntialState();

      // Act
      final props = state.props;

      // Assert
      expect(props, []);
    });

    test('LoadingState should have empty props', () {
      // Arrange
      final state = LoadingState();

      // Act
      final props = state.props;

      // Assert
      expect(props, []);
    });

    test('LoadedAllProductsState should have products in props', () {
      // Arrange
      final state = LoadedAllProductsState(testProducts);

      // Act
      final props = state.props;

      // Assert
      expect(props, [testProducts]);
      expect(state.products, testProducts);
    });

    test('LoadedAllProductsState should be equal for same products', () {
      // Arrange
      final state1 = LoadedAllProductsState(testProducts);
      final state2 = LoadedAllProductsState(testProducts);

      // Assert
      expect(state1, equals(state2));
    });

    test('LoadedSingleProductState should have product in props', () {
      // Arrange
      const state = LoadedSingleProductState(testProduct);

      // Act
      final props = state.props;

      // Assert
      expect(props, [testProduct]);
      expect(state.product, testProduct);
    });

    test('LoadedSingleProductState should be equal for same product', () {
      // Arrange
      const state1 = LoadedSingleProductState(testProduct);
      const state2 = LoadedSingleProductState(testProduct);

      // Assert
      expect(state1, equals(state2));
    });

    test('ProductOperationSuccess should have empty props', () {
      // Arrange
      final state = ProductOperationSuccess();

      // Act
      final props = state.props;

      // Assert
      expect(props, []);
    });

    test('ErrorState should have message in props', () {
      // Arrange
      const errorMessage = 'Test error';
      const state = ErrorState(errorMessage);

      // Act
      final props = state.props;

      // Assert
      expect(props, [errorMessage]);
      expect(state.message, errorMessage);
    });

    test('ErrorState should be equal for same message', () {
      // Arrange
      const errorMessage = 'Test error';
      const state1 = ErrorState(errorMessage);
      const state2 = ErrorState(errorMessage);

      // Assert
      expect(state1, equals(state2));
    });
  });
}