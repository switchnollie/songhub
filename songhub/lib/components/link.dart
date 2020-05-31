import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String to;
  final Widget child;
  Link({this.to, this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, to);
      },
      child: child,
    );
  }
}
