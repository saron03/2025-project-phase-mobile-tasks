import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';

class Message extends Equatable{
  final String id;
  final User sender;
  final String chatId;
  final String content;
  final String type; // 'text' or maybe 'image' in the future
  final DateTime? createdAt; // optional, but useful for ordering

  const Message({
    required this.id,
    required this.sender,
    required this.chatId,
    required this.content,
    required this.type,
    this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, sender,chatId,content];
}
