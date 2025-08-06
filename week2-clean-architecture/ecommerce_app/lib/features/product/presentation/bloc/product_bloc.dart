// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/insert_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final InsertProduct insertProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final GetProduct getProduct;
  final GetAllProducts getAllProducts;
  final InputConverter inputConverter;

  ProductBloc({
    required this.insertProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getProduct,
    required this.getAllProducts,
    required this.inputConverter,
  }) : super(IntialState()) {
    on<LoadAllProductEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<InsertProductEvent>(_onInsertProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
    LoadAllProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await getAllProducts();
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (products) => emit(LoadedAllProductsState(products)),
      );
    } catch (_) {
      emit(const ErrorState('Failed to load products'));
    }
  }
  
  Future<void> _onGetSingleProduct(
    GetSingleProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    
    final eitherId = inputConverter.stringToUnsignedInteger(event.id);
    
    await eitherId.fold(
      (failure) async => emit(const ErrorState('Invalid ID')),  
      (id) async {
        final result = await getProduct(id.toString());
        result.fold(
          (failure) => emit(ErrorState(failure.message)),
          (product) => emit(LoadedSingleProductState(product)),
        );
      },
    );
  }

  Future<void> _onInsertProduct(
    InsertProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await insertProduct(event.product);
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    } catch (_) {
      emit(const ErrorState('Failed to insert product'));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await updateProduct(event.product);
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    } catch (_) {
      emit(const ErrorState('Failed to update product'));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(LoadingState());
    try {
      final result = await deleteProduct(event.id);
      result.fold(
        (failure) => emit(ErrorState(failure.message)),
        (_) => emit(ProductOperationSuccess()),
      );
    } catch (_) {
      emit(const ErrorState('Failed to delete product'));
    }
  }
}