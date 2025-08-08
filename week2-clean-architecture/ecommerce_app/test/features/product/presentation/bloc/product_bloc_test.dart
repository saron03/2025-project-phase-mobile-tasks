import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_all_products.dart';
import 'package:ecommerce_app/features/product/domain/usecases/get_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/insert_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'product_bloc_test.mocks.dart';

@GenerateMocks([InsertProduct, UpdateProduct, DeleteProduct, GetProduct, GetAllProducts, InputConverter])
void main() {
  late ProductBloc bloc;
  late MockInsertProduct mockInsertProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late MockGetProduct mockGetProduct;
  late MockGetAllProducts mockGetAllProducts;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInsertProduct = MockInsertProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();
    mockGetProduct = MockGetProduct();
    mockGetAllProducts = MockGetAllProducts();
    mockInputConverter = MockInputConverter();

    bloc = ProductBloc(
      insertProduct: mockInsertProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
      getProduct: mockGetProduct,
      getAllProducts: mockGetAllProducts,
      inputConverter: mockInputConverter,
    );
  });

  const testProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'desc',
    price: 100.0,
    imageUrl: 'test.png',
  );
  final testProducts = [testProduct];
  const testId = '1';
  const invalidId = 'invalid';

  group('ProductBloc', () {
    test('initial state should be IntialState', () {
      // Assert
      expect(bloc.state, equals(IntialState()));
    });

    group('LoadAllProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, LoadedAllProductsState] when getAllProducts succeeds',
        build: () {
          when(mockGetAllProducts()).thenAnswer((_) async => Right(testProducts));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductEvent()),
        expect: () => [
          LoadingState(),
          LoadedAllProductsState(testProducts),
        ],
        verify: (_) {
          verify(mockGetAllProducts()).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when getAllProducts fails',
        build: () {
          when(mockGetAllProducts()).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadAllProductEvent()),
        expect: () => [
          LoadingState(),
          ErrorState(const ServerFailure().message),
        ],
        verify: (_) {
          verify(mockGetAllProducts()).called(1);
        },
      );
    });

    group('GetSingleProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, LoadedSingleProductState] when getProduct succeeds',
        build: () {
          when(mockInputConverter.stringToUnsignedInteger(testId))
              .thenReturn(const Right(1));
          when(mockGetProduct(any)).thenAnswer((_) async => const Right(testProduct));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(testId)),
        expect: () => [
          LoadingState(),
          const LoadedSingleProductState(testProduct),
        ],
        verify: (_) {
          verify(mockInputConverter.stringToUnsignedInteger(testId)).called(1);
          verify(mockGetProduct(testId)).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when inputConverter fails',
        build: () {
          when(mockInputConverter.stringToUnsignedInteger(invalidId))
              .thenReturn(const Left(InvalidInputFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(invalidId)),
        expect: () => [
          LoadingState(),
          const ErrorState('Invalid ID'),
        ],
        verify: (_) {
          verify(mockInputConverter.stringToUnsignedInteger(invalidId)).called(1);
          verifyNever(mockGetProduct(any));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when getProduct fails',
        build: () {
          when(mockInputConverter.stringToUnsignedInteger(testId))
              .thenReturn(const Right(1));
          when(mockGetProduct(any)).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const GetSingleProductEvent(testId)),
        expect: () => [
          LoadingState(),
          ErrorState(const ServerFailure().message),
        ],
        verify: (_) {
          verify(mockInputConverter.stringToUnsignedInteger(testId)).called(1);
          verify(mockGetProduct(testId)).called(1);
        },
      );
    });

    group('InsertProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ProductOperationSuccess] when insertProduct succeeds',
        build: () {
          when(mockInsertProduct(any)).thenAnswer((_) async => const Right(testProduct));
          return bloc;
        },
        act: (bloc) => bloc.add(const InsertProductEvent(testProduct)),
        expect: () => [
          LoadingState(),
          ProductOperationSuccess(),
        ],
        verify: (_) {
          verify(mockInsertProduct(testProduct)).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when insertProduct fails',
        build: () {
          when(mockInsertProduct(any)).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const InsertProductEvent(testProduct)),
        expect: () => [
          LoadingState(),
          ErrorState(const ServerFailure().message),
        ],
        verify: (_) {
          verify(mockInsertProduct(testProduct)).called(1);
        },
      );
    });

    group('UpdateProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ProductOperationSuccess] when updateProduct succeeds',
        build: () {
          when(mockUpdateProduct(any)).thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
        expect: () => [
          LoadingState(),
          ProductOperationSuccess(),
        ],
        verify: (_) {
          verify(mockUpdateProduct(testProduct)).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when updateProduct fails',
        build: () {
          when(mockUpdateProduct(any)).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
        expect: () => [
          LoadingState(),
          ErrorState(const ServerFailure().message),
        ],
        verify: (_) {
          verify(mockUpdateProduct(testProduct)).called(1);
        },
      );
    });

    group('DeleteProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ProductOperationSuccess] when deleteProduct succeeds',
        build: () {
          when(mockDeleteProduct(any)).thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(testId)),
        expect: () => [
          LoadingState(),
          ProductOperationSuccess(),
        ],
        verify: (_) {
          verify(mockDeleteProduct(testId)).called(1);
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [LoadingState, ErrorState] when deleteProduct fails',
        build: () {
          when(mockDeleteProduct(any)).thenAnswer((_) async => const Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent(testId)),
        expect: () => [
          LoadingState(),
          ErrorState(const ServerFailure().message),
        ],
        verify: (_) {
          verify(mockDeleteProduct(testId)).called(1);
        },
      );
    });
  });
}