import 'package:flutter/material.dart';

class MemeEditor extends StatefulWidget {
  String imageLink;
  MemeEditor({Key key, @required this.imageLink}) : super(key: key);
  @override
  _MemeEditorState createState() => _MemeEditorState();
}

class _MemeEditorState extends State<MemeEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Meme Maker"),
      ),
      body: Center(
        child: Container(
          height: 196,
          width: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
              widget.imageLink,
            )),
          ),
        ),
      ),
    );
  }
}
