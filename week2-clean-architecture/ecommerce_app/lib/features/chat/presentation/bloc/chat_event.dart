part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetMyChatsEvent extends ChatEvent {
  const GetMyChatsEvent();
}

class GetChatMessagesEvent extends ChatEvent {
  final String chatId;
  const GetChatMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class InitiateChatEvent extends ChatEvent {
  final String userId;
  const InitiateChatEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;
  const DeleteChatEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}
