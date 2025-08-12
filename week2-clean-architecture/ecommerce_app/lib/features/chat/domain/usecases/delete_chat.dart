import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

/// Use case for deleting a chat by its ID.
class DeleteChat {
  final ChatRepository repository;

  DeleteChat(this.repository);

  Future<Either<Failure, Unit>> call(String chatId) async {
    return await repository.deleteChat(chatId);
  }
}
