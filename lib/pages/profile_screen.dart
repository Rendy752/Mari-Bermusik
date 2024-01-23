import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/services/firestore.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:mari_bermusik/pages/login_register.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final favoriteController = TextEditingController();

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    favoriteController.dispose();
    super.dispose();
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

  void saveProfile() async {
    String newName = nameController.text;
    String newEmail = emailController.text;
    String newUsername = usernameController.text;
    String newFavorite = favoriteController.text;

    await FirestoreServices().updateUserProfile(
      currentUserId!,
      newName,
      newEmail,
      newUsername,
      newFavorite,
    );
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.refresh, color: Colors.white),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: Auth().getUserProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        Map<String, dynamic> userProfile = snapshot.data!;
                        nameController.text = userProfile['name'];
                        emailController.text = userProfile['email'];
                        usernameController.text = userProfile['username'];
                        favoriteController.text =
                            userProfile['favorite'].toString();
                        return Column(
                          children: [
                            Text(
                              'Joined since ${timeago.format(userProfile['created'])}',
                            ),
                            TextFormField(
                              controller: nameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: usernameController,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                            ),
                            TextFormField(
                              controller: favoriteController,
                              decoration:
                                  const InputDecoration(labelText: 'Favorite'),
                              keyboardType: TextInputType.number,
                            ),
                            ElevatedButton(
                              onPressed: saveProfile,
                              child: const Text('Save Profile'),
                            ),
                          ],
                        );
                      } else {
                        return const Text('No user profile found.');
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Sign Out',
                                style: TextStyle(fontSize: 20)),
                          )
                        : ElevatedButton(
                            onPressed: signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Sign In',
                                style: TextStyle(fontSize: 20)),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
