import 'dart:io';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final File imageFile;
  final Function onPressed;
  final String imageUrl;
  final bool isAvatar;

  ImageInput(
      {@required this.imageFile,
      @required this.onPressed,
      this.imageUrl,
      this.isAvatar = false});

  Widget _buildMaskedContent(BuildContext context) {
    return Center(
      child: imageFile == null && imageUrl == null
          ? Container(
              color: Theme.of(context).accentColor.withAlpha(0x22),
              width: 125,
              height: 125,
              child: IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: onPressed,
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
                    icon: Icon(imageUrl != null ? Icons.edit : Icons.add),
                    color: Colors.black,
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: isAvatar
          ? CircleAvatar(
              child: ClipOval(child: _buildMaskedContent(context)),
              radius: 62.5,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: _buildMaskedContent(context)),
    );
  }
}
