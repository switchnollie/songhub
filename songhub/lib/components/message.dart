import 'package:flutter/material.dart';
import 'package:song_hub/components/avatar.dart';

/// Message content widget
class MessageContent extends StatelessWidget {
  final String message;

  MessageContent({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      color: Theme.of(context).accentColor.withAlpha(0x22),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(message),
      ),
    );
  }
}

/// Message author image widget
class MessageAuthor extends StatelessWidget {
  final String authorImage;

  MessageAuthor({this.authorImage});

  @override
  Widget build(BuildContext context) {
    return authorImage != null
        ? Avatar(img: authorImage)
        : Icon(
            Icons.account_circle,
            color: Colors.grey,
          );
  }
}
