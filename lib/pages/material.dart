import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../auth.dart';
import 'package:mari_bermusik/services/firestore.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final FirestoreServices firestoreServices = FirestoreServices();

  void openMaterialBox(
      {String? id,
      String? title,
      String? description,
      String? instrument,
      String? sub,
      String? content}) {
    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController instrumentController =
        TextEditingController(text: instrument);
    final TextEditingController descriptionController =
        TextEditingController(text: description);
    final TextEditingController subController =
        TextEditingController(text: sub);
    final TextEditingController contentController =
        TextEditingController(text: content);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(id == null ? 'Add Material' : 'Edit Material'),
        content: Column(
          children: [
            _buildTextField('Title', titleController),
            _buildTextField('Instrument', instrumentController),
            _buildTextField('Description', descriptionController),
            _buildTextField('Sub', subController),
            _buildTextField('Content', contentController),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (id == null) {
                firestoreServices.addMaterial(
                  titleController.text,
                  instrumentController.text,
                  descriptionController.text,
                  subController.text,
                  contentController.text,
                );
              } else {
                firestoreServices.updateMaterial(
                  id,
                  titleController.text,
                  instrumentController.text,
                  descriptionController.text,
                  subController.text,
                  contentController.text,
                );
              }
              Navigator.pop(context);
            },
            child: Text(id == null ? 'Add' : 'Update'),
          )
        ],
        elevation: 24.0,
        contentPadding: const EdgeInsets.all(30.0),
        backgroundColor: Colors.orange[200],
      ),
    );
  }

  void openDeleteConfirmationBox({
    required String id,
    String? title,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content:
            Text("Are you sure wan't to delete material with title '$title'"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              firestoreServices.deleteMaterial(id);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          )
        ],
        elevation: 24.0,
        contentPadding: const EdgeInsets.all(30.0),
        backgroundColor: Colors.orange[200],
      ),
    );
  }

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text(
      'Material Page',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _userId() {
    return Text(
      user?.email ?? 'Anonymous',
      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        actions: <Widget>[
          _userId(),
          _signOutButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openMaterialBox(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 70.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestoreServices.getMaterials(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: LoadingAnimationWidget.inkDrop(
                    color: Colors.orange,
                    size: 200,
                  ),
                ),
              );
            } else if (snapshots.hasData) {
              List listMaterials = snapshots.data!.docs;
              return ListView.builder(
                itemCount: listMaterials.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = listMaterials[index];
                  String id = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String title = data['title'];
                  String instrument = data['instrument'];
                  String description = data['description'];
                  String sub = data['sub'];
                  String content = data['content'];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSubtitleText('Instrument: $instrument'),
                          _buildSubtitleText('Description: $description'),
                          _buildSubtitleText('Sub: $sub'),
                          _buildSubtitleText('Content: $content'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openMaterialBox(
                                id: id,
                                title: title,
                                instrument: instrument,
                                description: description,
                                sub: sub,
                                content: content),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                openDeleteConfirmationBox(id: id, title: title),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (!snapshots.hasData) {
              return const Center(
                child: Text(
                  'Sorry, There Are No Material Data',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Something Went Wrong',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSubtitleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
