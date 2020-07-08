import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/screens/app/song_details/recording_playback.dart';

/// A component to display a recording input container
class InputBox extends StatelessWidget {
  final String heroTag;
  final Function onPressed;

  InputBox({@required this.heroTag, @required this.onPressed});

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

/// A component to display a specific recording item
class Box extends StatelessWidget {
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String creator;
  final String creatorImgUrl;
  final String label;
  final String versionDescription;
  final String heroTag;
  final String storagePath;
  final Function onTap;

  Box({
    @required this.creator,
    @required this.createdAt,
    @required this.label,
    @required this.onTap,
    @required this.heroTag,
    @required this.storagePath,
    this.creatorImgUrl,
    this.updatedAt,
    this.versionDescription,
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
                  children: <Widget>[
                    BoxHeader(
                      creator: creator,
                      createdAt: createdAt,
                      creatorImgUrl:
                          creatorImgUrl != null ? creatorImgUrl : null,
                      updatedAt: updatedAt != null ? updatedAt : null,
                    ),
                    BoxBody(
                      label: label,
                      versionDescription: versionDescription != null
                          ? versionDescription
                          : null,
                    ),
                    // TODO: No component
                    BoxPlayback(storagePath: storagePath),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A component to display a header for an recording item
class BoxHeader extends StatelessWidget {
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String creator;
  final String creatorImgUrl;

  BoxHeader({
    @required this.creator,
    @required this.createdAt,
    this.creatorImgUrl,
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
          creator != null
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(creatorImgUrl),
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

/// A component to display a body for a recording item
class BoxBody extends StatelessWidget {
  final String label;
  final String versionDescription;

  BoxBody({
    @required this.label,
    this.versionDescription,
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
                label,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            versionDescription != null
                ? Text(
                    versionDescription,
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
