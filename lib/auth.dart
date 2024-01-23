import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(
      {required String name,
      required String username,
      required String email,
      required String password}) async {
    var usernameQuery = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (usernameQuery.docs.isNotEmpty) {
      throw Exception('Username already taken');
    }

    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'username': username,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile =
          await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic>? userData =
          userProfile.data() as Map<String, dynamic>?;
      return {
        'email': user.email,
        'created': user.metadata.creationTime,
        if (userData != null) ...userData,
      };
    } else {
      throw Exception('User not logged in, please login first');
    }
  }
}
