import 'package:song_hub/screens/app/profile.dart';
import 'package:song_hub/screens/modals/song_modal.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/app/details.dart';
import 'package:song_hub/screens/authentication/login.dart';
import 'package:song_hub/screens/app/overview.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/authentication/registration.dart';
import 'package:song_hub/screens/modals/user_settings_modal.dart';

class SongDetailsScreenRouteParams {
  final String songId;
  SongDetailsScreenRouteParams({this.songId});
}

class SongModalRouteParams {
  final Song song;
  SongModalRouteParams({this.song});
}

Map<String, Widget Function(BuildContext)> routes = {
  SongOverviewScreen.routeId: (context) => SongOverviewScreen(),
  SongDetailsScreen.routeId: (context) => SongDetailsScreen(),
  SongModal.routeId: (context) => SongModal(),
  LoginScreen.routeId: (context) => LoginScreen(),
  "/notifications": (context) => PlaceholderScreen("Notifications"),
  ProfileScreen.routeId: (context) => ProfileScreen(),
  RegistrationScreen.routeId: (context) => RegistrationScreen(),
  UserSettingsModal.routeId: (context) => UserSettingsModal(),
};
