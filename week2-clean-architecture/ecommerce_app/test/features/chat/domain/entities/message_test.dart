import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Entity', () {
    test('should create a valid Message instance', () {
      final sender = const User(id: '1', name: 'Alice', email: 'alice@example.com');

      final message = Message(
        id: 'msg1',
        sender: sender,
        chatId: 'chat1',
        content: 'Hello',
        type: 'text',
      );

      expect(message.id, 'msg1');
      expect(message.sender.name, 'Alice');
      expect(message.chatId, 'chat1');
      expect(message.type, 'text');
    });
  });
}
