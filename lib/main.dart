import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mari_bermusik/firebase_options.dart';
import 'package:mari_bermusik/pages/home.dart';
import 'package:mari_bermusik/component/bottom_navbar.dart';
import 'package:mari_bermusik/component/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // debugShowCheckedModeBanner: false, home: HomePage());
        debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
