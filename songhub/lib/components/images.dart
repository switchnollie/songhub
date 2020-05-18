import 'package:flutter/material.dart';


class CoverLarge extends StatelessWidget {
  
  final String imagePath;

  CoverLarge({@required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.asset(
        imagePath,
        width: 125,
      ),
    );
  }
}

class CoverSmall extends StatelessWidget {
  
  final String img;
  
  CoverSmall({@required this.img});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.asset(img),
    );
  }
}