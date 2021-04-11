import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/responsive.dart';
import 'package:memeflix/screens/auth/auth_services.dart';

class YourMemes extends StatefulWidget {
  @override
  _YourMemesState createState() => _YourMemesState();
}

class _YourMemesState extends State<YourMemes> {
  final CollectionReference memesList = FirebaseFirestore.instance
      .collection("userDetails")
      .doc("userHistory")
      .collection(FirebaseAuth.instance.currentUser.email);
  getAxisCount() {
    if (isMobile(context)) {
      return 1;
    }
    if (isTab(context)) {
      return 2;
    }
    if (isDesktop(context)) {
      return 4;
    }
  }

  getMemesList() {
    //returns restaurant list for public view
    return StreamBuilder<QuerySnapshot>(
      stream: memesList.snapshots(),
      // ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.hasData) {
          return new ListView(
            physics: ScrollPhysics(),
            // crossAxisCount: getAxisCount(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 25),
                child: InkResponse(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: Image.network(document.data()['imageUrl']),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          backgroundColor: themeGreen,
          onPressed: () {
            AuthServices().signOut(context);
          },
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // child: Image.asset('assets/memeflix_header.png'),
                margin: EdgeInsets.only(top: 40, bottom: 35, left: 20),
                child: Text(
                  'My Memes',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              getMemesList(),
            ],
          ),
        ));
  }
}
