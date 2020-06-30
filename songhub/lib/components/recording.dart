import 'package:audioplayer/audioplayer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

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
                    arguments:
                        RecordingModalRouteParams(song: song, recording: null),
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
                song: song, recording: recording.recordingDocument),
          );
        },
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              RecordingItemHeader(recording: recording),
              RecordingItemBody(recording: recording),
              RecordingPlaybackButton(recording: recording),
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
                      recording.recordingDocument.updatedAt != null
                          ? recording.recordingDocument.updatedAt.toDate()
                          : recording.recordingDocument.createdAt.toDate()),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          recording.recordingDocument.creator != null
              ? CircleAvatar(
                  child: ClipOval(
                    child: Image.network(recording.creatorImgUrl),
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
                recording.recordingDocument.label,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Text(
              recording.recordingDocument.versionDescription,
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

class RecordingPlaybackButton extends StatelessWidget {
  final RecordingWithImages recording;

  RecordingPlaybackButton({this.recording});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        onTap: () => playAudio(recording.recordingDocument.storagePath),
        child: Icon(
          Icons.play_arrow,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// TODO: Move out of component
  /// Playback file from Firebase Storage
  void playAudio(String storagePath) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      final String fileUrl =
          await _storage.ref().child(storagePath).getDownloadURL();
      AudioPlayer ap = AudioPlayer();
      ap.play(fileUrl);
    } catch (e) {
      print('Couldn\'t playback file! $e');
    }
  }
}
