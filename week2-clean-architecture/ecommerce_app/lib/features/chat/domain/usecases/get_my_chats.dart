import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

/// Use case for fetching all chats of the logged-in user.
class GetMyChats {
  final ChatRepository repository;

  GetMyChats(this.repository);

  Future<Either<Failure, List<Chat>>> call() async {
    return await repository.getMyChats();
  }
}

