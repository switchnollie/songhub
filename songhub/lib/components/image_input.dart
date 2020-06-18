import 'dart:io';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final File imageFile;
  final Function callback;
  final String imageUrl;

  ImageInput(
      {@required this.imageFile, @required this.callback, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Center(
          child: imageFile == null && imageUrl == null
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
                  color: Theme.of(context).accentColor.withAlpha(0x22),
                  width: 125,
                  height: 125,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.33,
                        // TODO: Error hasSize
                        child: FittedBox(
                            fit: BoxFit.fill,
                            child: imageFile != null
                                ? Image.file(imageFile)
                                : Image.network(imageUrl)),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.black,
                        onPressed: callback,
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
