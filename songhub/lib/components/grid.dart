import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/models/song.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/routing.dart';

class FilesGrid extends StatefulWidget {
  final Song song;

  FilesGrid({@required this.song});

  @override
  _FilesGridState createState() => _FilesGridState(song: song);
}

class _FilesGridState extends State<FilesGrid> {
  final Song song;

  _FilesGridState({this.song});

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
            return FileInputContainer(song: song);
          }
          return FileItemContainer(
            song: song,
            recording: recordings[index - 1],
          );
        });
  }
}

/// File input container
class FileInputContainer extends StatelessWidget {
  final Song song;

  FileInputContainer({this.song});

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
class FileItemContainer extends StatelessWidget {
  final Song song;
  final Recording recording;

  FileItemContainer({@required this.song, @required this.recording});

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
              FileContainerHeader(recording: recording),
              FileContainerContent(recording: recording),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header of file container
class FileContainerHeader extends StatelessWidget {
  final Recording recording;

  FileContainerHeader({@required this.recording});

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
class FileContainerContent extends StatelessWidget {
  final Recording recording;

  FileContainerContent({@required this.recording});

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
