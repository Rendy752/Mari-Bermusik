import 'package:flutter/material.dart';

class TopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopNavbar({Key? key, required this.title}) : super(key: key);

  Widget _appBarTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black,
            offset: Offset(5.0, 5.0),
          ),
        ],
      ),
    );
  }

  Widget _appBarLogo() {
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      height: 32,
    );
  }

  Widget _appBarTitleWithLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _appBarLogo(),
        const SizedBox(
          width: 8,
        ),
        _appBarTitle(),
      ],
    );
  }

  Widget _boxDecoration() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: _appBarTitleWithLogo(),
      flexibleSpace: _boxDecoration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Center(
            child: SizedBox(
              width: 600,
              child: _appBar(),
            ),
          );
        } else {
          return _appBar();
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
