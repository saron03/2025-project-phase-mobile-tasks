import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/platform/netwrok_info.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:ecommerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource, NetworkInfo])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tUser = const UserModel(
    id: '1',
    name: 'Test User',
    email: 'test@example.com',
  );

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = '123456';

    test('should return User when network is connected and login is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.login(tEmail, tPassword)).thenAnswer((_) async => tUser);

      // Act
      final result = await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, Right(tUser));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.login(tEmail, tPassword));
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return NetworkFailure when there is no network connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when an exception occurs', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.login(tEmail, tPassword)).thenThrow(Exception());

      // Act
      final result = await repository.login(email: tEmail, password: tPassword);

      // Assert
      expect(result, const Left(ServerFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.login(tEmail, tPassword));
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('signUp', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = '123456';

    test('should return User when network is connected and signUp is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.signUp(tName, tEmail, tPassword))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await repository.signUp(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, Right(tUser));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.signUp(tName, tEmail, tPassword));
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return NetworkFailure when there is no network connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.signUp(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, const Left(NetworkFailure()));
      verify(mockNetworkInfo.isConnected);
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when an exception occurs', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.signUp(tName, tEmail, tPassword)).thenThrow(Exception());

      // Act
      final result = await repository.signUp(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(result, const Left(ServerFailure()));
      verify(mockNetworkInfo.isConnected);
      verify(mockRemoteDataSource.signUp(tName, tEmail, tPassword));
      verifyNoMoreInteractions(mockNetworkInfo);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('logout', () {
    test('should call logout on remote data source and complete successfully', () async {
      // Arrange
      when(mockRemoteDataSource.logout()).thenAnswer((_) async => Future.value());

      // Act
      await repository.logout();

      // Assert
      verify(mockRemoteDataSource.logout());
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });

    test('should rethrow exception when logout fails', () async {
      // Arrange
      final tException = Exception('Logout failed');
      when(mockRemoteDataSource.logout()).thenThrow(tException);

      // Act & Assert
      expect(() => repository.logout(), throwsA(tException));
      verify(mockRemoteDataSource.logout());
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockNetworkInfo);
    });
  });
}