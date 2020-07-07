import 'package:flutter/material.dart';
import 'package:song_hub/components/custom_app_bar.dart';

/// A component to display screen content
class ScreenContainer extends StatelessWidget {
  final Color color;
  final CustomAppBar header;
  final Widget body;

  ScreenContainer({this.color, this.header, @required this.body});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: color != null ? color : Theme.of(context).colorScheme.primary,
        child: Column(children: <Widget>[
          header != null ? header : SizedBox.shrink(),
          Expanded(child: body),
        ]),
      ),
    );
  }
}
