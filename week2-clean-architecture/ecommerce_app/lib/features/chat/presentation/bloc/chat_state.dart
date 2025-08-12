part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<Chat> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatMessagesLoading extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<Message> messages;
  const ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

class ChatActionSuccess extends ChatState {
  final String message;
  const ChatActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}