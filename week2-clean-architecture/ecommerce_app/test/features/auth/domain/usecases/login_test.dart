import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/auth_repository_test.mocks.dart';

void main() {
  late Login login;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    login = Login(mockAuthRepository);
  });

  const user = User(id: '123', name: 'John', email: 'john@example.com');
  const email = 'john@example.com';
  const password = 'password123';

  test('should return User on successful login', () async {
    // Arrange
    when(mockAuthRepository.login(
      email: email,
      password: password,
    )).thenAnswer((_) async => const Right(user));

    // Act
    final result = await login(
      email: email,
      password: password,
    );

    // Assert
    expect(result, const Right(user));
    verify(mockAuthRepository.login(
      email: email,
      password: password,
    )).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
