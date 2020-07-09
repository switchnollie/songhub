// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

enum CoverSize { LARGE, SMALL }

/// A widget that renders an image.
///
/// A [img] will include the url of an network image. [size] defines the size
/// of the cover container.
class Cover extends StatelessWidget {
  final String img;
  final CoverSize size;

  Cover({@required this.img, @required this.size});

  bool _isValidUrl(String imgUrl) {
    return Uri.parse(imgUrl).isAbsolute;
  }

  @override
  Widget build(BuildContext context) {
    return size == CoverSize.LARGE
        ? ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: (() => _isValidUrl(img)
                ? Image.network(
                    img,
                    width: 125,
                  )
                : Image.asset(img, width: 125))(),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: (() =>
                _isValidUrl(img) ? Image.network(img) : Image.asset(img))(),
          );
  }
}
