import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/screens/auth/auth_services.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthServices().handAuth();
  }
}
