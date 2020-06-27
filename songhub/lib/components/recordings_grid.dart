import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/models/song.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/routing.dart';

class RecordingsGrid extends StatefulWidget {
  final Song song;

  RecordingsGrid({@required this.song});

  @override
  _RecordingsGridState createState() => _RecordingsGridState(song: song);
}

class _RecordingsGridState extends State<RecordingsGrid> {
  final Song song;

  _RecordingsGridState({this.song});

  @override
  Widget build(BuildContext context) {
    List<Recording> recordings = Provider.of<List<Recording>>(context);
    return GridView.builder(
        padding: EdgeInsets.all(16.0),
        // itemCount: content.length,
        itemCount: recordings != null ? recordings.length + 1 : 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return RecordingInputItem(song: song);
          }
          return RecordingItem(
            song: song,
            recording: recordings[index - 1],
          );
        });
  }
}

/// File input container
class RecordingInputItem extends StatelessWidget {
  final Song song;

  RecordingInputItem({this.song});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "file",
      child: Material(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Theme.of(context).accentColor.withAlpha(0x22),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/recordings/add",
                    arguments: RecordingModalRouteParams(song: song),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Container for specific file in grid
class RecordingItem extends StatelessWidget {
  final Song song;
  final Recording recording;

  RecordingItem({@required this.song, @required this.recording});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/recordings/edit",
            arguments:
                RecordingModalRouteParams(song: song, recording: recording),
          );
        },
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              RecordingItemHeader(recording: recording),
              RecordingItemBody(recording: recording),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header of file container
class RecordingItemHeader extends StatelessWidget {
  final Recording recording;

  RecordingItemHeader({@required this.recording});

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
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(recording.updatedAt != null
                      ? recording.updatedAt.toDate()
                      : recording.createdAt.toDate()),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          recording.creator != ""
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(recording.creator),
                  ),
                  radius: 14,
                )
              : Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 28,
                )
        ],
      ),
    );
  }
}

/// Content of file container
class RecordingItemBody extends StatelessWidget {
  final Recording recording;

  RecordingItemBody({@required this.recording});

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
                recording.label,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Text(
              recording.versionDescription,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
