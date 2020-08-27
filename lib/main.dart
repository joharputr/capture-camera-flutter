import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File Imagex;
  File _image;
  final picker = ImagePicker();


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File croppedFile =
        await FlutterNativeImage.cropImage(pickedFile.path, 100, 100, 500, 600);
    setState(() {
      _image = File(croppedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: _image == null
          ? Container()
          : Container(
              child: Image.file(_image),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    ));
  }




}
