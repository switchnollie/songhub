import 'package:provider/provider.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/components/song_list.dart';
import 'package:song_hub/components/screen_header.dart';
import 'package:song_hub/models/song.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class SongOverviewScreen extends StatelessWidget {
  static const routeId = "/songs";

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Provider.of<List<Song>>(context);
    return ScreenContainer(
      header: ScreenHeader(
        title: "Songs",
        actionButton: IconButton(
          icon: Icon(
            Icons.add,
            size: 32.0,
          ),
          color: Color(0xFFD2D4DC),
          onPressed: () {
            navigateAndDisplayReturnedMessage(
              context,
              "/songs/add",
            );
          },
        ),
      ),
      body: SongList(songs: songs),
    );
  }
}
