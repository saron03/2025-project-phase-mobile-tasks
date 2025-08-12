import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';
import 'message_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.user1,
    required super.user2,
    super.lastMessage,
    super.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      user1: json['user1'] != null ? UserModel.fromJson(json['user1'] as Map<String, dynamic>) : null,
      user2: json['user2'] != null ? UserModel.fromJson(json['user2'] as Map<String, dynamic>) : null,
      lastMessage: json['lastMessage'] != null ? MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1': (user1 as UserModel?)?.toJson(),
      'user2': (user2 as UserModel?)?.toJson(),
      'lastMessage': (lastMessage as dynamic)?.toJson(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

}