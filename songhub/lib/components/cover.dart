import 'package:flutter/material.dart';

enum CoverSize { LARGE, SMALL }

class Cover extends StatelessWidget {
  final String img;
  final CoverSize size;

  Cover({@required this.img, @required this.size});

  @override
  Widget build(BuildContext context) {
    return size == CoverSize.LARGE
        ? ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(
              img,
              width: 125,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.network(img),
          );
  }
}
