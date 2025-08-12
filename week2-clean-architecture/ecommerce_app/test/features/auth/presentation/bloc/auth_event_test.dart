import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:test/test.dart';

void main() {
  group('AuthEvent Tests', () {
    test('LoginEvent is an instance of AuthEvent and holds correct properties', () {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final loginEvent = LoginEvent(email: email, password: password);

      // Act & Assert
      expect(loginEvent, isA<AuthEvent>());
      expect(loginEvent.email, equals(email));
      expect(loginEvent.password, equals(password));
    });

    test('SignUpEvent is an instance of AuthEvent and holds correct properties', () {
      // Arrange
      const name = 'Test User';
      const email = 'test@example.com';
      const password = 'password123';
      final signUpEvent = SignUpEvent(
        name: name,
        email: email,
        password: password,
      );

      // Act & Assert
      expect(signUpEvent, isA<AuthEvent>());
      expect(signUpEvent.name, equals(name));
      expect(signUpEvent.email, equals(email));
      expect(signUpEvent.password, equals(password));
    });

    test('LogoutEvent is an instance of AuthEvent', () {
      // Arrange
      final logoutEvent = LogoutEvent();

      // Act & Assert
      expect(logoutEvent, isA<AuthEvent>());
    });

    test('CheckAuthStatusEvent is an instance of AuthEvent', () {
      // Arrange
      final checkAuthStatusEvent = CheckAuthStatusEvent();

      // Act & Assert
      expect(checkAuthStatusEvent, isA<AuthEvent>());
    });
  });
}