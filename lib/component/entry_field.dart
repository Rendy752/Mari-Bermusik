import 'package:flutter/material.dart';

class EntryField extends StatefulWidget {
  final String title;
  final TextEditingController controller;

  const EntryField({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  EntryFieldState createState() => EntryFieldState();
}

class EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: widget.controller,
        cursorColor: Colors.blue[400],
        style: const TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.title == 'Email'
                ? Icons.email
                : widget.title == 'Password'
                    ? Icons.lock
                    : Icons.text_fields,
            color: Colors.grey[600],
          ),
          labelText: widget.title,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Enter your ${widget.title}',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.blue[400]!),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
