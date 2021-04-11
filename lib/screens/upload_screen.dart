import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/homescreen.dart';
import 'package:memeflix/responsive.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key, @required this.image}) : super(key: key);
  File image;
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  Random rng = new Random();
  uploadDataToFirebase(File file) async {
    print("object");
    var snapshot = await FirebaseStorage.instance
        .ref(FirebaseAuth.instance.currentUser.uid)
        .child("${FirebaseAuth.instance.currentUser.email}/${rng.nextInt(200)}")
        .putFile(file)
        .catchError((e) {
      print(e);
    });
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
    FirebaseFirestore.instance.collection("memes").add({
      'imageUrl': downloadUrl,
      'uploadedBy': FirebaseAuth.instance.currentUser.email
    });
    FirebaseFirestore.instance
        .collection("userDetails")
        .doc("userHistory")
        .collection(FirebaseAuth.instance.currentUser.email)
        .add({
      'imageUrl': downloadUrl,
      'uploadedBy': FirebaseAuth.instance.currentUser.email
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                'Meme Created Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Image.file(widget.image),
            ),
            Text(
              'Your meme has been saved to your gallery.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: themeGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  uploadDataToFirebase(widget.image);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text(
                  'Share to Public Feed',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text(
                  'Exit',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
