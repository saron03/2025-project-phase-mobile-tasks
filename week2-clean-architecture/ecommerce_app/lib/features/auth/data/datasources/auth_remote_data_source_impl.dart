import '../../../../core/utils/auth_api_service.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> login(String email, String password) async {
    final json = await apiService.login(email: email, password: password);
    return UserModel.fromJson(json['data']['user']);
  }

  @override
  Future<UserModel> signUp(String name, String email, String password, String id) async {
    final json = await apiService.register(
      name: name,
      email: email,
      password: password,
      id: id,
    );
    return UserModel.fromJson(json['data']['user']);
  }

  @override
  Future<void> logout() async {
    // If API supports logout, add here. Otherwise, clear tokens locally.
    return;
  }
}

