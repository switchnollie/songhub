import 'package:song_hub/components/song_list.dart';
import 'package:song_hub/components/screen_header.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/songs_mock.dart';
import 'package:flutter/material.dart';

class SongOverview extends StatefulWidget {
  @override
  _SongOverviewState createState() => _SongOverviewState();
}

class _SongOverviewState extends State<SongOverview> {
  List<Song> songs =
      SongsServiceMock.songs.entries.map((e) => e.value).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ScreenHeader(title: "Songs"),
        Expanded(child: SongList(songs: songs)),
      ]),
    );
  }
}
