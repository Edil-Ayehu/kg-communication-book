import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:communication_book/screens/admin/admin_home_page.dart';
import 'package:communication_book/screens/parent/home_page.dart';
import 'package:communication_book/screens/teacher/teacher_home_page.dart';
import 'package:communication_book/screens/login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  _AuthGateState createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            // User is signed in
            User? user = snapshot.data;
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('parents').doc(user!.uid).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    // User data exists
                    var role = snapshot.data!.get('role');
                    if (role == "admin") {
                      return AdminHomePage();
                    } else if (role == "teacher") {
                      return TeacherHomePage();
                    } else {
                      return HomePage();
                    }
                  } else {
                    // User data does not exist
                    return const LoginPage();
                  }
                }
              },
            );
          } else {
            // User is not signed in
            return const LoginPage();
          }
        }
      },
    );
  }
}




