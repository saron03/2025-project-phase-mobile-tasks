import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_message_bubble.dart';

class ChatMessagesPage extends StatefulWidget {
  final String chatId;
  final User otherUser;

  const ChatMessagesPage({
    super.key,
    required this.chatId,
    required this.otherUser,
  });

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetChatMessagesEvent(widget.chatId));
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _textController.clear();
      // TODO: Implement send message event when you have a use case for it
      // context.read<ChatBloc>().add(SendMessageEvent(widget.chatId, text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.name),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatMessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatMessagesLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Display latest messages at the bottom
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final Message message = state.messages[index];
                      // TODO: Determine if the message is from the current user
                      const bool isCurrentUser = false; 
                      return ChatMessageBubble(
                        message: message,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
                ),
                _buildTextComposer(),
              ],
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No messages to display.'));
          }
        },
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}