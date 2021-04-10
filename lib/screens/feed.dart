import 'package:cloud_firestore/cloud_firestore.dart';
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
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.hasData) {
          return new GridView.count(
            crossAxisCount: getAxisCount(),
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: InkResponse(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                            height: 250,
                            width: 350,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      NetworkImage(document.data()['imageUrl']),
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Uploaded By: ${document.data()['uploadedBy']}",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16),
                        ),
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
        body: SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Image.asset('assets/memeflix_header.png'),
          ),
          getMemesList(),
        ],
      ),
    ));
  }
}
