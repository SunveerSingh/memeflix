import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:memeflix/responsive.dart';
import 'package:memeflix/screens/auth/auth_services.dart';
import 'package:memeflix/screens/upload_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MemeEditor extends StatefulWidget {
  String imageLink;
  MemeEditor({Key key, @required this.imageLink}) : super(key: key);
  @override
  _MemeEditorState createState() => _MemeEditorState();
}

class _MemeEditorState extends State<MemeEditor> {
  Random rng = new Random();

  final GlobalKey globalKey = new GlobalKey();
  String headerText = "";
  String footerText = "";
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeGreen,
        title: Text("Meme Maker"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: <Widget>[
                    widget.imageLink != null
                        ? Image.network(
                            widget.imageLink,
                            height: 300,
                            fit: BoxFit.fitHeight,
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              headerText.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Colors.black87,
                                  ),
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 8.0,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                footerText.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Colors.black87,
                                    ),
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 8.0,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          headerText = val;
                        });
                      },
                      decoration: InputDecoration(hintText: "Header Text"),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          footerText = val;
                        });
                      },
                      decoration: InputDecoration(hintText: "Footer Text"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: themeGreen,
                          borderRadius: BorderRadius.circular(10)),
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: () {
                          takeScreenshot();
                        },
                        child: Text(
                          'Save and Upload',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    File imgFile = new File('$directory/screenshot${rng.nextInt(200)}.png');
    setState(() {
      _imageFile = imgFile;
    });
    _savefile(_imageFile);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UploadScreen(
                image: _imageFile,
              )),
    );
    //saveFileLocal();
    imgFile.writeAsBytes(pngBytes);
  }

  _savefile(File file) async {
    await _askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
    print(result);
  }

  _askPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
    ].request();
  }
}
