import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black
          .withOpacity(0.5), // Change this value to adjust the opacity
      child: const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }
}
