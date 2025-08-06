import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object> get props => [];
}

// Event to load all products
class LoadAllProductEvent extends ProductEvent {
  const LoadAllProductEvent();
  @override
  List<Object> get props => [];
}

// Event to get a single product by ID
class GetSingleProductEvent extends ProductEvent {
  final String id;
  const GetSingleProductEvent(this.id);
  @override
  List<Object> get props => [id];
}

// Event to insert a new product
class InsertProductEvent extends ProductEvent {
  final Product product;
  const InsertProductEvent(this.product);
  @override
  List<Object> get props => [product];
}

// Event to update an existing product
class UpdateProductEvent extends ProductEvent {
  final Product product;
  const UpdateProductEvent(this.product);
  @override
  List<Object> get props => [product];
}

// Event to delete a product by ID
class DeleteProductEvent extends ProductEvent {
  final String id;
  const DeleteProductEvent(this.id);
  @override
  List<Object> get props => [id];
}