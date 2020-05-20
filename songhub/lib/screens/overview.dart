import 'package:app/components/song_list.dart';
import 'package:app/components/screen_header.dart';
import 'package:app/models/song.dart';
import 'package:flutter/material.dart';

List<Song> createMockSongs(int count) {
  List<Song> songs = [];
  for (int i = 0; i < count; i++) {
    songs.add(
      Song(
          artist: "Sarah Corner",
          title: "Lorem ipsum dolor sit amet",
          img: "assets/example_cover.jpg",
          participants: [
            "assets/example_participant_1.jpg",
            "assets/example_participant_2.jpg",
            "assets/example_participant_3.jpg"
          ]),
    );
  }
  return songs;
}

class SongOverview extends StatefulWidget {
  @override
  _SongOverviewState createState() => _SongOverviewState();
}

class _SongOverviewState extends State<SongOverview> {
  List<Song> songs = createMockSongs(15);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ScreenHeader(title: "Song Overview"),
          SongList(songs: songs),
        ]);
  }
}
