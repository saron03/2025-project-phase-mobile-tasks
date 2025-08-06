import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String? str) {
    try {
      final number = int.parse(str!);
      if (number < 0) throw const FormatException();
      return Right(number);
    } on FormatException {
      return const Left(InvalidInputFailure('Invalid input: must be a non-negative integer'));
    }
  }
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure([super.message = 'Invalid input']);
}
