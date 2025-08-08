import 'package:ecommerce_app/features/auth/domain/usecases/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../repositories/auth_repository_test.mocks.dart';

void main() {
  late Logout logout;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logout = Logout(mockAuthRepository);
  });

  test('should call logout on repository', () async {
    // Arrange
    when(mockAuthRepository.logout()).thenAnswer((_) async => Future.value());

    // Act
    await logout();

    // Assert
    verify(mockAuthRepository.logout()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
