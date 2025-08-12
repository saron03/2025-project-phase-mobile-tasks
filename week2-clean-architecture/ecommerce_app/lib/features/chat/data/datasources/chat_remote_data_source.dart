import '../../../../core/utils/chat_api_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats(String userId, String authToken);
  Future<ChatModel> getChatById(String chatId, String authToken);
  Future<List<MessageModel>> getMessages(String chatId, String authToken);
  Future<ChatModel> initiateChat(String userId, String authToken);
  Future<void> deleteChat(String chatId, String authToken);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatApiService apiService;

  ChatRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ChatModel>> getChats(String userId, String authToken) async {
    final jsonList = await apiService.getChats(userId, authToken);
    
    return jsonList.map((json) => _parseChat(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ChatModel> getChatById(String chatId, String authToken) async {
    final json = await apiService.getChatById(chatId, authToken);
    return _parseChat(json);
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId, String authToken) async {
    final jsonList = await apiService.getMessages(chatId, authToken);
    return jsonList.map((json) => _parseMessage(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<ChatModel> initiateChat(String userId, String authToken) async {
    final json = await apiService.initiateChat(userId, authToken);
    return _parseChat(json);
  }

  @override
  Future<void> deleteChat(String chatId, String authToken) async {
    await apiService.deleteChat(chatId, authToken);
  }

  // Parse server chat to ChatModel
  ChatModel _parseChat(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] as String,
      user1: UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: UserModel.fromJson(json['user2'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] != null
          ? _parseMessage(json['lastMessage'] as Map<String, dynamic>)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Parse server message to MessageModel
  MessageModel _parseMessage(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chat']?['_id'] as String? ?? '',
      content: (json['content'] as String?) ?? '', // Use null-aware operator
      type: (json['type'] as String?) ?? '', // Use null-aware operator
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}