import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object> get props => [];
}

// Initial state before any data is loaded
final class IntialState extends ProductState {}

// Loading state while fetching or processing data
final class LoadingState extends ProductState {}

// State when all products are successfully loaded
final class LoadedAllProductsState extends ProductState {
  final List<Product> products;
  const LoadedAllProductsState(this.products);
  @override
  List<Object> get props => [products];
}

// State when a single product is successfully loaded
final class LoadedSingleProductState extends ProductState {
  final Product product;
  const LoadedSingleProductState(this.product);
  @override
  List<Object> get props => [product];
}

// State when an operation (insert/update/delete) succeeds
final class ProductOperationSuccess extends ProductState {}

// Error state when something goes wrong
final class ErrorState extends ProductState {
  final String message;
  const ErrorState(this.message);
  @override
  List<Object> get props => [message];
}