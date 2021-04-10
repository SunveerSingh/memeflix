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
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.hasData) {
          return new GridView.count(
            physics: ScrollPhysics(),
            crossAxisCount: getAxisCount(),
            shrinkWrap: true,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return Container(
                margin: EdgeInsets.all(20),
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
