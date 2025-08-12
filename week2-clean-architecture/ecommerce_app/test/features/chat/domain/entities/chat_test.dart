import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Chat Entity', () {
    test('should create a valid Chat instance', () {
      final user1 = const User(id: '1', name: 'Alice', email: 'alice@example.com');
      final user2 = const User(id: '2', name: 'Bob', email: 'bob@example.com');

      final chat = Chat(
        id: 'chat1',
        user1: user1,
        user2: user2,
        lastMessage: Message(
          id: 'msg1',
          sender: user1,
          chatId: 'chat1',
          content: 'Hello Bob',
          type: 'text',
        ),
        updatedAt: DateTime.now(),
      );

      expect(chat.id, 'chat1');
      expect(chat.user1?.name, 'Alice');
      expect(chat.user2?.email, 'bob@example.com');
      expect(chat.lastMessage!.content, 'Hello Bob');
    });
  });
}
