import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference materials =
      FirebaseFirestore.instance.collection('material');
  final CollectionReference favoriteMaterials =
      FirebaseFirestore.instance.collection('favorite_material');

  // add material
  Future<void> addMaterial(String uid, String title, String instrument,
      String description, String sub, String content) {
    String id = materials.doc().id;
    return materials.add({
      'id': id,
      'user_id': uid,
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

  // get material by id
  Future<DocumentSnapshot> getMaterialById(String id) {
    return materials.doc(id).get();
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

  // add material favorite
  Future<void> addFavoriteMaterial(String userId, String materialId) {
    return favoriteMaterials.add({
      'user_id': userId,
      'material_id': materialId,
      'created_at': Timestamp.now(),
    });
  }

  // delete material favorite
  Future<void> removeFavoriteMaterial(String userId, String materialId) {
    return favoriteMaterials
        .where('user_id', isEqualTo: userId)
        .where('material_id', isEqualTo: materialId)
        .get()
        .then((querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    });
  }

  // get favorite materials based on user id
  Future<QuerySnapshot> getFavoriteMaterials(String userId) {
    return favoriteMaterials.where('user_id', isEqualTo: userId).get();
  }
}
