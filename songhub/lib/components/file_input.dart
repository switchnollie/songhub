import 'package:flutter/material.dart';

class FileInput extends StatelessWidget {
  final Function callback;

  FileInput({this.callback});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          child: Center(
              child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => callback(),
          )),
        ));
  }
}
