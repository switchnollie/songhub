import 'package:flutter/material.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';

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
