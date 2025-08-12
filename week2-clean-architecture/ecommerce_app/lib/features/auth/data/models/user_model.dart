// user_model.dart

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required String super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // This is the corrected part.
    // It safely handles potential null values from the JSON response.
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String, // <-- The server should provide this token
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}