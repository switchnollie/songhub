import 'package:song_hub/screens/app/profile.dart';
import 'package:song_hub/screens/modals/add_song.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/app/details.dart';
import 'package:song_hub/screens/authentication/login.dart';
import 'package:song_hub/screens/app/overview.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/authentication/registration.dart';

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
  ProfileScreen.routeId: (context) => ProfileScreen(),
  RegistrationScreen.routeId: (context) => RegistrationScreen(),
};
