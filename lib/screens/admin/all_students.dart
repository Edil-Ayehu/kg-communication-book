import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllStudents extends StatefulWidget {
  const AllStudents({Key? key}) : super(key: key);

  @override
  _AllStudentsState createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
      ),
      body: FutureBuilder(
        future: fetchParentData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No parent data found.'));
          } else {
            // Sort the data based on child name
            snapshot.data!.sort((a, b) => a['child_name'].compareTo(b['child_name']));
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Gender')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Grade')),
                  DataColumn(label: Text('Height(m)')),
                  DataColumn(label: Text('Weight(kg)')),
                  DataColumn(label: Text('Allergies')),
                  DataColumn(label: Text('Medical Condition')),
                  DataColumn(label: Text('Medications')),
                  DataColumn(label: Text('Parent Name')),
                  DataColumn(label: Text('Parent Phone NO')),
                  DataColumn(label: Text('Parent Email')),
                  DataColumn(label: Text('Relationship')),
                  DataColumn(label: Text('Actions')), // New column for actions
                ],
                rows: snapshot.data!.map<DataRow>((parentData) {
                  return DataRow(cells: [
                    DataCell(Text(parentData['child_name'])),
                    DataCell(Text(parentData['child_gender'])),
                    DataCell(Text(parentData['child_age'].toString())),
                    DataCell(Text(parentData['grade'])),
                    DataCell(Text(parentData['height'])),
                    DataCell(Text(parentData['weight'])),
                    DataCell(Text(parentData['allergies'])),
                    DataCell(Text(parentData['medical_condition'])),
                    DataCell(Text(parentData['medications'])),
                    DataCell(Text(parentData['parent_name'])),
                    DataCell(Text(parentData['parent_phoneNo'])),
                    DataCell(Text(parentData['parent_email'])),
                    DataCell(Text(parentData['relationship'])),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editStudent(parentData),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteStudent(
                            context,
                            parentData['parent_id'],
                            parentData['child_id'],
                            parentData['parent_email'],
                            parentData['child_name'],
                          ),
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchParentData() async {
    try {
      QuerySnapshot parentQuerySnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .where('role', isEqualTo: 'parent')
          .get();

      List<Map<String, dynamic>> parentDataList = [];

      for (QueryDocumentSnapshot parentDocument in parentQuerySnapshot.docs) {
        QuerySnapshot childQuerySnapshot = await parentDocument.reference.collection('child').get();

        for (QueryDocumentSnapshot childDocument in childQuerySnapshot.docs) {
          Map<String, dynamic> parentData = {
            'parent_id': parentDocument.id,
            'child_id': childDocument.id,
            'parent_email': parentDocument['email'],
            'parent_name': childDocument['parent name'],
            'child_name': childDocument['name'],
            'child_gender': childDocument['gender'],
            'child_age': childDocument['age'],
            'grade': childDocument['grade'],
            'height': childDocument['height'],
            'weight': childDocument['weight'],
            'allergies': childDocument['allergies'],
            'medical_condition': childDocument['medical condition'],
            'medications': childDocument['medications'],
            'parent_phoneNo': childDocument['p_phoneNo'],
            'relationship': childDocument['relationship'],
          };
          parentDataList.add(parentData);
        }
      }

      return parentDataList;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteStudent(BuildContext context, String parentId, String childId, String parentEmail, String childName) async {
    try {
      // Delete child document from Firestore
      await FirebaseFirestore.instance.collection('parents').doc(parentId).collection('child').doc(childId).delete();

      // Delete parent document from Firestore if it has no more children
      QuerySnapshot childrenSnapshot = await FirebaseFirestore.instance.collection('parents').doc(parentId).collection('child').get();
      if (childrenSnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('parents').doc(parentId).delete();
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student data deleted successfully')),
      );

      // Update UI by triggering a rebuild
      setState(() {});
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete student data: $e')),
      );
    }
  }

  Future<void> _editStudent(Map<String, dynamic> studentData) async {
    TextEditingController nameController = TextEditingController(text: studentData['child_name']);
    TextEditingController genderController = TextEditingController(text: studentData['child_gender']);
    TextEditingController ageController = TextEditingController(text: studentData['child_age'].toString());
    TextEditingController gradeController = TextEditingController(text: studentData['grade']);
    TextEditingController heightController = TextEditingController(text: studentData['height']);
    TextEditingController weightController = TextEditingController(text: studentData['weight']);
    TextEditingController allergiesController = TextEditingController(text: studentData['allergies']);
    TextEditingController medicalConditionController = TextEditingController(text: studentData['medical_condition']);
    TextEditingController medicationsController = TextEditingController(text: studentData['medications']);
    TextEditingController parentNameController = TextEditingController(text: studentData['parent_name']);
    TextEditingController parentPhoneController = TextEditingController(text: studentData['parent_phoneNo']);
    TextEditingController parentEmailController = TextEditingController(text: studentData['parent_email']);
    TextEditingController relationshipController = TextEditingController(text: studentData['relationship']);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Name', nameController),
                _buildTextField('Gender', genderController),
                _buildTextField('Age', ageController),
                _buildTextField('Grade', gradeController),
                _buildTextField('Height', heightController),
                _buildTextField('Weight', weightController),
                _buildTextField('Allergies', allergiesController),
                _buildTextField('Medical Condition', medicalConditionController),
                _buildTextField('Medications', medicationsController),
                _buildTextField('Parent Name', parentNameController),
                _buildTextField('Parent Phone NO', parentPhoneController),
                _buildTextField('Parent Email', parentEmailController),
                _buildTextField('Relationship', relationshipController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('parents')
                      .doc(studentData['parent_id'])
                      .collection('child')
                      .doc(studentData['child_id'])
                      .update({
                    'name': nameController.text,
                    'gender': genderController.text,
                    'age': int.parse(ageController.text),
                    'grade': gradeController.text,
                    'height': heightController.text,
                    'weight': weightController.text,
                    'allergies': allergiesController.text,
                    'medical condition': medicalConditionController.text,
                    'medications': medicationsController.text,
                    'parent name': parentNameController.text,
                    'p_phoneNo': parentPhoneController.text,
                    'p_email': parentEmailController.text,
                    'relationship': relationshipController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student data updated successfully')),
                  );

                  // Update UI by triggering a rebuild
                  setState(() {});

                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update student data: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
