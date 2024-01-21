import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/services/firestore.dart';
import 'dart:math';

class MaterialCard extends StatefulWidget {
  final String id;
  final String userId;
  final String title;
  final String instrument;
  final String description;
  final String sub;
  final String content;
  final Function openMaterialBoxCallback;
  final Function openDeleteConfirmationBoxCallback;

  const MaterialCard({
    super.key,
    required this.id,
    required this.userId,
    required this.title,
    required this.instrument,
    required this.description,
    required this.sub,
    required this.content,
    required this.openMaterialBoxCallback,
    required this.openDeleteConfirmationBoxCallback,
  });

  @override
  MaterialCardState createState() => MaterialCardState();
}

class MaterialCardState extends State<MaterialCard> {
  final FirestoreServices firestoreServices = FirestoreServices();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  bool isFavorite = false;
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    if (currentUserId != null) {
      final favoriteStatus =
          await firestoreServices.isMaterialFavorite(currentUserId!, widget.id);
      if (mounted) {
        setState(() {
          isFavorite = favoriteStatus;
        });
      }
    }
  }

  String getInstrumentImage(instrument) {
    if (instrument != 'guitar' &&
        instrument != 'piano' &&
        instrument != 'drums' &&
        instrument != 'violin' &&
        instrument != 'flute' &&
        instrument != 'clarinet') return 'assets/images/questionMark.jpg';
    List<String> postfixes = ['1', '2'];
    Random random = Random();
    String postfix = postfixes[random.nextInt(postfixes.length)];
    return 'assets/images/${instrument.toLowerCase()}$postfix.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[400],
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              image: AssetImage(getInstrumentImage(widget.instrument)),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ),
              Row(
                children: [
                  if (isUserLoggedIn() && widget.userId == currentUserId)
                    Tooltip(
                      message: 'Edit ${widget.title}',
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => widget.openMaterialBoxCallback(
                              id: widget.id,
                              title: widget.title,
                              instrument: widget.instrument,
                              description: widget.description,
                              sub: widget.sub,
                              content: widget.content),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.edit, color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ),
                  if (isUserLoggedIn() && widget.userId == currentUserId)
                    Tooltip(
                      message: 'Delete ${widget.title}',
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () => widget.openDeleteConfirmationBoxCallback(
                              id: widget.id, title: widget.title),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10.0),
                  if (isUserLoggedIn())
                    Tooltip(
                      message: 'Add Favorite ${widget.title}',
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                            if (isFavorite) {
                              firestoreServices.addFavoriteMaterial(
                                  currentUserId!, widget.id);
                            } else {
                              firestoreServices.removeFavoriteMaterial(
                                  currentUserId!, widget.id);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.pink : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Description \n',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontFamily: 'Roboto',
                        ),
                      ),
                      WidgetSpan(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.blue, Colors.purple],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds),
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
