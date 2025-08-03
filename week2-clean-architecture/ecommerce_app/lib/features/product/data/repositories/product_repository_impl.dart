// ignore: depend_on_referenced_packages
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/netwrok_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_dource.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Product>> getProduct(String? id) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProduct = await remoteDataSource.getProduct(id);
        // Cache the fetched product
        await localDataSource.cacheProducts([remoteProduct as ProductModel]);
        return Right(remoteProduct);
      } else {
        final cachedProduct = await localDataSource.getCachedProduct(id!);
        if (cachedProduct != null) {
          return Right(cachedProduct);
        } else {
          return Left(CacheFailure());
        }
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> insertProduct(Product product) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProduct = await remoteDataSource.insertProduct(product);
        // Cache the inserted product
        await localDataSource.cacheProducts([remoteProduct as ProductModel]);
        return Right(remoteProduct);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(Product product) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.updateProduct(product);
        // Update the cache
        await localDataSource.cacheProducts([product as ProductModel]);
        return Right(result);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.deleteProduct(id);
        // Optionally clear cache for this product
        await localDataSource.clearCache();
        return Right(result);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
