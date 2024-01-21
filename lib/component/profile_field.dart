import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String fieldName;
  final String content;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  ProfileField({
    super.key,
    required this.fieldName,
    required this.content,
  });

  IconData getIconBasedOnFieldName(String fieldName) {
    switch (fieldName) {
      case 'Email':
        return Icons.email;
      case 'Favorite':
        return Icons.favorite;
      default:
        return Icons.text_fields_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey),
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Row(
              children: [
                Icon(
                  getIconBasedOnFieldName(fieldName),
                  color: fieldName == 'Favorite'
                      ? Colors.redAccent
                      : Colors.orange,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  fieldName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(
              child: Text(
            ': $content',
            style: const TextStyle(fontSize: 18),
          )),
          if (isUserLoggedIn() && fieldName == 'Name')
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}
