import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/utils/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        // Arrange
        final str = '123';

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a failure when the string is not an integer',
      () async {
        // Arrange
        final str = 'abc';

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, const Left(InvalidInputFailure('Invalid input: must be a non-negative integer')));
      },
    );

    test(
      'should return a failure when the string represents a negative integer',
      () async {
        // Arrange
        final str = '-123';

        // Act
        final result = inputConverter.stringToUnsignedInteger(str);

        // Assert
        expect(result, const Left(InvalidInputFailure('Invalid input: must be a non-negative integer')));
      },
    );
  });
}
