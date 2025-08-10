import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/auth_api_service.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

@override
Future<UserModel> login(String email, String password) async {
  final json = await apiService.login(email: email, password: password);
  final token = json['data']['access_token'];

  // Save token for later use
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);

  // Create a user model placeholder if backend does not send user info
  return UserModel(
    id: 'unknown',
    name: email.split('@')[0],  // Just use the email's first part as name
    email: email,
  );
}


  // Updated: Removed `id` param from signUp method
  @override
  Future<UserModel> signUp(String name, String email, String password) async {
    final json = await apiService.register(
      name: name,
      email: email,
      password: password,
    );
    // Updated here: changed json path from ['data']['user'] to ['data']
    return UserModel.fromJson(json['data']);
  }

  @override
  Future<void> logout() async {
    return;
  }
}
