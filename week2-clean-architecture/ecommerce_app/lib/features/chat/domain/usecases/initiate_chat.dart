import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

/// Use case for initiating a new chat with another user.
class InitiateChat {
  final ChatRepository repository;

  InitiateChat(this.repository);

  Future<Either<Failure, Chat>> call(String userId) async {
    return await repository.initiateChat(userId);
  }
}

