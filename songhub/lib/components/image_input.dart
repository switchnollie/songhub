import 'dart:io';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final File imageFile;
  final Function callback;

  ImageInput({@required this.imageFile, @required this.callback});

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
                    onPressed: callback,
                  ),
                )
              : Container(
                  width: 125,
                  height: 125,
                  child: FittedBox(
                      fit: BoxFit.fill, child: Image.file(imageFile))),
        ),
      ),
    );
  }
}
