import 'package:flutter/material.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class EditSongSheet extends StatelessWidget {
  final SongWithImages song;

  EditSongSheet({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 168,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {
                navigateAndDisplayReturnedMessage(
                  context,
                  "/songs/edit",
                  arguments: EditSongModalRouteParams(song: song),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}
