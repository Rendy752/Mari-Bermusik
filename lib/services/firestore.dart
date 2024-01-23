import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference materials =
      FirebaseFirestore.instance.collection('material');
  final CollectionReference favoriteMaterials =
      FirebaseFirestore.instance.collection('favorite_material');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

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
  Stream<QuerySnapshot> getFavoriteMaterials(String userId) {
    return favoriteMaterials.where('user_id', isEqualTo: userId).snapshots();
  }

  // check if material is favorite
  Future<bool> isMaterialFavorite(String userId, String materialId) async {
    final querySnapshot = await favoriteMaterials
        .where('user_id', isEqualTo: userId)
        .where('material_id', isEqualTo: materialId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // get favorite materials length based on user id
  Future<int> getFavoriteMaterialCount(String userId) async {
    final querySnapshot =
        await favoriteMaterials.where('user_id', isEqualTo: userId).get();

    return querySnapshot.docs.length;
  }

  // Update user profile
  Future<void> updateUserProfile(
    String userId,
    String newName,
    String? email,
    String? username,
    int? favorite,
  ) {
    Map<String, dynamic> updates = {};
    if (newName.isNotEmpty) updates['name'] = newName;
    if (email != null && email.isNotEmpty) updates['email'] = email;
    if (username != null && username.isNotEmpty) updates['username'] = username;
    // if (favorite != null) updates['favorite'] = favorite;

    if (updates.isNotEmpty) {
      return users.doc(userId).update(updates).then((_) {
        print('User profile updated successfully.');
      }).catchError((error) {
        print('Error updating user profile: $error');
        throw error;
      });
    } else {
      print('No changes to update.');
      return Future.error('No changes to update.');
    }
  }
}
