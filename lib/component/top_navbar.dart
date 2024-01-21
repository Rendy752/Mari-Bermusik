import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopNavbar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        textAlign: TextAlign.center, // center alignment
        style: const TextStyle(
          fontSize: 28, // increase font size
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            // text shadows
            Shadow(
              blurRadius: 10.0,
              color: Colors.black,
              offset: Offset(5.0, 5.0),
            ),
          ],
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent], // gradient colors
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      backgroundColor:
          Colors.transparent, // make it transparent to show the gradient
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
