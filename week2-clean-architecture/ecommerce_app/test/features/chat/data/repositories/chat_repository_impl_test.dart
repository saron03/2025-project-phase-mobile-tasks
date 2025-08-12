import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/auth/data/models/user_model.dart';
import 'package:ecommerce_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ecommerce_app/features/chat/data/models/chat_model.dart';
import 'package:ecommerce_app/features/chat/data/models/message_model.dart';
import 'package:ecommerce_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([ChatRemoteDataSource])
void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;

  const String authToken = 'test-token';
  const String userId = 'current_user_id';
  const String chatId = 'chat-id-123';

  // Mock data to be used in tests
  final mockUser = const UserModel(id: 'user_1', name: 'User 1', email: 'u1@example.com');
  final mockMessage = MessageModel(
    id: 'msg-id',
    sender: mockUser,
    chatId: chatId,
    content: 'Test message',
    type: 'text',
    createdAt: DateTime.now(),
  );
  final mockChat = ChatModel(
    id: chatId,
    user1: mockUser,
    user2: mockUser,
    lastMessage: mockMessage,
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(remoteDataSource: mockRemoteDataSource, authToken: authToken);
  });

  group('ChatRepositoryImpl', () {
    // --- getMyChats tests ---
    group('getMyChats', () {
      test(
        'should return a list of Chat models when the call to remote data source is successful',
        () async {
          // Arrange
          final List<ChatModel> chatModels = [mockChat];
          when(mockRemoteDataSource.getChats(userId, authToken)).thenAnswer((_) async => chatModels);

          // Act
          final result = await repository.getMyChats();

          // Assert
          expect(result, Right(chatModels));
          verify(mockRemoteDataSource.getChats(userId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return a ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getChats(userId, authToken)).thenThrow(Exception('Server error'));

          // Act
          final result = await repository.getMyChats();

          // Assert
          expect(result, const Left(ServerFailure('Exception: Server error')));
          verify(mockRemoteDataSource.getChats(userId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    // --- getChatById tests ---
    group('getChatById', () {
      test(
        'should return a Chat model when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getChatById(chatId, authToken)).thenAnswer((_) async => mockChat);

          // Act
          final result = await repository.getChatById(chatId);

          // Assert
          expect(result, Right(mockChat));
          verify(mockRemoteDataSource.getChatById(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return a ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getChatById(chatId, authToken)).thenThrow(Exception('Server error'));

          // Act
          final result = await repository.getChatById(chatId);

          // Assert
          expect(result, const Left(ServerFailure('Exception: Server error')));
          verify(mockRemoteDataSource.getChatById(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    // --- getChatMessages tests ---
    group('getChatMessages', () {
      test(
        'should return a list of Message models when the call to remote data source is successful',
        () async {
          // Arrange
          final List<MessageModel> messageModels = [mockMessage];
          when(mockRemoteDataSource.getMessages(chatId, authToken)).thenAnswer((_) async => messageModels);

          // Act
          final result = await repository.getChatMessages(chatId);

          // Assert
          expect(result, Right(messageModels));
          verify(mockRemoteDataSource.getMessages(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return a ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.getMessages(chatId, authToken)).thenThrow(Exception('Server error'));

          // Act
          final result = await repository.getChatMessages(chatId);

          // Assert
          expect(result, const Left(ServerFailure('Exception: Server error')));
          verify(mockRemoteDataSource.getMessages(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    // --- initiateChat tests ---
    group('initiateChat', () {
      test(
        'should return a Chat model when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.initiateChat(userId, authToken)).thenAnswer((_) async => mockChat);

          // Act
          final result = await repository.initiateChat(userId);

          // Assert
          expect(result, Right(mockChat));
          verify(mockRemoteDataSource.initiateChat(userId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return a ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.initiateChat(userId, authToken)).thenThrow(Exception('Server error'));

          // Act
          final result = await repository.initiateChat(userId);

          // Assert
          expect(result, const Left(ServerFailure('Exception: Server error')));
          verify(mockRemoteDataSource.initiateChat(userId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });

    // --- deleteChat tests ---
    group('deleteChat', () {
      test(
        'should return a Right(unit) when the call to remote data source is successful',
        () async {
          // Arrange
          when(mockRemoteDataSource.deleteChat(chatId, authToken)).thenAnswer((_) async => Future.value());

          // Act
          final result = await repository.deleteChat(chatId);

          // Assert
          expect(result, const Right(unit));
          verify(mockRemoteDataSource.deleteChat(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );

      test(
        'should return a ServerFailure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(mockRemoteDataSource.deleteChat(chatId, authToken)).thenThrow(Exception('Server error'));

          // Act
          final result = await repository.deleteChat(chatId);

          // Assert
          expect(result, const Left(ServerFailure('Exception: Server error')));
          verify(mockRemoteDataSource.deleteChat(chatId, authToken)).called(1);
          verifyNoMoreInteractions(mockRemoteDataSource);
        },
      );
    });
  });
}