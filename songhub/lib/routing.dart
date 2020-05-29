import 'package:song_hub/screens/modals/add_song.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/details.dart';
import 'package:song_hub/screens/login.dart';
import 'package:song_hub/screens/overview.dart';
import 'package:song_hub/screens/placeholder.dart';
import 'package:flutter/material.dart';

class SongDetailsScreenRouteParams {
  final Song song;
  SongDetailsScreenRouteParams({this.song});
}

Map<String, Widget Function(BuildContext)> routes = {
  SongOverviewScreen.routeId: (context) => SongOverviewScreen(),
  SongDetailsScreen.routeId: (context) => SongDetailsScreen(),
  AddSongModal.routeId: (context) => AddSongModal(),
  LoginScreen.routeId: (context) => LoginScreen(),
  "/notifications": (context) => PlaceholderScreen("Notifications"),
  "/profile": (context) => PlaceholderScreen("Profile"),
  "/login": (context) => LoginScreen(),
};
