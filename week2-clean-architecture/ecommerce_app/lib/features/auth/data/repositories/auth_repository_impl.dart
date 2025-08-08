import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/netwrok_info.dart'; 
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
    required String id,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.signUp(name, email, password, id);
        return Right(user);
      } else {
        return const Left(NetworkFailure());
      }
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<void> logout() async {
    // Typically no return, but you can add logic if needed.
    try {
      await remoteDataSource.logout();
    } catch (e) {
      // You may want to handle or log errors
      rethrow;
    }
  }
}
