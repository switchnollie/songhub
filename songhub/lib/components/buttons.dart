import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_horiz,
      ),
      onPressed: () {},
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  PrimaryButton({@required this.text, @required this.onPressed});
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
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
