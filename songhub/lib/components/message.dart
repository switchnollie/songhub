import 'package:flutter/material.dart';
import 'package:song_hub/components/avatar.dart';

/// A component to display a message
class MessageContent extends StatelessWidget {
  final String message;

  MessageContent({this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(message),
      ),
    );
  }
}

/// A component to display a message author image
class MessageAuthor extends StatelessWidget {
  final String authorImage;

  MessageAuthor({this.authorImage});

  @override
  Widget build(BuildContext context) {
    return authorImage != null
        ? Avatar(img: authorImage)
        : Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.surface,
          );
  }
}
