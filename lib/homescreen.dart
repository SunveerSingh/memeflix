import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:memeflix/responsive.dart';
import 'package:memeflix/screens/feed.dart';
import 'package:memeflix/screens/search.dart';
import 'package:memeflix/screens/your_memes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final screens = [FeedPage(), SearchPage(), YourMemes()];
  final titles = {
    0: 'Public Feed',
    1: 'Meme Generator',
    2: 'Your Memes'
  };
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(titles[_page]),
      //   backgroundColor: themeGreen,
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        animationDuration: Duration(milliseconds: 200),
        color: themeGreen,
        height: 50,
        backgroundColor: Colors.transparent,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: SafeArea(
        child: screens[_page],
      ),
    );
  }
}
