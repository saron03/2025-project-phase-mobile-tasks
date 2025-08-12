import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/chat/domain/entities/chat.dart';
import 'package:ecommerce_app/features/chat/domain/entities/message.dart';
import 'package:ecommerce_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  late ChatRepository repository;

  setUp(() {
    repository = _MockChatRepository();
  });

  test('should have all method signatures', () async {
    expect(() => repository.getMyChats(), throwsUnimplementedError);
    expect(() => repository.getChatById('id'), throwsUnimplementedError);
    expect(() => repository.getChatMessages('chatId'), throwsUnimplementedError);
    expect(() => repository.initiateChat('userId'), throwsUnimplementedError);
    expect(() => repository.deleteChat('chatId'), throwsUnimplementedError);
  });
}

class _MockChatRepository implements ChatRepository {
  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) {
    // TODO: implement getChatById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) {
    // TODO: implement getChatMessages
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() {
    // TODO: implement getMyChats
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) {
    // TODO: implement initiateChat
    throw UnimplementedError();
  }
}


