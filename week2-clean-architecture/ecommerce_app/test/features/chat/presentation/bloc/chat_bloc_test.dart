import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/delete_chat.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_my_chats.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/initiate_chat.dart';
import 'package:ecommerce_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_bloc_test.mocks.dart';

@GenerateMocks([
  GetMyChats,
  GetChatMessages,
  InitiateChat,
  DeleteChat,
])
void main() {
  late ChatBloc chatBloc;
  late MockGetMyChats mockGetMyChats;
  late MockGetChatMessages mockGetChatMessages;
  late MockInitiateChat mockInitiateChat;
  late MockDeleteChat mockDeleteChat;

  // Mock data
  const User mockUser1 = User(id: 'u1', name: 'User 1', email: 'u1@example.com');
  const User mockUser2 = User(id: 'u2', name: 'User 2', email: 'u2@example.com');
  final Chat mockChat = Chat(
    id: 'c1',
    user1: mockUser1,
    user2: mockUser2,
    lastMessage: Message(
      id: 'm1',
      sender: mockUser1,
      chatId: 'c1',
      content: 'Hello',
      type: 'text',
      createdAt: DateTime.now(),
    ),
    updatedAt: DateTime.now(),
  );
  final List<Chat> mockChatList = [mockChat];
  final List<Message> mockMessageList = [mockChat.lastMessage!];
  const String tChatId = 'c1';
  const String tUserId = 'u2';
  const String tErrorMessage = 'Server Error';
  final ServerFailure tServerFailure = const ServerFailure(tErrorMessage);

  setUp(() {
    mockGetMyChats = MockGetMyChats();
    mockGetChatMessages = MockGetChatMessages();
    mockInitiateChat = MockInitiateChat();
    mockDeleteChat = MockDeleteChat();
    chatBloc = ChatBloc(
      getMyChats: mockGetMyChats,
      getChatMessages: mockGetChatMessages,
      initiateChat: mockInitiateChat,
      deleteChat: mockDeleteChat,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc', () {
    test('initial state should be ChatInitial', () {
      expect(chatBloc.state, ChatInitial());
    });
  });

  group('GetMyChatsEvent', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatsLoaded] when GetMyChats is successful',
      build: () {
        when(mockGetMyChats()).thenAnswer((_) async => Right(mockChatList));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const GetMyChatsEvent()),
      expect: () => [
        ChatsLoading(),
        ChatsLoaded(mockChatList),
      ],
      verify: (_) {
        verify(mockGetMyChats()).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatError] when GetMyChats fails',
      build: () {
        when(mockGetMyChats()).thenAnswer((_) async => Left(tServerFailure));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const GetMyChatsEvent()),
      expect: () => [
        ChatsLoading(),
        const ChatError(tErrorMessage),
      ],
      verify: (_) {
        verify(mockGetMyChats()).called(1);
      },
    );
  });

  group('GetChatMessagesEvent', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatMessagesLoading, ChatMessagesLoaded] when GetChatMessages is successful',
      build: () {
        when(mockGetChatMessages(tChatId))
            .thenAnswer((_) async => Right(mockMessageList));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const GetChatMessagesEvent(tChatId)),
      expect: () => [
        ChatMessagesLoading(),
        ChatMessagesLoaded(mockMessageList),
      ],
      verify: (_) {
        verify(mockGetChatMessages(tChatId)).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatMessagesLoading, ChatError] when GetChatMessages fails',
      build: () {
        when(mockGetChatMessages(tChatId))
            .thenAnswer((_) async => Left(tServerFailure));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const GetChatMessagesEvent(tChatId)),
      expect: () => [
        ChatMessagesLoading(),
        const ChatError(tErrorMessage),
      ],
      verify: (_) {
        verify(mockGetChatMessages(tChatId)).called(1);
      },
    );
  });

  group('InitiateChatEvent', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatActionSuccess] when InitiateChat is successful',
      build: () {
        when(mockInitiateChat(tUserId)).thenAnswer((_) async => Right(mockChat));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const InitiateChatEvent(tUserId)),
      expect: () => [
        ChatsLoading(),
        ChatActionSuccess('Chat with user ${mockUser2.name} initiated successfully'),
      ],
      verify: (_) {
        verify(mockInitiateChat(tUserId)).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatError] when InitiateChat fails',
      build: () {
        when(mockInitiateChat(tUserId)).thenAnswer((_) async => Left(tServerFailure));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const InitiateChatEvent(tUserId)),
      expect: () => [
        ChatsLoading(),
        const ChatError(tErrorMessage),
      ],
      verify: (_) {
        verify(mockInitiateChat(tUserId)).called(1);
      },
    );
  });

  group('DeleteChatEvent', () {
    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatActionSuccess] when DeleteChat is successful',
      build: () {
        when(mockDeleteChat(tChatId)).thenAnswer((_) async => const Right(unit));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const DeleteChatEvent(tChatId)),
      expect: () => [
        ChatsLoading(),
        const ChatActionSuccess('Chat deleted successfully'),
      ],
      verify: (_) {
        verify(mockDeleteChat(tChatId)).called(1);
      },
    );

    blocTest<ChatBloc, ChatState>(
      'should emit [ChatsLoading, ChatError] when DeleteChat fails',
      build: () {
        when(mockDeleteChat(tChatId)).thenAnswer((_) async => Left(tServerFailure));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const DeleteChatEvent(tChatId)),
      expect: () => [
        ChatsLoading(),
        const ChatError(tErrorMessage),
      ],
      verify: (_) {
        verify(mockDeleteChat(tChatId)).called(1);
      },
    );
  });
}