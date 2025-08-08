import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
    required String id,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
