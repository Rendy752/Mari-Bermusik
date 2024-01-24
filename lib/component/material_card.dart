import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mari_bermusik/services/firestore.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeago;

class MaterialCard extends StatefulWidget {
  final String id;
  final String userId;
  final String title;
  final String instrument;
  final String description;
  final String sub;
  final String content;
  final Timestamp updatedAt;
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
    required this.updatedAt,
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

  Widget _materialTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.blue, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: SizedBox(
        height: 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
      ),
    );
  }

  Widget _materialUpdatedAt() {
    return Text(
      '~ Updated ${timeago.format(widget.updatedAt.toDate())}',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'Pacifico',
      ),
    );
  }

  Widget _materialDescription() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 50,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  letterSpacing: 0.5,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _materialPicture() {
    return Stack(
      children: [
        Container(
          height: 170.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getInstrumentImage(widget.instrument)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              widget.instrument.isEmpty
                  ? 'Unknown'
                  : widget.instrument[0].toUpperCase() +
                      widget.instrument.substring(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.pink : Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _materialCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.orange[400],
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[200]!, Colors.orange[600]!],
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: _materialPicture(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _materialTitle(),
                      _materialUpdatedAt(),
                      _actionButton(),
                      Expanded(child: _materialDescription()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _materialCard();
  }
}
