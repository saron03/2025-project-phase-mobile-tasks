import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clear();
}


class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String authTokenKey = 'authToken';
  static const String currentUserKey = 'currentUser';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(authTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(authTokenKey);
  }

  @override
  Future<void> saveUser(User user) async {
    final json = jsonEncode((user as UserModel).toJson());
    await sharedPreferences.setString(currentUserKey, json);
  }

  @override
  Future<User?> getUser() async {
    final jsonString = sharedPreferences.getString(currentUserKey);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserModel.fromJson(jsonMap);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove(authTokenKey);
    await sharedPreferences.remove(currentUserKey);
  }
}
