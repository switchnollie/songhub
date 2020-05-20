import 'package:app/components/song_list.dart';
import 'package:app/components/screen_header.dart';
import 'package:app/models/song.dart';
import 'package:app/songs_mock.dart';
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
        ScreenHeader(title: "Song Overview"),
        Expanded(child: SongList(songs: songs)),
      ]),
    );
  }
}
