import 'package:flutter/material.dart';

/// Custom app bar; Can be used as Screen Header too
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
