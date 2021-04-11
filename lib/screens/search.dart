import 'package:flutter/material.dart';
import 'package:memeflix/model/images.dart';
import 'package:memeflix/model/search_model.dart';
import 'package:memeflix/responsive.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText;
  TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // child: Image.asset('assets/memeflix_header.png'),
            margin: EdgeInsets.only(top: 40, bottom: 35, left: 20),
            child: Text(
              'Meme Generator',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 50,
                  width: size.width - 120,
                  child: TextFormField(
                    controller: searchTextController,
                    onChanged: (value) {
                      this.searchText = value;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: 'Search By Movie',
                      // hintText: 'Search By Movie',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: themeGreen,
                      borderRadius: BorderRadius.circular(12)),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchMovie(searchText: searchText)),
                      );
                    },
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 5,
            thickness: 3,
          ),
          GetImages(),
        ],
      ),
    );
  }
}
