import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/auth_api_service.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final responseData = await apiService.login(
        email: email,
        password: password,
      );
      final Map<String, dynamic> userData = responseData['data'];
      return UserModel.fromJson(userData);
    } catch (e) {
      debugPrint('Login API call error: $e');
      throw ServerException();
    }
  }
  // In your AuthRemoteDataSourceImpl.dart file

  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final responseData = await apiService.register(
        name: name,
        email: email,
        password: password,
      );
       debugPrint('response: $responseData');
      final Map<String, dynamic> userData = responseData['data'];

      // The sign-up response does not include a token.
      // We create a UserModel with the available data and an empty string for the token.
      return UserModel(
        id: userData['_id'] as String,
        name: userData['name'] as String,
        email: userData['email'] as String,
        token:
            '', // Safely handles the missing token by providing an empty string.
      );
    } catch (e) {
      debugPrint('Sign-up API call error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    // This is fine.
  }
}
