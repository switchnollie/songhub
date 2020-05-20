import 'package:app/screens/details.dart';
import 'package:app/screens/overview.dart';
import 'package:app/screens/placeholder.dart';
import 'package:flutter/material.dart';

class SongDetailsRouteParams {
  final String songId;
  SongDetailsRouteParams({this.songId});
}

Map<String, Widget Function(BuildContext)> routes = {
  "/songs": (context) => SongOverview(),
  "/songs/details": (context) => SongDetails(),
  "/notifications": (context) => PlaceholderScreen("Notifications"),
  "/profile": (context) => PlaceholderScreen("Profile"),
};
