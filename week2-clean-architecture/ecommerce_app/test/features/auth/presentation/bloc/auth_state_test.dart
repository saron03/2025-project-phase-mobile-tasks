import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';


// Mock User class for testing
class MockUser extends Mock implements User {}

void main() {
  group('AuthState Tests', () {
    test('AuthInitial is an instance of AuthState', () {
      // Arrange
      final authInitial = AuthInitial();

      // Act & Assert
      expect(authInitial, isA<AuthState>());
    });

    test('AuthLoading is an instance of AuthState', () {
      // Arrange
      final authLoading = AuthLoading();

      // Act & Assert
      expect(authLoading, isA<AuthState>());
    });

    test('AuthAuthenticated is an instance of AuthState and holds a User', () {
      // Arrange
      final user = MockUser();
      when(() => user.id).thenReturn('1');
      when(() => user.name).thenReturn('Test User');
      when(() => user.email).thenReturn('test@example.com');
      final authAuthenticated = AuthAuthenticated(user);

      // Act & Assert
      expect(authAuthenticated, isA<AuthState>());
      expect(authAuthenticated.user, equals(user));
      expect(authAuthenticated.user.id, equals('1'));
      expect(authAuthenticated.user.name, equals('Test User'));
      expect(authAuthenticated.user.email, equals('test@example.com'));
    });

    test('AuthUnauthenticated is an instance of AuthState', () {
      // Arrange
      final authUnauthenticated = AuthUnauthenticated();

      // Act & Assert
      expect(authUnauthenticated, isA<AuthState>());
    });

    test('AuthError is an instance of AuthState and holds an error message', () {
      // Arrange
      const errorMessage = 'Authentication failed';
      final authError = AuthError(errorMessage);

      // Act & Assert
      expect(authError, isA<AuthState>());
      expect(authError.message, equals(errorMessage));
    });
  });
}
