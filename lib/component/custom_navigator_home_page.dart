import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mari_bermusik/component/home_screen.dart';
import 'package:mari_bermusik/pages/material.dart';
import 'package:mari_bermusik/pages/login_register.dart';
import 'package:mari_bermusik/pages/profile_screen.dart';

class CupertinoNavbar extends StatelessWidget {
  const CupertinoNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Material',
            tooltip: 'Material',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle_outlined),
            label: 'Profile',
            tooltip: 'Profile',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) => const HomeScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) => const MaterialScreen(),
            );
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) =>
                  FirebaseAuth.instance.currentUser != null
                      ? const ProfileScreen()
                      : const LoginRegister(),
            );
          default:
            return CupertinoTabView(
              builder: (BuildContext context) => const HomeScreen(),
            );
        }
      },
    );
  }
}
