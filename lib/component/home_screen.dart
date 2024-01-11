import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 130, // Ubah tinggi header menjadi 120
              child: ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(218, 192, 163, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Pindahkan ke sebelah kanan
                    children: [
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.start, // Teks diatur ke kanan
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "Stay ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "Hungry ",
                                style: TextStyle(color: Colors.green),
                              ),
                              TextSpan(
                                text: "Stay ",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "Foolish",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Judul Courses
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Courses",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Gambar di tengah dengan rasio 9:16
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 16 / 9,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/guitar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}

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
    return Material(
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 * size.width / 4, size.height - 40, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
