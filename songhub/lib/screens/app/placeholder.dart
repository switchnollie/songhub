import 'package:flutter/material.dart';


class PlaceholderScreen extends StatelessWidget {
  final String text;

  PlaceholderScreen(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.text),
      ),
    );
  }
}