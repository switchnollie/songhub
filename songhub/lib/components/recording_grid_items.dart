// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/models/label.dart';

/// A widgets that builds a recording grid item to add a new recording.
///
/// [heroTag] defines this widgets hero tag. [onPressed] includes a function to
/// be executed at IconButton press.
class RecordingGridInputItem extends StatelessWidget {
  final String heroTag;
  final Function onPressed;

  RecordingGridInputItem({@required this.heroTag, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "$heroTag",
      child: Material(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: IconButton(icon: Icon(Icons.add), onPressed: onPressed),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that builds an existing recording in the recording grid.
///
/// [heroTag] defines this widgets hero tag. [onTap] includes a function to
/// be executed at container press. [childrens] should be a list of widgets to
/// be displayed inside this widget.
class RecordingGridItem extends StatelessWidget {
  final String heroTag;
  final Function onTap;
  final List<Widget> children;

  RecordingGridItem({
    @required this.onTap,
    @required this.heroTag,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that builds a header inside a [RecordingsGridItem].
///
/// [createdAt] and [updatedAt] are timestamps. Only [createdAt] will be
/// displayed inside the widget. [imageUrl] defines a url to an network image
/// that can be displayed at the end of this header.
class RecordingGridItemHeader extends StatelessWidget {
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String imageUrl;

  RecordingGridItemHeader({
    @required this.createdAt,
    this.imageUrl,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.timeline,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(updatedAt != null
                      ? updatedAt.toDate()
                      : createdAt.toDate()),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
            ],
          ),
          imageUrl != null
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(imageUrl),
                  ),
                  radius: 14,
                )
              : Icon(
                  Icons.account_circle,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 28,
                )
        ],
      ),
    );
  }
}

/// A widget that builds a body inside a [RecordingsGridItem].
///
/// [title] can include text to be displayed as an title. [text] defines text
/// to be displayed below this title.
class RecordingGridItemBody extends StatelessWidget {
  final Label title;
  final String text;

  RecordingGridItemBody({
    @required this.title,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                title.value,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            text != null
                ? Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}

/// A widget that builds a playback icon inside a [RecordingsGridItem].
///
/// [isDisabled], [isPlaying], [loaded] are values to change this widgets icons.
/// [onTap] defines a function to be executed on this container press.
class RecordingGridItemPlayback extends StatelessWidget {
  final bool isDisabled, isPlaying, loaded;
  final Function onTap;

  RecordingGridItemPlayback(
      {this.isDisabled, @required this.isPlaying, this.onTap, this.loaded});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: onTap,
        child: loaded != null && loaded
            ? Icon(
                isDisabled
                    ? Icons.block
                    : isPlaying ? Icons.pause : Icons.play_arrow,
                color: Theme.of(context).colorScheme.onSurface,
              )
            : SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
