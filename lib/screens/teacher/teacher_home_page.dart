import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communication_book/components/user_tile.dart';
import 'package:communication_book/screens/chat_page.dart';
import 'package:communication_book/screens/login_page.dart';
import 'package:communication_book/screens/parent/about_page.dart';
import 'package:communication_book/services/auth_service.dart';
import 'package:communication_book/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherHomePage extends StatelessWidget {
  TeacherHomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: const Text('Teacher Dashboard'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      image: DecorationImage(
                        image: AssetImage('assets/kg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {
                    // Navigate to settings page
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                // Navigate to settings page
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
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
