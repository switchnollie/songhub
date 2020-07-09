// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef dynamic OnPicked(PickedFile pickedFile);

/// A widget that builds an image picker.
///
/// [imageFile] contains a image file to be picked. [imageUrl] can define a
/// image url to be displayed when no file was selected and a previously
/// defined url exists. [isAvatar] is used to differ the image pickers style.
/// [onPicked] should include a [OnPicked] to be executed when a file is picked.
/// [onPickedError] can be defined to be executed if an error occurs. [maxWidth]
/// and [maxHeight] defines the max resolution of an picked image. [quality]
/// restricts the picked images quality. [source] will define the source of
/// where images should be selected on the OS. [label] will be displayed above
/// the image picker.
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
  final String label;

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
      this.isAvatar = false,
      this.label});

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
    return imageFile == null && imageUrl == null
        ? Container(
            color: Theme.of(context).colorScheme.background,
            width: 155,
            height: 155,
            child: IconButton(
              icon: Icon(Icons.add),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: _handlePickerButtonPressed,
            ),
          )
        : Container(
            color: Colors.transparent,
            width: 155,
            height: 155,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 6.0),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onBackground)),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: isAvatar
              ? CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  child: ClipOval(child: _buildMaskedContent(context)),
                  radius: 62.5,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _buildMaskedContent(context),
                ),
        ),
      ],
    );
  }
}
