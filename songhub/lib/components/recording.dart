import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:video_player/video_player.dart';

/// A component to display a recording input container
class RecordingInputItem extends StatelessWidget {
  final SongWithImages song;
  final String index;

  RecordingInputItem({this.song, this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "$index",
      child: Material(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/recordings/add",
                      arguments: RecordingModalRouteParams(
                          song: song, recording: null, index: index),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A component to display a specific recording item
class RecordingItem extends StatelessWidget {
  final SongWithImages song;
  final RecordingWithImages recording;
  final String index;

  RecordingItem({@required this.song, @required this.recording, this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: index,
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/recordings/edit",
              arguments: RecordingModalRouteParams(
                  song: song,
                  recording: recording.recordingDocument,
                  index: index),
            );
          },
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: Container(
                color: Theme.of(context).colorScheme.surface,
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
          ),
        ),
      ),
    );
  }
}

/// A component to display a header for an recording item
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(
                      recording.recordingDocument.updatedAt != null
                          ? recording.recordingDocument.updatedAt.toDate()
                          : recording.recordingDocument.createdAt.toDate()),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 28,
                )
        ],
      ),
    );
  }
}

/// A component to display a body for a recording item
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

/// A component to display a playback button for a recording item
class RecordingPlaybackButton extends StatefulWidget {
  final RecordingWithImages recording;

  RecordingPlaybackButton({this.recording});

  @override
  _RecordingPlaybackButtonState createState() =>
      _RecordingPlaybackButtonState();
}

class _RecordingPlaybackButtonState extends State<RecordingPlaybackButton> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  // VoidCallback listener;
  // bool _isPlaying;
  String fileUrl;

  @override
  void initState() {
    super.initState();
    // listener = () {
    //   final bool isPlaying = _controller.value.isPlaying;
    //   if (isPlaying != _isPlaying) {
    //     setState(() {
    //       _isPlaying = isPlaying;
    //     });
    //   }
    // };
    initAudioPlayback(widget.recording.recordingDocument.storagePath);
  }

  /// Initialize video player and fetch downloadUrl of file
  void initAudioPlayback(String storagePath) async {
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      final String currentUrl =
          await _storage.ref().child(storagePath).getDownloadURL();

      setState(() {
        fileUrl = currentUrl;
      });
      _controller = VideoPlayerController.network(fileUrl);
      _controller.setLooping(true);
      // ..addListener(listener);
      _initializeVideoPlayerFuture = _controller.initialize();
    } catch (e) {
      print('Couldn\'t get audio from Storage! $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TODO: Move functionality out of component
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              );
            } else {
              return SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
