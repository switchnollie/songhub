import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String title;

  ScreenHeader({this.title});

  @override
  Widget build(BuildContext context) => Container(
        // Song overview header
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 38,
              ),
              color: Color(0xFFD2D4DC),
              onPressed: () {},
            )
          ],
        ),
      );
}
