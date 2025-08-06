import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> insertProduct(Product product);
  Future<Either<Failure, Unit>> updateProduct(Product product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
  Future<Either<Failure, Product>> getProduct(String? id);
  Future<Either<Failure, List<Product>>> getAllProducts();
}
