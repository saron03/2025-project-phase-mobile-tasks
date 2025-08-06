import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );

  group('ProductEvent', () {
    test('LoadAllProductEvent should have empty props', () {
      // Arrange
      const event = LoadAllProductEvent();

      // Act
      final props = event.props;

      // Assert
      expect(props, []);
    });

    test('LoadAllProductEvent should be equal for same event', () {
      // Arrange
      const event1 = LoadAllProductEvent();
      const event2 = LoadAllProductEvent();

      // Assert
      expect(event1, equals(event2));
    });

    test('GetSingleProductEvent should have id in props', () {
      // Arrange
      const id = '1';
      const event = GetSingleProductEvent(id);

      // Act
      final props = event.props;

      // Assert
      expect(props, [id]);
      expect(event.id, id);
    });

    test('GetSingleProductEvent should be equal for same id', () {
      // Arrange
      const event1 = GetSingleProductEvent('1');
      const event2 = GetSingleProductEvent('1');

      // Assert
      expect(event1, equals(event2));
    });

    test('InsertProductEvent should have product in props', () {
      // Arrange
      const event = InsertProductEvent(testProduct);

      // Act
      final props = event.props;

      // Assert
      expect(props, [testProduct]);
      expect(event.product, testProduct);
    });

    test('InsertProductEvent should be equal for same product', () {
      // Arrange
      const event1 = InsertProductEvent(testProduct);
      const event2 = InsertProductEvent(testProduct);

      // Assert
      expect(event1, equals(event2));
    });

    test('UpdateProductEvent should have product in props', () {
      // Arrange
      const event = UpdateProductEvent(testProduct);

      // Act
      final props = event.props;

      // Assert
      expect(props, [testProduct]);
      expect(event.product, testProduct);
    });

    test('UpdateProductEvent should be equal for same product', () {
      // Arrange
      const event1 = UpdateProductEvent(testProduct);
      const event2 = UpdateProductEvent(testProduct);

      // Assert
      expect(event1, equals(event2));
    });

    test('DeleteProductEvent should have id in props', () {
      // Arrange
      const id = '1';
      const event = DeleteProductEvent(id);

      // Act
      final props = event.props;

      // Assert
      expect(props, [id]);
      expect(event.id, id);
    });

    test('DeleteProductEvent should be equal for same id', () {
      // Arrange
      const event1 = DeleteProductEvent('1');
      const event2 = DeleteProductEvent('1');

      // Assert
      expect(event1, equals(event2));
    });
  });
}