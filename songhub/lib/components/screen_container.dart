import 'package:flutter/material.dart';
import 'package:song_hub/components/screen_header.dart';

class ScreenContainer extends StatelessWidget {
  final Color color;
  final ScreenHeader header;
  final Widget body;

  ScreenContainer({this.color, this.header, @required this.body});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: color != null ? color : Colors.white,
        child: Column(children: <Widget>[
          header != null ? header : SizedBox.shrink(),
          Expanded(child: body),
        ]),
      ),
    );
  }
}
