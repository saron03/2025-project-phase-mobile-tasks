import 'package:dartz/dartz.dart';
// Import your User entity path
import 'package:ecommerce_app/features/auth/domain/entities/user.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_my_chats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_my_chats_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late GetMyChats usecase;
  late MockChatRepository mockRepo;

  // Define dummy users here
  final dummyUser1 = const User(id: 'user1', name: 'Alice', email: 'alice@example.com');
  final dummyUser2 = const User(id: 'user2', name: 'Bob', email: 'bob@example.com');

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = GetMyChats(mockRepo);
  });

  test('should get list of chats from repository', () async {
    final chats = <Chat>[
      Chat(
        id: 'chat1',
        user1: dummyUser1,
        user2: dummyUser2,
        lastMessage: null,
        updatedAt: DateTime.now(),
      ),
      Chat(
        id: 'chat2',
        user1: dummyUser1,
        user2: dummyUser2,
        lastMessage: null,
        updatedAt: DateTime.now(),
      ),
    ];

    when(mockRepo.getMyChats()).thenAnswer((_) async => Right(chats));

    final result = await usecase();

    verify(mockRepo.getMyChats()).called(1);
    expect(result, Right(chats));
  });
}
