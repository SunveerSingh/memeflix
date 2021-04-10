import 'package:flutter/material.dart';
import 'package:memeflix/homescreen.dart';

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
      home: HomeScreen(),
    );
  }
}
