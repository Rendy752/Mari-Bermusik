import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            const Text('Title'),
            TextField(
              controller: title,
            ),
            const Text('Instrument'),
            TextField(
              controller: instrument,
            ),
            const Text('Description'),
            TextField(
              controller: description,
            ),
            const Text('Sub'),
            TextField(
              controller: sub,
            ),
            const Text('Content'),
            TextField(
              controller: content,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (id == null) {
                firestoreServices.addMaterial(title.text, instrument.text,
                    description.text, sub.text, content.text);
                title.clear();
              } else {
                firestoreServices.updateMaterial(id, title.text,
                    instrument.text, description.text, sub.text, content.text);
                title.clear();
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
        elevation: 24.0,
        backgroundColor: Colors.deepOrange[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage')),
      floatingActionButton: FloatingActionButton(
        onPressed: openMaterialBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
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

                  return Column(
                    children: [
                      ListTile(
                        title: Text(title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => openMaterialBox(id: id),
                              icon: const Icon(Icons.settings),
                            ),
                            IconButton(
                              onPressed: () =>
                                  firestoreServices.deleteMaterial(id),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                      ListTile(title: Text(instrument)),
                      ListTile(title: Text(description)),
                      ListTile(title: Text(sub)),
                      ListTile(title: Text(content)),
                    ],
                  );
                });
          } else {
            return const Text('There are no material data');
          }
        },
      ),
    );
  }
}
