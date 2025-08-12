// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/delete_chat.dart';
import '../../domain/usecases/get_chat_messages.dart';
import '../../domain/usecases/get_my_chats.dart';
import '../../domain/usecases/initiate_chat.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMyChats getMyChats;
  final GetChatMessages getChatMessages;
  final InitiateChat initiateChat;
  final DeleteChat deleteChat;

  ChatBloc({
    required this.getMyChats,
    required this.getChatMessages,
    required this.initiateChat,
    required this.deleteChat,
  }) : super(ChatInitial()) {
    on<GetMyChatsEvent>(_onGetMyChats);
    on<GetChatMessagesEvent>(_onGetChatMessages);
    on<InitiateChatEvent>(_onInitiateChat);
    on<DeleteChatEvent>(_onDeleteChat);
  }

  void _onGetMyChats(GetMyChatsEvent event, Emitter<ChatState> emit) async {
    debugPrint('ChatBloc: Handling GetMyChatsEvent');
    emit(ChatsLoading());
    final result = await getMyChats();
    result.fold(
      (failure) {
        debugPrint('ChatBloc: GetMyChats failed with error: ${failure.message}');
        emit(ChatError(failure.message));
      },
      (chats) {
        debugPrint('ChatBloc: Successfully received ${chats.length} chats');
        emit(ChatsLoaded(chats));
      },
    );
  }

  void _onGetChatMessages(GetChatMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessagesLoading());
    final result = await getChatMessages(event.chatId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatMessagesLoaded(messages)),
    );
  }

  void _onInitiateChat(InitiateChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final result = await initiateChat(event.userId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chat) => emit(ChatActionSuccess(
          'Chat with user ${chat.user2?.name} initiated successfully')),
    );
  }

  void _onDeleteChat(DeleteChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final result = await deleteChat(event.chatId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(const ChatActionSuccess('Chat deleted successfully')),
    );
  }
}