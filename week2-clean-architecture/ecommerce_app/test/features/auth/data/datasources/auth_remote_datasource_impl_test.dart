import 'package:ecommerce_app/core/utils/auth_api_service.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([AuthApiService])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockAuthApiService mockApiService;

  setUp(() {
    mockApiService = MockAuthApiService();
    dataSource = AuthRemoteDataSourceImpl(apiService: mockApiService);
  });

  final tUserJson = {
    'id': '1',
    'name': 'Test User',
    'email': 'test@example.com',
  };

  group('login', () {
    test('should return UserModel on successful login', () async {
      when(mockApiService.login(email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => {
                'data': {
                  'user': tUserJson,
                },
              });

      final result = await dataSource.login('test@example.com', '123456');

      expect(result, isA<UserModel>());
      expect(result.name, 'Test User');
    });
  });

  group('signUp', () {
    test('should return UserModel on successful sign up', () async {
      when(mockApiService.register(
              name: anyNamed('name'),
              email: anyNamed('email'),
              password: anyNamed('password'),))
          .thenAnswer((_) async => {
                'data': {
                  'user': tUserJson,
                },
              });

      final result = await dataSource.signUp('Test User', 'test@example.com', '123456');

      expect(result, isA<UserModel>());
      expect(result.email, 'test@example.com');
    });
  });
}
