import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../pages/chat_messages_page.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;
  const ChatListItem({super.key, required this.chat});

  // Helper to determine the other user in the chat
  // TODO: You'll need to pass the current user's ID to this widget
  User? _getOtherUser(String currentUserId) {
    if (chat.user1?.id == currentUserId) {
      return chat.user2;
    } else {
      return chat.user1;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with the actual current user ID
    const String currentUserId = 'current_user_id';
    final User? otherUser = _getOtherUser(currentUserId);

    if (otherUser == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatMessagesPage(
              chatId: chat.id,
              otherUser: otherUser,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              child: Text(otherUser.name.substring(0, 1)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage?.content ?? 'No messages yet',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              chat.updatedAt != null ? '...' : '', // TODO: Format time
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}