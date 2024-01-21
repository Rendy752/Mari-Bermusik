import 'package:flutter/material.dart';
import 'package:mari_bermusik/pages/home_screen.dart';
import 'package:mari_bermusik/pages/material.dart';
import 'package:mari_bermusik/pages/profile_screen.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;
  final _pageController = PageController();
  final List<Widget> _pages = [
    const HomeScreen(),
    const MaterialScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[400]!.withOpacity(0.7),
        type: BottomNavigationBarType.shifting,
        elevation: 5,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            activeIcon: Icon(Icons.home, size: 35.0),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              size: 30.0,
            ),
            activeIcon: Icon(Icons.home, size: 35.0),
            label: 'Material',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            activeIcon: Icon(Icons.home, size: 35.0),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
