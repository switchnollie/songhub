// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

/// A widget that builds a custom app bar.
///
/// [title] defines the app bars header text. [backIcon] defines an IconData to
/// display at the start of this app bar. Its IconButton will pop the top-most
/// route. [action] declares an optinal IconButton with onTap action to be
/// displayed at the end of the app bar. [isHeader] is used to define the app
/// bars [title] font size. [isTransparent] is used so define this app bars
/// background color.
class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData backIcon;
  final IconButton action;
  final bool isHeader;
  final bool isTransparent;

  CustomAppBar(
      {this.title,
      this.backIcon,
      this.action,
      this.isHeader,
      this.isTransparent});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                isHeader
                    ? SizedBox.shrink()
                    : IconButton(
                        icon: Icon(
                            backIcon != null ? backIcon : Icons.arrow_back),
                        color: isTransparent
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onBackground,
                        onPressed: () => Navigator.of(context).pop()),
                title != null
                    ? Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isHeader ? 32 : 24,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            action != null ? action : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
