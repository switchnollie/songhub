import 'package:provider/provider.dart';
import 'package:song_hub/components/song_list.dart';
import 'package:song_hub/components/screen_header.dart';
import 'package:song_hub/models/song.dart';
import 'package:flutter/material.dart';

class SongOverviewScreen extends StatelessWidget {
  static const routeId = "/songs";
  @override
  Widget build(BuildContext context) {
    List<Song> songs = Provider.of<List<Song>>(context);
    return Container(
      child: Column(children: <Widget>[
        ScreenHeader(title: "Songs"),
        //Expanded(child: SongList(songs: songs)),
      ]),
    );
  }
}
