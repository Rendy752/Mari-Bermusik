import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/component/entry_field.dart';
import 'package:mari_bermusik/component/loading.dart';
import 'package:mari_bermusik/component/top_navbar.dart';
import 'package:mari_bermusik/pages/profile_screen.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({Key? key}) : super(key: key);

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  String? errorMessage = '';
  bool isLogin = true;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      await Auth().signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.message;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading.value = false;
        });
      }
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading.value = true;
      });
      await Auth().createUserWithEmailAndPassword(
        name: _name.text,
        username: _username.text,
        email: _email.text,
        password: _password.text,
      );
      setState(() {
        errorMessage = '';
        isLogin = !isLogin;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  Widget buildLoadingWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, value, child) {
        if (value) {
          return const Loading();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        errorMessage == '' ? '' : '$errorMessage',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(
        isLogin ? 'Login' : 'Register',
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isLogin
              ? 'Don\'t have an account ? '
              : 'Already have an account ?'),
          TextButton(
            onPressed: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Text(isLogin ? 'Register' : 'Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavbar(title: isLogin ? 'Login' : 'Register'),
      body: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            color: Colors.orange[400],
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!isLogin) EntryField(title: 'Name', controller: _name),
                  if (!isLogin)
                    EntryField(title: 'Username', controller: _username),
                  EntryField(title: 'Email', controller: _email),
                  EntryField(title: 'Password', controller: _password),
                  _errorMessage(),
                  const SizedBox(height: 20),
                  _submitButton(),
                  _loginOrRegisterButton(),
                ],
              ),
            ),
          ),
          buildLoadingWidget()
        ],
      ),
    );
  }
}
