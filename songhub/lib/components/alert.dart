// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
/// Authors: Pascal Schlaak, Tim Weise

import 'package:flutter/material.dart';

/// A widget that wraps an [AlertDialog].
///
/// Builds a container with a [title], [text] to describe consequences and
/// [option1], [option2] to describe actions of Buttons. [onTap] defines a
/// function to execute when [option2] button is pressed. [option1] button will
/// pop the top-most view.
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
