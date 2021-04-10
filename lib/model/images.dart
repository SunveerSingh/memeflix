import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:memeflix/screens/meme_editor.dart';

class GetImages extends StatefulWidget {
  @override
  _GetImagesState createState() => _GetImagesState();
}

class _GetImagesState extends State<GetImages> {
  @override
  void initState() {
    super.initState();
    futureImages = fecthImages();
  }

  String imageURL;
  Future<List<dynamic>> futureImages;

  String _filepath(dynamic user) {
    return user['file_path'];
  }

  Future<List<dynamic>> fecthImages() async {
    final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/550/images?api_key=f4ae53d60330375a486028e73667c90c'),
        headers: {
          HttpHeaders.authorizationHeader: "f4ae53d60330375a486028e73667c90c"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body)['backdrops'];
    }
    if (response.statusCode != 200) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('http.get error: statusCode= ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<dynamic>>(
        future: futureImages,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkResponse(
                      onTap: () {
                        setState(() {
                          this.imageURL =
                              "https://www.themoviedb.org/t/p/original${_filepath(snapshot.data[index])}";
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MemeEditor(imageLink: this.imageURL)),
                        );
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                  margin: EdgeInsets.all(8),
                                  height: 196,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://www.themoviedb.org/t/p/original${_filepath(snapshot.data[index])}"),
                                        fit: BoxFit.cover),
                                  )),
                            )
                          ]));
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
