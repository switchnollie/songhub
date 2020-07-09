// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:song_hub/components/avatar.dart';

/// A widget that builds a messages content.
///
/// [message] includes text to be displayed inside this widget.
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

/// A widget that builds an messages author image.
///
/// [authorImage] holds an url of a network image.
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
