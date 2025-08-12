import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_list_item.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    super.initState();
    // This dispatches the event to fetch chats when the page is first loaded.
    context.read<ChatBloc>().add(const GetMyChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ChatBloc>().add(const GetMyChatsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading || state is ChatInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsLoaded) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final Chat chat = state.chats[index];
                // === MODIFIED PART: Removed the 'currentUserId' parameter ===
                return ChatListItem(chat: chat);
                // === END MODIFIED PART ===
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('An unknown error occurred.'));
          }
        },
      ),
    );
  }
}