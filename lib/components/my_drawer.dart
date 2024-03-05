import 'package:communication_book/screens/chat_page.dart';
import 'package:communication_book/screens/login_page.dart';
import 'package:communication_book/screens/parent/about_page.dart';
import 'package:communication_book/screens/parent/child_details_page.dart';
import 'package:communication_book/screens/parent/upcoming_events_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
    required FirebaseAuth auth,
  }) : _auth = auth;

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                leading: const Icon(Icons.home),
                title: const Text('Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // Navigate to child details page
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Child Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // Navigate to child details page
                  Navigator.pop(context);
                  Get.to(ChildDetailsPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_rounded),
                title: const Text(
                  'Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Navigate to communication page
                  Navigator.pop(context);
                  // Get.to(const ChatPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Upcoming Events',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // Navigate to calendar page
                  Navigator.pop(context);
                  Get.to(const CalendarPage());
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Complain',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  // Navigate to calendar page
                  Navigator.pop(context);
                  Get.to(
                    ChatPage(
                      receiverEmail: 'admin@gmail.com',
                      receiverID: 'ziBBUhossoWLCA1BpTxwbp4dOUC3',
                    ),
                  );
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
                  Get.to(const AboutPage());
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
              _auth.signOut();
              Get.to(const LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
