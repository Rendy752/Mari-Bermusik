import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mari_bermusik/component/entry_field.dart';
import 'package:mari_bermusik/component/loading.dart';
import 'package:mari_bermusik/component/material_card.dart';
import '../auth.dart';
import 'package:mari_bermusik/services/firestore.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({Key? key}) : super(key: key);

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  final FirestoreServices firestoreServices = FirestoreServices();
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Widget buildLoadingWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, value, child) {
        if (value) {
          return const Loading();
        } else {
          return Container();
        }
      },
    );
  }

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
        titlePadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Icon(id == null ? Icons.add_circle : Icons.edit,
                color: Colors.blueAccent),
            const SizedBox(width: 10),
            Text(
              id == null ? 'Add Material' : 'Edit Material',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              EntryField(title: 'Title', controller: titleController),
              EntryField(title: 'Instrument', controller: instrumentController),
              EntryField(
                  title: 'Description', controller: descriptionController),
              EntryField(title: 'Sub', controller: subController),
              EntryField(title: 'Content', controller: contentController),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shadowColor: Colors.grey,
              elevation: 5,
            ),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              BuildContext dialogContext = context;
              try {
                setState(() {
                  isLoading.value = true;
                });
                if (id == null) {
                  await firestoreServices.addMaterial(
                    Auth().currentUser!.uid,
                    titleController.text,
                    instrumentController.text,
                    descriptionController.text,
                    subController.text,
                    contentController.text,
                  );
                } else {
                  await firestoreServices.updateMaterial(
                    id,
                    titleController.text,
                    instrumentController.text,
                    descriptionController.text,
                    subController.text,
                    contentController.text,
                  );
                }
                Navigator.pop(dialogContext);
              } catch (e) {
                print('Failed to add or update material: $e');
              } finally {
                setState(() {
                  isLoading.value = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shadowColor: Colors.blue,
              elevation: 5,
            ),
            child: const Text('Save',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold)),
          ),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
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
        titlePadding: const EdgeInsets.all(20),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(
              'Delete Confirmation',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Arial',
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Are you sure you want to delete material with title '$title'?",
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontFamily: 'Arial',
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              shadowColor: Colors.grey,
              elevation: 5,
            ),
            child: const Text('No',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                )),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                setState(() {
                  isLoading.value = true;
                });
                await firestoreServices.deleteMaterial(id);
              } catch (e) {
                print('Failed to delete material: $e');
              } finally {
                setState(() {
                  isLoading.value = false;
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shadowColor: Colors.red,
              elevation: 5,
            ),
            child: const Text('Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(15.0),
        ),
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
        backgroundColor: Colors.blueAccent,
        tooltip: 'Add Item',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 70.0,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
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
                      String userId = data['user_id'];
                      String title = data['title'];
                      String instrument = data['instrument'];
                      String description = data['description'];
                      String sub = data['sub'];
                      String content = data['content'];

                      return MaterialCard(
                          id: id,
                          userId: userId,
                          title: title,
                          instrument: instrument,
                          description: description,
                          sub: sub,
                          content: content,
                          openMaterialBoxCallback: openMaterialBox,
                          openDeleteConfirmationBoxCallback:
                              openDeleteConfirmationBox);
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
          buildLoadingWidget()
        ],
      ),
    );
  }
}
