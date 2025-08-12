import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import '../../../auth/data/models/user_model.dart';
import '../models/message_model.dart';

class ChatSocketService {
  socket_io.Socket? _socket;

  // Initialize Socket.IO connection
  void connect(String authToken) {
    _socket = socket_io.io(
      'https://g5-flutter-learning-path-be-tvum.onrender.com',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': authToken})
          .build(),
    );

    _socket?.onConnect((_) => print('Socket connected'));
    _socket?.onDisconnect((_) => print('Socket disconnected'));
    _socket?.onError((error) => print('Socket error: $error'));
  }

  // Send a message
  void sendMessage(String chatId, String content, String type) {
    _socket?.emit('message:send', {
      'chatId': chatId,
      'content': content,
      'type': type,
    });
  }

  // Listen for delivered messages (to sender)
  void onMessageDelivered(void Function(MessageModel) callback) {
    _socket?.on('message:delivered', (data) {
      final message = _parseMessage(data as Map<String, dynamic>);
      callback(message);
    });
  }

  // Listen for received messages (to receiver)
  void onMessageReceived(void Function(MessageModel) callback) {
    _socket?.on('message:received', (data) {
      final message = _parseMessage(data as Map<String, dynamic>);
      callback(message);
    });
  }

  // Parse server message to MessageModel
  MessageModel _parseMessage(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String, // Server uses _id instead of id
      sender: UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: json['chat']['_id'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Disconnect from the server
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  // Check if socket is connected
  bool isConnected() => _socket?.connected ?? false;
}