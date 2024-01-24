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

  void changeName(String defaultName) {
    TextEditingController nameController =
        TextEditingController(text: defaultName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text(
            'Change Name',
            style: TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Arial',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: "Enter your new name",
                    labelText: "New Name",
                    prefixIcon: const Icon(
                        Icons.drive_file_rename_outline_sharp,
                        color: Colors.grey),
                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    )),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
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
                    const SnackBar(
                      content: Text('Name cannot be empty.'),
                    ),
                  );
                }
              },
              child: const Text('Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arial',
                      fontWeight: FontWeight.bold)),
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
                        return Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            child: const CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            snapshot.error
                                .toString()
                                .replaceFirst('Exception:', ''),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        Map<String, dynamic> userProfile = snapshot.data!;
                        return Column(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text(
                                  'Joined since ${timeago.format(userProfile['created'])}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ProfileField(
                              fieldName: 'Name',
                              content: userProfile['name'],
                              onEditNamePressed: () =>
                                  changeName(userProfile['name']),
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
                                  return Container(
                                      margin: const EdgeInsets.only(top: 20.0),
                                      child: const CircularProgressIndicator());
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
