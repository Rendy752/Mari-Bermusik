import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/component/profile_field.dart';
import 'package:mari_bermusik/component/top_navbar.dart';
import 'package:mari_bermusik/pages/login_register.dart';
import 'package:mari_bermusik/services/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void signIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginRegister()),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavbar(title: "Profile Page"),
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.orangeAccent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.orange,
                                width: 2,
                              ),
                              shape: BoxShape.circle),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/profile.png'),
                          ),
                        ),
                        if (isUserLoggedIn())
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.orange[100],
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
                          margin: const EdgeInsets.symmetric(vertical: 20.0),
                          child: const CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Map<String, dynamic> userProfile = snapshot.data!;
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Text(
                                'Joined since ${timeago.format(userProfile['created'])}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ProfileField(
                              fieldName: 'Name', content: userProfile['name']),
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: const CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int favoriteCount = snapshot.data!;
                                return ProfileField(
                                  fieldName: 'Favorite',
                                  content: favoriteCount.toString(),
                                );
                              }
                            },
                          ),
                          isUserLoggedIn()
                              ? TextButton(
                                  onPressed: signOut,
                                  child: const Text('Sign Out'))
                              : TextButton(
                                  onPressed: signIn,
                                  child: const Text('Sign In'))
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
