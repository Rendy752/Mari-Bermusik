import 'package:flutter/material.dart';
import 'package:mari_bermusik/pages/material.dart';
import 'package:mari_bermusik/pages/login_register.dart';
import './auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MaterialScreen();
        } else {
          return LoginRegister();
        }
      },
    );
  }
}
