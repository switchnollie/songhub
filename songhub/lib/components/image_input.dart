import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _ImageInputState extends State<ImageInput> {

  File imageFile;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Center(
          child: imageFile == null
              ? Container(
                  color: Theme.of(context).accentColor.withAlpha(0x22),
                  width: 125,
                  height: 125,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () {
                      getImage();
                    },
                  ),
                )
              : Image.file(imageFile),
        ),
      ),
    );
  }
}

class ImageInput extends StatefulWidget {
  @override
  _ImageInputState createState() => _ImageInputState();
}
