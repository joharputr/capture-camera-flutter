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

  List<Image> splitImage(
      {imglib.Image inputImage,
      int horizontalPieceCount,
      int verticalPieceCount}) {
    imglib.Image image = inputImage as imglib.Image;

    final int xLength = (image.width / horizontalPieceCount).round();
    final int yLength = (image.height / verticalPieceCount).round();
    List<imglib.Image> pieceList = List<imglib.Image>();

    for (int y = 0; y < verticalPieceCount; y++)
      for (int x = 0; x < horizontalPieceCount; x++) {
        pieceList.add(
          imglib.copyCrop(image, x, y, x * xLength, y * yLength),
        );
      }

    //Convert image from image package to Image Widget to display
    List<Image> outputImageList = List<Image>();
    for (imglib.Image img in pieceList) {
      outputImageList.add(Image.memory(imglib.encodeJpg(img)));
    }

    return outputImageList;
  }

  imglib.Image copyCrop(imglib.Image src, int x, int y, int w, int h) {
    imglib.Image dst = imglib.Image(w, h,
        channels: src.channels, exif: src.exif, iccp: src.iccProfile);

    for (int yi = 0, sy = y; yi < h; ++yi, ++sy) {
      for (int xi = 0, sx = x; xi < w; ++xi, ++sx) {
        dst.setPixel(xi, yi, src.getPixel(sx, sy));
      }
    }
    return dst;
  }
}
