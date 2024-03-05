import 'package:communication_book/components/my_drawer.dart';
import 'package:communication_book/components/user_tile.dart';
import 'package:communication_book/screens/chat_page.dart';
import 'package:communication_book/services/auth_service.dart';
import 'package:communication_book/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(auth: _auth),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // tapped on a user -> go to chat page
          Get.to(ChatPage(
            receiverEmail: userData['email'],
            receiverID: userData['uid'],
          ));
        },
      );
    } else {
      return Container();
    }
  }
}
