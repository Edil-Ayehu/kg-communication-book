import 'package:communication_book/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddNewStudent extends StatefulWidget {
  const AddNewStudent({Key? key}) : super(key: key);

  @override
  _AddNewStudentState createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _childNameController = TextEditingController();
  final TextEditingController _childAgeController = TextEditingController();
  final TextEditingController _childAllergiesController =
      TextEditingController();
  final TextEditingController _childGenderController = TextEditingController();
  final TextEditingController _childGradeController = TextEditingController();
  final TextEditingController _childHeightController = TextEditingController();
  final TextEditingController _childImageUrlController =
      TextEditingController();
  final TextEditingController _childMedicalConditionController =
      TextEditingController();
  final TextEditingController _childMedicationsController =
      TextEditingController();
  final TextEditingController _childPPhoneNoController =
      TextEditingController();
  final TextEditingController _childRelationshipController =
      TextEditingController();
  final TextEditingController _childWeightController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showSpinner = false;

  Future<void> _addParent() async {
    setState(() {
      _showSpinner = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();
    String childName = _childNameController.text.trim();
    int childAge = int.tryParse(_childAgeController.text.trim()) ?? 0;
    String childAllergies = _childAllergiesController.text.trim();
    String childGender = _childGenderController.text.trim();
    String childGrade = _childGradeController.text.trim();
    String childHeight = _childHeightController.text.trim();
    String childImageUrl = _childImageUrlController.text.trim();
    String childMedicalCondition = _childMedicalConditionController.text.trim();
    String childMedications = _childMedicationsController.text.trim();
    String childPPhoneNo = _childPPhoneNoController.text.trim();
    String childRelationship = _childRelationshipController.text.trim();
    String childWeight = _childWeightController.text.trim();

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        name.isNotEmpty &&
        childName.isNotEmpty &&
        childAge > 0) {
      try {
        // Create user account with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the newly created user's ID
        String userId = userCredential.user!.uid;

        // Get a reference to the parents collection
        CollectionReference parentsCollection =
            FirebaseFirestore.instance.collection('parents');

        // Add a new document with the user ID
        DocumentReference newParentRef = parentsCollection.doc(userId);
        await newParentRef.set({
          'email': email,
          'name': name,
          'role': 'parent',
        });

        // Add child data to the child subcollection
        CollectionReference childCollection = newParentRef.collection('child');
        await childCollection.add({
          'name': childName,
          'age': childAge,
          'allergies': childAllergies,
          'gender': childGender,
          'grade': childGrade,
          'height': childHeight,
          'imageUrl': childImageUrl,
          'medical condition': childMedicalCondition,
          'medications': childMedications,
          'p_phoneNo': childPPhoneNo,
          'relationship': childRelationship,
          'weight': childWeight,
          'p_email': email,
          'parent name': name,
          // Add more child data fields as needed
        });

        // Show success dialog
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('New parent and child added successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        // Clear input fields after success
        _emailController.clear();
        _passwordController.clear();
        _nameController.clear();
        _childNameController.clear();
        _childAgeController.clear();
        _childAllergiesController.clear();
        _childGenderController.clear();
        _childGradeController.clear();
        _childHeightController.clear();
        _childImageUrlController.clear();
        _childMedicalConditionController.clear();
        _childMedicationsController.clear();
        _childPPhoneNoController.clear();
        _childRelationshipController.clear();
        _childWeightController.clear();
      } catch (e) {
        // Show error dialog
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to add parent and child: $e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show error dialog for missing fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all fields correctly.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Parent and Child'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                labelText: 'Child Name',
                obscureText: false,
                controller: _childNameController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Grade',
                obscureText: false,
                controller: _childGradeController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Age',
                obscureText: false,
                controller: _childAgeController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Gender',
                obscureText: false,
                controller: _childGenderController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Height',
                obscureText: false,
                controller: _childHeightController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Weight',
                obscureText: false,
                controller: _childWeightController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Image URL',
                obscureText: false,
                controller: _childImageUrlController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Parent Name',
                obscureText: false,
                controller: _nameController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Relationship',
                obscureText: false,
                controller: _childRelationshipController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Parent Phone Number',
                obscureText: false,
                controller: _childPPhoneNoController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Parent Email',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Allergies',
                obscureText: false,
                controller: _childAllergiesController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Medical Condition',
                obscureText: false,
                controller: _childMedicalConditionController,
              ),
              const SizedBox(height: 20.0),
              MyTextField(
                labelText: 'Child Medications',
                obscureText: false,
                controller: _childMedicationsController,
              ),
              const SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addParent,
                    child: const Text('Add Parent'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
