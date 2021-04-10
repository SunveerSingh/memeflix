import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/homescreen.dart';
import 'package:memeflix/main.dart';
import 'package:memeflix/screens/auth/login.dart';

class AuthServices {
  handAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginPage();
        }
      },
    );
  }

  singIn(context, email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sucess')));
    });
  }

  singUp(context, email, password) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Sucess')));
    });
  }

  signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }
}
