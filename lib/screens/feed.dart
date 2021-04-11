import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memeflix/responsive.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final CollectionReference memesList =
      FirebaseFirestore.instance.collection("memes");

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
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 40),
                child: InkResponse(
                  onTap: () {},
                  child: Image.network(
                    document.data()['imageUrl'],
                    loadingBuilder: (context, child, loadingProgress) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            child: Container(
                              constraints: BoxConstraints(minHeight: 250),
                              child: child
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, left: 5.0),
                            child: Text(
                              "Uploaded By: ${document.data()['uploadedBy']}",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    },
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        // padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // child: Image.asset('assets/memeflix_header.png'),
              margin: EdgeInsets.only(top: 40, bottom: 35, left: 20),
              child: Text(
                'Public Feed',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            getMemesList(),
          ],
        ),
      ),
    );
  }
}
