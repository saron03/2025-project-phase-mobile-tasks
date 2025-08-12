import 'dart:convert';
import 'package:ecommerce_app/core/utils/chat_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
void main() {
  late ChatApiService chatApiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient((request) async => http.Response('', 404)); // Default response
    chatApiService = ChatApiService(client: mockClient);
  });

  tearDown(() {
    mockClient.close();
  });

  const baseUrl = 'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3';
  const authToken = 'test_token';
  const userId = 'user1';
  const chatId = 'chat1';

  group('ChatApiService', () {
    test('getChats returns list of chats on success', () async {
      // Arrange
      final mockResponse = [
        {
          '_id': 'chat1',
          'user1': {'_id': 'user1', 'name': 'Alice', 'email': 'alice@example.com'},
          'user2': {'_id': 'user2', 'name': 'Bob', 'email': 'bob@example.com'},
          'lastMessage': null,
          'updatedAt': '2025-08-11T13:00:00Z',
        },
      ];
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats?userId=$userId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response(jsonEncode(mockResponse), 200);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act
      final result = await chatApiService.getChats(userId, authToken);

      // Assert
      expect(result, equals(mockResponse));
      expect(result, isA<List<dynamic>>());
      expect(result[0]['_id'], 'chat1');
    });

    test('getChats throws exception on failure', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats?userId=$userId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response('Not Found', 404);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      expect(
        () => chatApiService.getChats(userId, authToken),
        throwsA(predicate((e) => e.toString().contains('Failed to fetch chats: 404'))),
      );
    });

    test('getChatById returns chat on success', () async {
      // Arrange
      final mockResponse = {
        '_id': 'chat1',
        'user1': {'_id': 'user1', 'name': 'Alice', 'email': 'alice@example.com'},
        'user2': {'_id': 'user2', 'name': 'Bob', 'email': 'bob@example.com'},
        'lastMessage': null,
        'updatedAt': '2025-08-11T13:00:00Z',
      };
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats/$chatId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response(jsonEncode(mockResponse), 200);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act
      final result = await chatApiService.getChatById(chatId, authToken);

      // Assert
      expect(result, equals(mockResponse));
      expect(result, isA<Map<String, dynamic>>());
      expect(result['_id'], 'chat1');
    });

    test('getChatById throws exception on failure', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats/$chatId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response('Not Found', 404);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      expect(
        () => chatApiService.getChatById(chatId, authToken),
        throwsA(predicate((e) => e.toString().contains('Failed to fetch chat: 404'))),
      );
    });

    test('getMessages returns list of messages on success', () async {
      // Arrange
      final mockResponse = [
        {
          '_id': 'msg1',
          'sender': {'_id': 'user1', 'name': 'Alice', 'email': 'alice@example.com'},
          'chat': {'_id': 'chat1'},
          'content': 'Hello',
          'type': 'text',
          'createdAt': '2025-08-11T12:00:00Z',
        },
      ];
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats/$chatId/messages' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response(jsonEncode(mockResponse), 200);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act
      final result = await chatApiService.getMessages(chatId, authToken);

      // Assert
      expect(result, equals(mockResponse));
      expect(result, isA<List<dynamic>>());
      expect(result[0]['_id'], 'msg1');
    });

    test('getMessages throws exception on failure', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'GET' &&
            request.url.toString() == '$baseUrl/chats/$chatId/messages' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response('Not Found', 404);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      expect(
        () => chatApiService.getMessages(chatId, authToken),
        throwsA(predicate((e) => e.toString().contains('Failed to fetch messages: 404'))),
      );
    });

    test('initiateChat returns new chat on success', () async {
      // Arrange
      final mockResponse = {
        '_id': 'chat1',
        'user1': {'_id': 'user1', 'name': 'Alice', 'email': 'alice@example.com'},
        'user2': {'_id': 'user2', 'name': 'Bob', 'email': 'bob@example.com'},
        'lastMessage': null,
        'updatedAt': '2025-08-11T13:00:00Z',
      };
      mockClient = MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.toString() == '$baseUrl/chats' &&
            request.headers['Authorization'] == 'Bearer $authToken' &&
            request.body == jsonEncode({'userId': userId})) {
          return http.Response(jsonEncode(mockResponse), 201);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act
      final result = await chatApiService.initiateChat(userId, authToken);

      // Assert
      expect(result, equals(mockResponse));
      expect(result, isA<Map<String, dynamic>>());
      expect(result['_id'], 'chat1');
    });

    test('initiateChat throws exception on failure', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'POST' &&
            request.url.toString() == '$baseUrl/chats' &&
            request.headers['Authorization'] == 'Bearer $authToken' &&
            request.body == jsonEncode({'userId': userId})) {
          return http.Response('Bad Request', 400);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      expect(
        () => chatApiService.initiateChat(userId, authToken),
        throwsA(predicate((e) => e.toString().contains('Failed to initiate chat: 400'))),
      );
    });

    test('deleteChat succeeds on 200 status', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'DELETE' &&
            request.url.toString() == '$baseUrl/chats/$chatId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response('', 200);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      await chatApiService.deleteChat(chatId, authToken); // No exception means success
    });

    test('deleteChat throws exception on failure', () async {
      // Arrange
      mockClient = MockClient((request) async {
        if (request.method == 'DELETE' &&
            request.url.toString() == '$baseUrl/chats/$chatId' &&
            request.headers['Authorization'] == 'Bearer $authToken') {
          return http.Response('Not Found', 404);
        }
        return http.Response('Not Found', 404);
      });
      chatApiService = ChatApiService(client: mockClient);

      // Act & Assert
      expect(
        () => chatApiService.deleteChat(chatId, authToken),
        throwsA(predicate((e) => e.toString().contains('Failed to delete chat: 404'))),
      );
    });
  });
}