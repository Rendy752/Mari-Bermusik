import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference materials =
      FirebaseFirestore.instance.collection('material');

  // add material
  Future<void> addMaterial(String title, String instrument, String description,
      String sub, String content) {
    return materials.add({
      'title': title,
      'instrument': instrument,
      'description': description,
      'sub': sub,
      'content': content,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now()
    });
  }

  // get material
  Stream<QuerySnapshot> getMaterials() {
    final listMaterials =
        materials.orderBy('updated_at', descending: true).snapshots();
    return listMaterials;
  }

  // edit material
  Future<void> updateMaterial(String id, String newTitle, String newInstrument,
      String newDescription, String newSub, String newContent) {
    return materials.doc(id).update({
      'title': newTitle,
      'instrument': newInstrument,
      'description': newDescription,
      'sub': newSub,
      'content': newContent,
      'updated_at': Timestamp.now()
    });
  }

  // delete material
  Future<void> deleteMaterial(String id) {
    return materials.doc(id).delete();
  }
}
