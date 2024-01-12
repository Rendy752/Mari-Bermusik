import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mari_bermusik/widget_tree.dart';
import 'firebase_options.dart';
// import 'package:mari_bermusik/firebase_options.dart';
import 'package:mari_bermusik/pages/bottom_navbar.dart';
import 'package:mari_bermusik/pages/home.dart';
import 'package:mari_bermusik/component/bottom_navbar.dart';
import 'package:mari_bermusik/component/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
// void main() {
//   runApp(const MainApp());
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const WidgetTree(),
    );
  }
}
