import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/get_chat_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for ChatRepository
@GenerateMocks([ChatRepository])
import 'get_chat_by_id_test.mocks.dart';

void main() {
  late GetChatById usecase;
  late MockChatRepository mockRepo;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = GetChatById(mockRepo);
  });

  test('should return a Chat from repository by id', () async {
    final chatId = 'chat123';

    // TODO: Replace these with real dummy User instances
    final dummyUser = /* your dummy User instance or mock here */ null;

    final chat = Chat(
      id: chatId,
      user1: dummyUser,
      user2: dummyUser,
      lastMessage: null,
      updatedAt: null,
    );

    when(mockRepo.getChatById(chatId))
      .thenAnswer((_) async => Right(chat));

    final result = await usecase(chatId);

    verify(mockRepo.getChatById(chatId)).called(1);
    expect(result, Right(chat));
  });
}
