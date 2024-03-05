import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:25,vertical: 16),
      margin: const EdgeInsets.symmetric(vertical:2.5,horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.lightBlueAccent: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
