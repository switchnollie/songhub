// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

/// A widget that builds this apps primary button.
///
/// A [text] will be needed to describe the buttons action. [onPressed] should
/// be an function to be executed on tap of this button. [disabled] will change
/// the buttons color to look disabled.
class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool disabled;

  PrimaryButton(
      {@required this.text, @required this.onPressed, this.disabled = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: InkWell(
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: RaisedButton(
            textColor: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            onPressed: disabled == true ? null : onPressed,
            disabledColor: Theme.of(context).accentColor.withAlpha(0x88),
          ),
        ),
      ),
    );
  }
}
