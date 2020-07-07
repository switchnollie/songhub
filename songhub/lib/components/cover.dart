import 'package:flutter/material.dart';

enum CoverSize { LARGE, SMALL }

/// A component to display project covers
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
