import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/auth.dart';
import 'package:flutter/material.dart';
import 'package:mari_bermusik/component/entry_field.dart';
import 'package:mari_bermusik/component/loading.dart';
import 'package:mari_bermusik/component/top_navbar.dart';

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
        Navigator.pop(context);
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
      if (_name.text.isEmpty) {
        setState(() {
          errorMessage = 'Name cannot be empty';
        });
        return;
      }
      if (_username.text.isEmpty) {
        setState(() {
          errorMessage = 'Username cannot be empty';
        });
        return;
      }
      if (_email.text.isEmpty) {
        setState(() {
          errorMessage = 'Email cannot be empty';
        });
        return;
      }
      if (_password.text.isEmpty) {
        setState(() {
          errorMessage = 'Password cannot be empty';
        });
        return;
      }
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

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      alignment: Alignment.center,
      child: Text(
        isLogin ? 'Login to your account' : 'Create a new account',
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
      ),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(
          isLogin ? 'Login' : 'Register',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
            errorMessage = '';
          });
        },
        child: Text(
          isLogin
              ? 'Don\'t have an account ? Register'
              : 'Already have an account ? Login',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> images = [
    "musicalInstrument",
    "clarinet1",
    "drums1",
    "flute1",
    "guitar1",
    "piano1",
    "violin1",
  ];

  Widget _background() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/images/${images[Random().nextInt(images.length)]}.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8), BlendMode.dstATop),
        ),
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          if (!isLogin) EntryField(title: 'Name', controller: _name),
          if (!isLogin) EntryField(title: 'Username', controller: _username),
          EntryField(
            title: 'Email',
            controller: _email,
          ),
          EntryField(
            title: 'Password',
            controller: _password,
          ),
          _errorMessage(),
          _submitButton(),
          _loginOrRegisterButton(),
        ],
      ),
    );
  }

  Widget _loginRegisterForm() {
    return Stack(
      children: [
        _background(),
        buildLoadingWidget(),
        SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              _form(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: TopNavbar(title: isLogin ? 'Login' : 'Register'),
          body: constraints.maxWidth > 600
              ? Center(
                  child: Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _loginRegisterForm(),
                  ),
                )
              : _loginRegisterForm(),
        );
      },
    );
  }
}
