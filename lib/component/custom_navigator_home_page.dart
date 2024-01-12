import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mari_bermusik/component/home_screen.dart';
import 'package:mari_bermusik/pages/material.dart';
import 'package:mari_bermusik/pages/login_register.dart';

class CupertinoNavbar extends StatelessWidget {
  const CupertinoNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_chat_unread_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle_outlined),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeScreen(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                child: MaterialScreen(),
              );
            });
          case 4:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: LoginRegister(),
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeScreen(),
              );
            });
        }
      },
    );
  }
}
