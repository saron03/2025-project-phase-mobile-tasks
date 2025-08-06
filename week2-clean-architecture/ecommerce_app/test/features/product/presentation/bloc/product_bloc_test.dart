import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockInsertProduct extends Mock implements InsertProduct {}
class MockUpdateProduct extends Mock implements UpdateProduct {}
class MockDeleteProduct extends Mock implements DeleteProduct {}
class MockGetProduct extends Mock implements GetProduct {}
class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late ProductBloc bloc;
  late MockInsertProduct mockInsertProduct;
  late MockDeleteProduct mockDeleteProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockGetProduct mockGetProduct;
  late MockInputConverter mockInputConverter;

  // Dummy product for testing
  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test description',
    price: 10.0,
    imageUrl: 'test.png',
  );

  setUp(() {
    mockInsertProduct = MockInsertProduct();
    mockDeleteProduct = MockDeleteProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockGetProduct = MockGetProduct();
    mockInputConverter = MockInputConverter();

    bloc = ProductBloc(
      insertProduct: mockInsertProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
      getProduct: mockGetProduct,
      inputConverter: mockInputConverter,
    );
  });

  group('ProductBloc', () {
    test('initial state should be ProductInitial', () {
      expect(bloc.state, equals(ProductInitial()));
    });

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadSuccess] when InsertProductEvent is added and use case returns success',
      build: () {
        when(mockInsertProduct.call(testProduct))
            .thenAnswer((_) async => const Right(testProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(const InsertProductEvent(testProduct)),
      expect: () => [ProductLoading(), const ProductLoadSuccess(testProduct)],
      verify: (_) {
        verify(mockInsertProduct.call(testProduct)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductError] when InsertProductEvent is added and use case returns failure',
      build: () {
        when(mockInsertProduct.call(testProduct))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const InsertProductEvent(testProduct)),
      expect: () => [ProductLoading(), const ProductFailure('Server Failure')],
      verify: (_) {
        verify(mockInsertProduct.call(testProduct)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadSuccess] when UpdateProductEvent is added and use case returns success',
      build: () {
        when(mockUpdateProduct.call(testProduct))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
      expect: () => [ProductLoading(), const ProductLoadSuccess(null)],
      verify: (_) {
        verify(mockUpdateProduct.call(testProduct)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductFailure] when UpdateProductEvent is added and use case returns failure',
      build: () {
        when(mockUpdateProduct.call(testProduct))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
      expect: () => [ProductLoading(), const ProductFailure('Server Failure')],
      verify: (_) {
        verify(mockUpdateProduct.call(testProduct)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadSuccess] when DeleteProductEvent is added and use case returns success',
      build: () {
        when(mockDeleteProduct.call(testProduct.id))
            .thenAnswer((_) async => const Right(unit));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteProductEvent(testProduct.id)),
      expect: () => [ProductLoading(), const ProductLoadSuccess(null)],
      verify: (_) {
        verify(mockDeleteProduct.call(testProduct.id)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductFailure] when DeleteProductEvent is added and use case returns failure',
      build: () {
        when(mockDeleteProduct.call(testProduct.id))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteProductEvent(testProduct.id)),
      expect: () => [ProductLoading(), const ProductFailure('Server Failure')],
      verify: (_) {
        verify(mockDeleteProduct.call(testProduct.id)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
        'should call InputConverter to validate and convert the ID string when GetProductEvent is added',
        build: () {
            when(mockInputConverter.stringToUnsignedInteger(any))
                .thenReturn(const Right(1)); // Pretend it successfully converts "1" to int
            // ignore: cast_from_null_always_fails
            when(mockGetProduct.call(any as String))
                .thenAnswer((_) async => const Right(testProduct)); // Also fake a successful product fetch
            return bloc;
        },
        act: (bloc) => bloc.add(const GetProductEvent('1')), // Fire the event with a string ID
        wait: const Duration(milliseconds: 100), // Give it a moment
        verify: (_) {
            verify(mockInputConverter.stringToUnsignedInteger('1')).called(1); // Ensure InputConverter is called
        },
        expect: () => [
            ProductLoading(),
            const ProductLoadSuccess(testProduct),
        ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductLoadSuccess] when GetProductEvent is added and use case returns success',
      build: () {
        when(mockGetProduct.call(testProduct.id))
            .thenAnswer((_) async => const Right(testProduct));
        return bloc;
      },
      act: (bloc) => bloc.add(GetProductEvent(testProduct.id)),
      expect: () => [ProductLoading(), const ProductLoadSuccess(testProduct)],
      verify: (_) {
        verify(mockGetProduct.call(testProduct.id)).called(1);
      },
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductLoading, ProductFailure] when GetProductEvent is added and use case returns failure',
      build: () {
        when(mockGetProduct.call(testProduct.id))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetProductEvent(testProduct.id)),
      expect: () => [ProductLoading(), const ProductFailure('Server Failure')],
      verify: (_) {
        verify(mockGetProduct.call(testProduct.id)).called(1);
      },
    );
  });
}
