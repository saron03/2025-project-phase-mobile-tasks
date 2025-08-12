import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
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

  group('MessageModel', () {
    test('fromJson returns valid MessageModel object', () {
      final message = MessageModel.fromJson(dummyMessageJson);

      expect(message.id, 'msg1');
      expect(message.sender, dummyUserModel);
      expect(message.chatId, 'chat1');
      expect(message.content, 'Hello');
      expect(message.type, 'text');
      expect(message.createdAt, DateTime.parse('2025-08-11T12:00:00.000Z'));
    });

    test('toJson returns valid map', () {
      final message = MessageModel.fromJson(dummyMessageJson);
      final json = message.toJson();

      expect(json['id'], 'msg1');
      expect(json['sender'], dummyUserJson);
      expect(json['chatId'], 'chat1');
      expect(json['content'], 'Hello');
      expect(json['type'], 'text');
      expect(json['createdAt'], '2025-08-11T12:00:00.000Z');
    });

    test('fromJson handles null createdAt', () {
      final jsonWithoutCreatedAt = {
        'id': 'msg1',
        'sender': dummyUserJson,
        'chatId': 'chat1',
        'content': 'Hello',
        'type': 'text',
      };

      final message = MessageModel.fromJson(jsonWithoutCreatedAt);

      expect(message.id, 'msg1');
      expect(message.sender, dummyUserModel);
      expect(message.chatId, 'chat1');
      expect(message.content, 'Hello');
      expect(message.type, 'text');
      expect(message.createdAt, isNull);
    });

    test('toJson handles null createdAt', () {
      final message = MessageModel(
        id: 'msg1',
        sender: dummyUserModel,
        chatId: 'chat1',
        content: 'Hello',
        type: 'text',
        createdAt: null,
      );

      final json = message.toJson();

      expect(json['id'], 'msg1');
      expect(json['sender'], dummyUserJson);
      expect(json['chatId'], 'chat1');
      expect(json['content'], 'Hello');
      expect(json['type'], 'text');
      expect(json['createdAt'], isNull);
    });

    test('fromJson throws when required fields are missing', () {
      final invalidJson = {
        'sender': dummyUserJson,
        'chatId': 'chat1',
        'content': 'Hello',
      };

      expect(() => MessageModel.fromJson(invalidJson), throwsA(isA<TypeError>()));
    });
  });
}