import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class _ImageInputState extends State<ImageInput> {
  
  Future<File> imageFile;

  _ImageInputState({this.imageFile});

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget imagePreview() {
    return FutureBuilder<File>(
        future: imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapchot) {
          if (snapchot.connectionState == ConnectionState.done &&
              snapchot.data != null) {
            return Image.file(
              snapchot.data,
              width: 125,
              height: 125,
            );
          } else {
            return Container(
              color: Theme.of(context).accentColor.withAlpha(0x22),
              width: 125,
              height: 125,
              child: IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: () {
                  // pickImageFromGallery(ImageSource.gallery);
                  pickImageFromGallery(ImageSource.camera);
                },
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: Color(0xFFF2F5FA),
          width: 125,
          height: 125,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              imagePreview(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageInput extends StatefulWidget {

  final Future<File> imageFile;

  ImageInput({this.imageFile});
  
  _ImageInputState createState() => _ImageInputState(imageFile: imageFile);
}