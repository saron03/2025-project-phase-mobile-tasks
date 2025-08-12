import 'package:ecommerce_app/core/utils/chat_api_service.dart';
import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:ecommerce_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:ecommerce_app/features/chat/data/models/message_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_remote_data_source_test.mocks.dart';

// Generate a Mock class for the ChatApiService
@GenerateMocks([ChatApiService])
void main() {
  late ChatRemoteDataSourceImpl dataSource;
  late MockChatApiService mockApiService;

  // Set up the mocks and the data source before each test
  setUp(() {
    mockApiService = MockChatApiService();
    dataSource = ChatRemoteDataSourceImpl(apiService: mockApiService);
  });

  // Define some mock data to use in the tests
  const userId = 'user_id_123';
  const chatId = 'chat_id_456';
  const authToken = 'auth_token_789';

  final mockUser1 = const UserModel(
    id: 'user1_id',
    name: 'User One',
    email: 'user1@example.com',
  );

  final mockUser2 = const UserModel(
    id: 'user2_id',
    name: 'User Two',
    email: 'user2@example.com',
  );



  // Define the JSON that the mock API service will return
  final mockChatJsonList = [
    {
      '_id': 'chat_id_1',
      'user1': mockUser1.toJson(),
      'user2': mockUser2.toJson(),
      'lastMessage': { // <-- Changed to hardcoded JSON
        '_id': 'message_id_1',
        'sender': mockUser1.toJson(),
        'chat': {'_id': 'chat_id_1'},
        'content': 'Hello, how are you?',
        'type': 'text',
        'createdAt': '2025-08-11T12:00:00Z',
      },
      'updatedAt': '2025-08-11T12:05:00Z',
    },
  ];

final mockChatJson = {
  '_id': 'chat_id_456',
  'user1': mockUser1.toJson(),
  'user2': mockUser2.toJson(),
  'lastMessage': {
    '_id': 'message_id_1',
    'sender': mockUser1.toJson(),
    'chat': {'_id': chatId},
    'content': 'Hello, how are you?',
    'type': 'text',
    'createdAt': '2025-08-11T12:00:00Z',
  },
  'updatedAt': '2025-08-11T12:05:00Z',
};
final mockMessagesJsonList = [
  {
    '_id': 'message_id_1',
    'sender': mockUser1.toJson(),
    'chat': {'_id': chatId},
    'content': 'Hello, how are you?',
    'type': 'text',
    'createdAt': '2025-08-11T12:00:00Z',
  },
];

  // --- Tests for each method in the data source ---

  group('ChatRemoteDataSourceImpl', () {
    test('getChats should return a list of ChatModels', () async {
      // Stub the mock API service to return the mock JSON list
      when(mockApiService.getChats(userId, authToken))
          .thenAnswer((_) async => mockChatJsonList);

      // Call the method to be tested
      final result = await dataSource.getChats(userId, authToken);

      // Verify the result
      expect(result, isA<List<ChatModel>>());
      expect(result.first.id, 'chat_id_1');
      verify(mockApiService.getChats(userId, authToken)).called(1);
    });

    test('getChatById should return a single ChatModel', () async {
      // Stub the mock API service
      when(mockApiService.getChatById(chatId, authToken))
          .thenAnswer((_) async => mockChatJson);

      // Call the method
      final result = await dataSource.getChatById(chatId, authToken);

      // Verify the result and the mock call
      expect(result, isA<ChatModel>());
      expect(result.id, chatId);
      verify(mockApiService.getChatById(chatId, authToken)).called(1);
    });

    test('getMessages should return a list of MessageModels', () async {
      // Stub the mock API service
      when(mockApiService.getMessages(chatId, authToken))
          .thenAnswer((_) async => mockMessagesJsonList);

      // Call the method
      final result = await dataSource.getMessages(chatId, authToken);

      // Verify the result and the mock call
      expect(result, isA<List<MessageModel>>());
      expect(result.first.content, 'Hello, how are you?');
      verify(mockApiService.getMessages(chatId, authToken)).called(1);
    });

    test('initiateChat should return a new ChatModel', () async {
      // Stub the mock API service
      when(mockApiService.initiateChat(userId, authToken))
          .thenAnswer((_) async => mockChatJson);

      // Call the method
      final result = await dataSource.initiateChat(userId, authToken);

      // Verify the result and the mock call
      expect(result, isA<ChatModel>());
      expect(result.id, 'chat_id_456');
      verify(mockApiService.initiateChat(userId, authToken)).called(1);
    });

    test('deleteChat should call the API service delete method', () async {
      // Stub the mock API service
      when(mockApiService.deleteChat(chatId, authToken))
          .thenAnswer((_) async {});

      // Call the method
      await dataSource.deleteChat(chatId, authToken);

      // Verify that the API service method was called exactly once
      verify(mockApiService.deleteChat(chatId, authToken)).called(1);
    });
  });
}