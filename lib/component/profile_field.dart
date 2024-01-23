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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                children: [
                  Icon(
                    getIconBasedOnFieldName(fieldName),
                    color: fieldName == 'Favorite'
                        ? Colors.redAccent
                        : Colors.orange,
                    size: 24.0,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    fieldName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
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
      ),
    );
  }
}
