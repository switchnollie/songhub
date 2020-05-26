import 'package:song_hub/components/new_song.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/details.dart';
import 'package:song_hub/screens/overview.dart';
import 'package:song_hub/screens/placeholder.dart';
import 'package:flutter/material.dart';

class SongDetailsRouteParams {
  final Song song;
  SongDetailsRouteParams({this.song});
}

Map<String, Widget Function(BuildContext)> routes = {
  "/songs": (context) => SongOverview(),
  "/songs/details": (context) => SongDetails(),
  "/songs/new" : (context) => NewSong(),
  "/notifications": (context) => PlaceholderScreen("Notifications"),
  "/profile": (context) => PlaceholderScreen("Profile"),
};
