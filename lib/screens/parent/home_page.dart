import 'package:communication_book/screens/chat_page.dart';
import 'package:communication_book/screens/login_page.dart';
import 'package:communication_book/screens/parent/about_page.dart';
import 'package:communication_book/screens/parent/upcoming_events_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch child data for the logged-in parent
  Future<Map<String, dynamic>> getChildData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Get the parent document associated with the logged-in user
        DocumentSnapshot parentDoc =
            await _firestore.collection('parents').doc(user.uid).get();

        if (parentDoc.exists) {
          // Get the child sub-collection from the parent document
          QuerySnapshot childSnapshot =
              await parentDoc.reference.collection('child').get();

          // Return child data if exists
          if (childSnapshot.docs.isNotEmpty) {
            return childSnapshot.docs.first.data() as Map<String, dynamic>;
          }
        }
      } catch (e) {
        // Handle any errors
        print('Error fetching child data: $e');
        throw e; // Re-throw the error
      }
    }

    // If user is not logged in or no child data found, return an empty map
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        title: const Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Child Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () {
                // Navigate to child details page
                Navigator.pop(context);
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatPage(),
                  ),
                );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CalendarPage(),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
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
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: getChildData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Child data retrieved successfully
              Map<String, dynamic> childData = snapshot.data ?? {};

              // Display child details
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundImage: NetworkImage(
                            '${childData['imageUrl']}'), // You can replace this with an actual image
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(
                            '${childData['name']}',
                            style: const TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    Text(
                      'ABOUT ${childData['name']}'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Text(
                          'Grade: ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${childData['grade']}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Age: ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${childData['age']} years',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Height: ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${childData['height']} m',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Weight: ',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${childData['weight']} kg',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'PARENT/GUARDIAN',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('${childData['parent name']}'),
                      subtitle: Text('${childData['relationship']}'),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'CONTACT INFORMATION',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Phone'),
                      subtitle: Text('${childData['p_phoneNo']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text('${childData['p_email']}'),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'MEDICAL INFROMATION',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text('Allergies'),
                      subtitle: Text('${childData['allergies']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text('Medical Conditions'),
                      subtitle: Text('${childData['medical condition']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text('Medications'),
                      subtitle: Text('${childData['medications']}'),
                    ),
                    // Add more child details as needed
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
