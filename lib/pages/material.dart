import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'package:mari_bermusik/services/firestore.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final FirestoreServices firestoreServices = FirestoreServices();
  final TextEditingController title = TextEditingController();
  final TextEditingController instrument = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController sub = TextEditingController();
  final TextEditingController content = TextEditingController();

  void openMaterialBox({String? id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            _buildTextField('Title', title),
            _buildTextField('Instrument', instrument),
            _buildTextField('Description', description),
            _buildTextField('Sub', sub),
            _buildTextField('Content', content),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (id == null) {
                firestoreServices.addMaterial(
                  title.text,
                  instrument.text,
                  description.text,
                  sub.text,
                  content.text,
                );
                title.clear();
              } else {
                firestoreServices.updateMaterial(
                  id,
                  title.text,
                  instrument.text,
                  description.text,
                  sub.text,
                  content.text,
                );
                title.clear();
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
        elevation: 24.0,
        backgroundColor: Colors.deepOrange[100],
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
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
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
          border: OutlineInputBorder(),
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
            if (snapshots.hasData) {
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
                        style: TextStyle(
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
                            onPressed: () => openMaterialBox(id: id),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () =>
                                firestoreServices.deleteMaterial(id),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'There are no material data',
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
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
