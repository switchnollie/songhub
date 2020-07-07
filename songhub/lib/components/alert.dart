import 'package:flutter/material.dart';

/// A component to display alerts
class AlertWidget extends StatelessWidget {
  final String title, text, option1, option2;
  final Function onTap;

  AlertWidget(
      {@required this.title,
      @required this.text,
      @required this.option1,
      @required this.option2,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14.0),
        ),
      ),
      title: Text(title),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text(
            option1,
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text(
            option2,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: () {
            onTap();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
