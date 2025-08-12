import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
  });

  Future<String> _getAuthToken() async {
    final token = await authRepository.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found.');
    }
    return token;
  }

  Future<String> _getCurrentUserId() async {
    final user = await authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('Current user not found.');
    }
    return user.id;
  }

  @override
  Future<Either<Failure, List<Chat>>> getMyChats() async {
    try {
      final authToken = await _getAuthToken();
      final userId = await _getCurrentUserId();
      final chats = await remoteDataSource.getChats(userId, authToken);
      return Right(chats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> getChatById(String chatId) async {
    try {
      final authToken = await _getAuthToken();
      final chat = await remoteDataSource.getChatById(chatId, authToken);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    try {
      final authToken = await _getAuthToken();
      final messages = await remoteDataSource.getMessages(chatId, authToken);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Chat>> initiateChat(String userId) async {
    try {
      final authToken = await _getAuthToken();
      final chat = await remoteDataSource.initiateChat(userId, authToken);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) async {
    try {
      final authToken = await _getAuthToken();
      await remoteDataSource.deleteChat(chatId, authToken);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
