import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communication_book/components/chat_bubble.dart';
import 'package:communication_book/components/my_textfield.dart';
import 'package:communication_book/services/auth_service.dart';
import 'package:communication_book/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  final String receiverEmail;
  final String receiverID;

  final _messageController = TextEditingController();

  final _chatService = ChatService();
  final _authService = AuthService();

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      // send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(receiverEmail),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        foregroundColor: Colors.white,
        elevation: 2,
        title: Text(
          receiverEmail,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender is the current user , otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              labelText: 'Type a message',
              obscureText: false,
              controller: _messageController,
            ),
          ),

          // send button
          Container(
            margin: const EdgeInsets.only(right: 25),
            decoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
