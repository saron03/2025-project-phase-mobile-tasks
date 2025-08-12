import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.chatId,
    required super.content,
    required super.type,
    super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chatId'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': (sender as UserModel).toJson(),
      'chatId': chatId,
      'content': content,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
