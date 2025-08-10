import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/login.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/logout.dart';
import 'package:ecommerce_app/features/auth/domain/usecases/signup.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Mock classes
class MockLogin extends Mock implements Login {}
class MockSignUp extends Mock implements SignUp {}
class MockLogout extends Mock implements Logout {}
class MockUser extends Mock implements User {}
class MockNetworkFailure extends Mock implements NetworkFailure {}
class MockServerFailure extends Mock implements ServerFailure {}

void main() {
  late AuthBloc authBloc;
  late MockLogin mockLogin;
  late MockSignUp mockSignUp;
  late MockLogout mockLogout;
  late MockUser mockUser;
  late MockNetworkFailure mockNetworkFailure;
  late MockServerFailure mockServerFailure;

  setUp(() {
    mockLogin = MockLogin();
    mockSignUp = MockSignUp();
    mockLogout = MockLogout();
    mockUser = MockUser();
    mockNetworkFailure = MockNetworkFailure();
    mockServerFailure = MockServerFailure();
    authBloc = AuthBloc(
      login: mockLogin,
      signUp: mockSignUp,
      logout: mockLogout,
    );

    // Register fallback values for Failure types
    registerFallbackValue(mockNetworkFailure);
    registerFallbackValue(mockServerFailure);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    group('LoginEvent', () {
      const email = 'test@example.com';
      const password = 'password123';

      test('emits [AuthLoading, AuthAuthenticated] when login is successful', () async {
        // Arrange
        when(() => mockUser.id).thenReturn('1');
        when(() => mockUser.name).thenReturn('Test User');
        when(() => mockUser.email).thenReturn(email);
        when(() => mockLogin(email: email, password: password))
            .thenAnswer((_) async => Right(mockUser));

        // Act
        authBloc.add(LoginEvent(email: email, password: password));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthAuthenticated>()
                .having((state) => state.user, 'user', mockUser),
          ]),
        );
      });

      test('emits [AuthLoading, AuthError] when login fails with NetworkFailure', () async {
        // Arrange
        when(() => mockLogin(email: email, password: password))
            .thenAnswer((_) async => Left(mockNetworkFailure));

        // Act
        authBloc.add(LoginEvent(email: email, password: password));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>()
                .having((state) => state.message, 'message', 'No internet connection. Please check your network.'),
          ]),
        );
      });

      test('emits [AuthLoading, AuthError] when login fails with ServerFailure', () async {
        // Arrange
        when(() => mockLogin(email: email, password: password))
            .thenAnswer((_) async => Left(mockServerFailure));

        // Act
        authBloc.add(LoginEvent(email: email, password: password));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>()
                .having((state) => state.message, 'message', 'Server error. Please try again later.'),
          ]),
        );
      });
    });

    group('SignUpEvent', () {
      const name = 'Test User';
      const email = 'test@example.com';
      const password = 'password123';
      const id = '1';

      test('emits [AuthLoading, AuthAuthenticated] when sign up is successful', () async {
        // Arrange
        when(() => mockUser.id).thenReturn(id);
        when(() => mockUser.name).thenReturn(name);
        when(() => mockUser.email).thenReturn(email);
        when(() => mockSignUp(name: name, email: email, password: password))
            .thenAnswer((_) async => Right(mockUser));

        // Act
        authBloc.add(SignUpEvent(name: name, email: email, password: password));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthAuthenticated>()
                .having((state) => state.user, 'user', mockUser),
          ]),
        );
      });

      test('emits [AuthLoading, AuthError] when sign up fails with NetworkFailure', () async {
        // Arrange
        when(() => mockSignUp(name: name, email: email, password: password))
            .thenAnswer((_) async => Left(mockNetworkFailure));

        // Act
        authBloc.add(SignUpEvent(name: name, email: email, password: password));

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>()
                .having((state) => state.message, 'message', 'No internet connection. Please check your network.'),
          ]),
        );
      });
    });

    group('LogoutEvent', () {
      test('emits [AuthLoading, AuthUnauthenticated] when logout is successful', () async {
        // Arrange
        when(() => mockLogout()).thenAnswer((_) async {});

        // Act
        authBloc.add(LogoutEvent());

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthUnauthenticated>(),
          ]),
        );
      });

      test('emits [AuthLoading, AuthError] when logout fails', () async {
        // Arrange
        when(() => mockLogout()).thenThrow(Exception('Logout failed'));

        // Act
        authBloc.add(LogoutEvent());

        // Assert
        await expectLater(
          authBloc.stream,
          emitsInOrder([
            isA<AuthLoading>(),
            isA<AuthError>()
                .having((state) => state.message, 'message', 'Logout failed. Please try again.'),
          ]),
        );
      });
    });

    group('CheckAuthStatusEvent', () {
      test('emits [AuthUnauthenticated] for CheckAuthStatusEvent', () async {
        // Act
        authBloc.add(CheckAuthStatusEvent());

        // Assert
        await expectLater(
          authBloc.stream,
          emits(isA<AuthUnauthenticated>()),
        );
      });
    });
  });
}