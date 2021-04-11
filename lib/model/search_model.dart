import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:memeflix/model/showSearchMovies.dart';

class SearchMovie extends StatefulWidget {
  String searchText;
  SearchMovie({Key key, @required this.searchText}) : super(key: key);
  @override
  _SearchMovieState createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {
  @override
  void initState() {
    super.initState();
    futureMovies = searchMovie();
  }

  String movieTitle;
  int movieId;

  Future<List<dynamic>> futureMovies;
  String _title(dynamic user) {
    return user['original_title'];
  }

  String _poster(dynamic user) {
    return user['poster_path'];
  }

  String _releaseDate(dynamic user) {
    return user['release_date'];
  }

  int _movieId(dynamic user) {
    return user['id'];
  }

  Future<List<dynamic>> searchMovie() async {
    final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/search/movie?api_key=f4ae53d60330375a486028e73667c90c&language=en-US&query=${widget.searchText}&page=1&include_adult=false'),
        headers: {
          HttpHeaders.authorizationHeader: "f4ae53d60330375a486028e73667c90c"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body)['results'];
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results For: ${widget.searchText}"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              margin: EdgeInsets.only(left: 24, top: 24),
              child: Text(
                'Select a movie:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<dynamic>>(
                future: futureMovies,
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
                                  this.movieTitle =
                                      _title(snapshot.data[index]);
                                  this.movieId = _movieId(snapshot.data[index]);
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowSearchMovieIMages(
                                              movieTitle: movieTitle,
                                              movieId: movieId)),
                                );
                              },
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(8),
                                      // color: Colors.white,
                                      height: 500,
                                      width: size.width,
                                      child: Wrap(
                                        children: [
                                          Container(
                                              // margin: EdgeInsets.all(8),
                                              height: 450,
                                              width: size.width - 50,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://www.themoviedb.org/t/p/original${_poster(snapshot.data[index])}"),
                                                    fit: BoxFit.cover),
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                                "${_title(snapshot.data[index])}(${_releaseDate(snapshot.data[index])}) "),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ]));
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }
}
