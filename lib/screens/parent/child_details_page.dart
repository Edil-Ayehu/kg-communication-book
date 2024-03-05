import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChildDetailsPage extends StatelessWidget {
  ChildDetailsPage({super.key});

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
        debugPrint('Error fetching child data: $e');
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
        backgroundColor: Colors.lightBlueAccent[100],
        foregroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Child Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: NetworkImage('${childData['imageUrl']}'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '${childData['name']}',
                      style: const TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${childData['grade']} student',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.fitness_center,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['weight']}kg",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.straighten,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['height']}m",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['age']} y/o",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['gender']}",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    Card(
                      color: Colors.lightBlueAccent[100],
                      child: ListTile(
                        leading: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        title: Text(
                          '${childData['parent name']}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${childData['relationship']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'CONTACT INFORMATION',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['p_phoneNo']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.44,
                            height: 110,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 36,
                                  color: Colors.lightBlueAccent,
                                ),
                                Text(
                                  "${childData['p_email']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightBlueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                      title: const Text(
                        'Allergies',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('${childData['allergies']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text(
                        'Medical Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('${childData['medical condition']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: const Text(
                        'Medications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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