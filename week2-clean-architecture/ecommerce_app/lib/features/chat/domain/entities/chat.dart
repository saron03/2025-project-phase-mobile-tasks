import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import 'message.dart';

class Chat extends Equatable {
  final String id;
  final User? user1;
  final User? user2;
  final Message? lastMessage;
  final DateTime? updatedAt;

  const Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, user1, user2, lastMessage, updatedAt];
}
