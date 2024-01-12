import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavbar> {
  int selectedIndex = 0;
  List<IconData> data = [
    Icons.home,
    Icons.mark_chat_unread_outlined,
    Icons.menu_book_outlined,
    Icons.notifications_none,
    Icons.person_pin_circle_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        elevation: 10,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2.0, color: Colors.grey.shade500),
            ),
          ),
          height: 70,
          width: double.infinity,
          child: ListView.builder(
            itemCount: data.length,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 280),
                  width: 40,
                  decoration: BoxDecoration(
                    border: i == selectedIndex
                        ? Border(
                            top: BorderSide(width: 2.0, color: Colors.blue),
                          )
                        : null,
                  ),
                  child: Icon(
                    data[i],
                    size: 35,
                    color:
                        i == selectedIndex ? Colors.blue : Colors.grey.shade800,
                  ),
                ),
              ),
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
