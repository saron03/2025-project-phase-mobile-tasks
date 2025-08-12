import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:ecommerce_app/features/chat/domain/usecases/delete_chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// This will generate the mock class in 'delete_chat_test.mocks.dart'
@GenerateMocks([ChatRepository])
import 'delete_chat_test.mocks.dart';

void main() {
  late DeleteChat usecase;
  late MockChatRepository mockRepo;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = DeleteChat(mockRepo);
  });

  test('should call deleteChat on repository with chatId', () async {
    final chatId = 'chat123';

    when(mockRepo.deleteChat(chatId))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(chatId);

    verify(mockRepo.deleteChat(chatId)).called(1);
    expect(result, const Right(unit));
  });
}
