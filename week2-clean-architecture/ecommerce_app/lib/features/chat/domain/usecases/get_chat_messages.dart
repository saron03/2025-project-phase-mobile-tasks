import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';
/// Use case for fetching messages for a chat.
class GetChatMessages {
  final ChatRepository repository;

  GetChatMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(String chatId) async {
    return await repository.getChatMessages(chatId);
  }
}

