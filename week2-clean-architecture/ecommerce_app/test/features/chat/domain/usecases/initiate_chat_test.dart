import 'package:dartz/dartz.dart';
// Import User entity
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/initiate_chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ChatRepository])
import 'initiate_chat_test.mocks.dart';

void main() {
  late InitiateChat usecase;
  late MockChatRepository mockRepo;

  // Define dummy users here
  final dummyUser1 = const User(id: 'user1', name: 'Alice', email: 'alice@example.com');
  final dummyUser2 = const User(id: 'user2', name: 'Bob', email: 'bob@example.com');

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = InitiateChat(mockRepo);
  });

  test('should initiate a chat with given userId', () async {
    final userId = 'user123';

    final chat = Chat(
      id: 'chat456',
      user1: dummyUser1,
      user2: dummyUser2,
      lastMessage: null,
      updatedAt: DateTime.now(),
    );

    when(mockRepo.initiateChat(userId))
      .thenAnswer((_) async => Right(chat));

    final result = await usecase(userId);

    verify(mockRepo.initiateChat(userId)).called(1);
    expect(result, Right(chat));
  });
}
