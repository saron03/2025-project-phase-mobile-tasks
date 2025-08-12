import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ChatRepository])
import 'get_chat_messages_test.mocks.dart';

void main() {
  late GetChatMessages usecase;
  late MockChatRepository mockRepo;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = GetChatMessages(mockRepo);
  });

  test('should get list of Messages from repository for given chatId', () async {
    final chatId = 'chat123';

    // Create dummy Users
    final user1 = const User(id: 'user1', name: 'Alice', email: 'alice@example.com');
    final user2 = const User(id: 'user2', name: 'Bob', email: 'bob@example.com');

    final messages = <Message>[
      Message(
        id: 'msg1',
        sender: user1,
        chatId: chatId,
        content: 'Hello',
        type: 'text',
        createdAt: DateTime.now(),
      ),
      Message(
        id: 'msg2',
        sender: user2,
        chatId: chatId,
        content: 'Hi there!',
        type: 'text',
        createdAt: DateTime.now(),
      ),
    ];

    when(mockRepo.getChatMessages(chatId))
      .thenAnswer((_) async => Right(messages));

    final result = await usecase(chatId);

    verify(mockRepo.getChatMessages(chatId)).called(1);
    expect(result, Right(messages));
  });
}
