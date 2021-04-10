import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemeFlix',
      theme: ThemeData(),
      home: CreateAccount(),
    );
  }
}
