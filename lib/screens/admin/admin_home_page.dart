import 'package:communication_book/screens/admin/add_new_student.dart';
import 'package:communication_book/screens/admin/all_students.dart';
import 'package:communication_book/screens/login_page.dart';
import 'package:communication_book/screens/teacher/add_event_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHomePage extends StatelessWidget {
  AdminHomePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Admin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Manage Students',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(const AllStudents());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Manage Teachers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Add Student',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {
                    // Navigate to child details page
                    Navigator.pop(context);
                    Get.to(const AddNewStudent());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_rounded),
                  title: const Text(
                    'Add Teacher',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Add Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  onTap: () {
                    // Navigate to calendar page
                    Navigator.pop(context);
                    Get.to(const AddEventPage());
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
                Get.to(const LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
