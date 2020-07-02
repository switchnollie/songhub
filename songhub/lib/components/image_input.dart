import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef dynamic OnPicked(PickedFile pickedFile);

class ImageInput extends StatelessWidget {
  final File imageFile;
  final String imageUrl;
  final bool isAvatar;
  final OnPicked onPicked;
  final Function onPickedError;
  final double maxWidth;
  final double maxHeight;
  final int quality;
  final ImageSource source;

  final ImagePicker _picker = ImagePicker();

  ImageInput(
      {@required this.imageFile,
      @required this.onPicked,
      this.maxWidth = 300,
      this.maxHeight = 300,
      this.onPickedError = print,
      this.source = ImageSource.gallery,
      this.quality,
      this.imageUrl,
      this.isAvatar = false});

  void _handlePickerButtonPressed() async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );
      onPicked(pickedFile);
    } catch (e) {
      onPickedError(e);
    }
  }

  Widget _buildMaskedContent(BuildContext context) {
    return Center(
      child: imageFile == null && imageUrl == null
          ? Container(
              color: Theme.of(context).colorScheme.background,
              width: 125,
              height: 125,
              child: IconButton(
                icon: Icon(Icons.add),
                color: Theme.of(context).colorScheme.secondary,
                onPressed: _handlePickerButtonPressed,
              ),
            )
          : Container(
              color: Colors.transparent,
              width: 125,
              height: 125,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: 0.33,
                    child: SizedBox.expand(
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: imageFile != null
                              ? Image.file(imageFile)
                              : Image.network(imageUrl)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(imageUrl != null ? Icons.edit : Icons.add),
                    color: Theme.of(context).colorScheme.secondary,
                    onPressed: _handlePickerButtonPressed,
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
              backgroundColor: Theme.of(context).colorScheme.background,
              child: ClipOval(child: _buildMaskedContent(context)),
              radius: 62.5,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: _buildMaskedContent(context),
            ),
    );
  }
}
