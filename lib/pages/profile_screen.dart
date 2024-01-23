import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:mari_bermusik/component/profile_field.dart';
import 'package:mari_bermusik/component/top_navbar.dart';
import 'package:mari_bermusik/pages/login_register.dart';
import 'package:mari_bermusik/services/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final favoriteController = TextEditingController();

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void refresh() {
    setState(() {});
  }

  void signIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginRegister()),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    refresh();
  }

  void changeName() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter your new name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                String newName = nameController.text;
                if (newName.isNotEmpty) {
                  FirestoreServices()
                      .updateUserProfile(
                    FirebaseAuth.instance.currentUser!.uid,
                    newName,
                    null,
                    null,
                    null,
                  )
                      .then((_) {
                    print('User profile updated successfully.');
                    Navigator.of(context).pop();
                    refresh();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update profile: $error'),
                      ),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Name cannot be empty.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavbar(title: "Profile Page"),
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        backgroundColor: Colors.blueAccent,
        tooltip: 'Refresh',
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('assets/images/profile.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: Auth().getUserProfile(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}',
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold));
                      } else {
                        Map<String, dynamic> userProfile = snapshot.data!;
                        return Column(
                          children: [
                            ProfileField(
                              fieldName: 'Name',
                              content: userProfile['name'],
                              onEditNamePressed: changeName,
                            ),
                            ProfileField(
                                fieldName: 'Email',
                                content: userProfile['email']),
                            ProfileField(
                                fieldName: 'Username',
                                content: userProfile['username']),
                            FutureBuilder<int>(
                              future: FirestoreServices()
                                  .getFavoriteMaterialCount(
                                      FirebaseAuth.instance.currentUser!.uid),
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int favoriteCount = snapshot.data!;
                                  return ProfileField(
                                      fieldName: 'Favorite',
                                      content: favoriteCount.toString());
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: isUserLoggedIn()
                        ? ElevatedButton(
                            onPressed: signOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shadowColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Sign Out',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          )
                        : ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shadowColor: Colors.black,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Sign In',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
