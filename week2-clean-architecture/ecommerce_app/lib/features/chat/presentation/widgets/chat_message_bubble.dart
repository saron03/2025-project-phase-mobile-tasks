import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final Color bubbleColor = isCurrentUser ? Colors.blue : Colors.grey.shade300;
    final Color textColor = isCurrentUser ? Colors.white : Colors.black;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isCurrentUser
                ? const Radius.circular(16.0)
                : const Radius.circular(0.0),
            bottomRight: isCurrentUser
                ? const Radius.circular(0.0)
                : const Radius.circular(16.0),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}