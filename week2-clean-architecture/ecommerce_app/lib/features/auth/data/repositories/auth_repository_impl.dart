import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source_impl.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final user = await remoteDataSource.login(email, password);
      // Ensure the saving of the token and user is awaited before returning.
      await localDataSource.saveToken(user.token!);
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  // ... (the rest of your methods are fine and can remain unchanged)
  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) return const Left(NetworkFailure());

    try {
      final user = await remoteDataSource.signUp(name, email, password);
      await localDataSource.saveToken(user.token!);
      await localDataSource.saveUser(user);
      return Right(user);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clear();
    await remoteDataSource.logout();
  }

  @override
  Future<String?> getAuthToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await localDataSource.getUser();
  }
}