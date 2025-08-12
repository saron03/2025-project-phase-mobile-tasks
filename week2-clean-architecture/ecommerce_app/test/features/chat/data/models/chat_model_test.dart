import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:ecommerce_app/features/chat/data/models/message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dummyUserJson = {
    'id': 'user1',
    'name': 'Alice',
    'email': 'alice@example.com',
  };
  final dummyUserModel = UserModel.fromJson(dummyUserJson);

  final dummyMessageJson = {
    'id': 'msg1',
    'sender': dummyUserJson,
    'chatId': 'chat1',
    'content': 'Hello',
    'type': 'text',
    'createdAt': '2025-08-11T12:00:00.000Z',
  };
  final dummyMessageModel = MessageModel.fromJson(dummyMessageJson);

  final chatJson = {
    'id': 'chat1',
    'user1': dummyUserJson,
    'user2': dummyUserJson,
    'lastMessage': dummyMessageJson,
    'updatedAt': '2025-08-11T13:00:00Z', // Fixed typo
  };

  group('ChatModel', () {
    test('fromJson returns valid ChatModel object', () {
      final chat = ChatModel.fromJson(chatJson);

      expect(chat.id, 'chat1');
      expect(chat.user1, dummyUserModel);
      expect(chat.user2, dummyUserModel);
      expect(chat.lastMessage, dummyMessageModel);
      expect(chat.updatedAt, DateTime.parse('2025-08-11T13:00:00Z'));
    });

    test('toJson returns valid map', () {
      final chat = ChatModel.fromJson(chatJson);
      final json = chat.toJson();

      expect(json['id'], 'chat1');
      expect(json['user1'], dummyUserJson);
      expect(json['user2'], dummyUserJson);
      expect(json['lastMessage'], dummyMessageJson);
      expect(json['updatedAt'], '2025-08-11T13:00:00.000Z');
    });

    test('fromJson throws when required fields are missing', () {
      final invalidJson = {
        'user1': dummyUserJson,
        'user2': dummyUserJson,
      };

      expect(() => ChatModel.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });
  });
}