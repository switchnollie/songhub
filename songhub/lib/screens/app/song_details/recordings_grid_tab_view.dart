import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class RecordingsGridTabView extends StatefulWidget {
  final SongWithImages song;

  RecordingsGridTabView({@required this.song});

  @override
  _RecordingsGridState createState() => _RecordingsGridState();
}

class _RecordingsGridState extends State<RecordingsGridTabView> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return Container(
      color: Color(0xFFf1f7ff),
      child: StreamBuilder<List<RecordingWithImages>>(
        stream: vm.recordings,
        builder: (context, snapshot) => GridView.builder(
          padding: EdgeInsets.all(16.0),
          // itemCount: content.length,
          itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return RecordingInputItem(song: widget.song);
            }
            return RecordingItem(
              song: widget.song,
              recording: snapshot.data[index - 1],
            );
          },
        ),
      ),
    );
  }
}

/// File input container
class RecordingInputItem extends StatelessWidget {
  final SongWithImages song;

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
  final SongWithImages song;
  final RecordingWithImages recording;

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
            arguments: RecordingModalRouteParams(
                song: song, recording: recording.recording),
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
  final RecordingWithImages recording;

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
                  DateFormat('yyyy-MM-dd').format(
                      recording.recording.updatedAt != null
                          ? recording.recording.updatedAt.toDate()
                          : recording.recording.createdAt.toDate()),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          recording.recording.creator != ""
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(recording.recording.creator),
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
  final RecordingWithImages recording;

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
                recording.recording.label,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Text(
              recording.recording.versionDescription,
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
