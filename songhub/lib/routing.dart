import 'package:song_hub/models/recording.dart';
import 'package:song_hub/screens/app/profile.dart';
import 'package:song_hub/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:song_hub/screens/modals/song_modals.dart';
import 'package:song_hub/screens/modals/recording_modals.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/app/details.dart';
import 'package:song_hub/screens/app/overview.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:song_hub/screens/modals/user_settings_modal.dart';

class SongDetailsScreenRouteParams {
  final String songId;
  SongDetailsScreenRouteParams({this.songId});
}

class EditSongModalRouteParams {
  final Song song;
  EditSongModalRouteParams({this.song});
}

class RecordingModalRouteParams {
  final Song song;
  final Recording recording;
  RecordingModalRouteParams({this.song, this.recording});
}

Map<String, Widget Function(BuildContext)> routes = {
  SongOverviewScreen.routeId: (context) => SongOverviewScreen(),
  SongDetailsScreen.routeId: (context) => SongDetailsScreen(),
  AddSongModal.routeId: (context) => AddSongModal(),
  EditSongModal.routeId: (context) => EditSongModal(),
  AddRecordingModal.routeId: (context) => AddRecordingModal(),
  EditRecordingModal.routeId: (context) => EditRecordingModal(),
  "/notifications": (context) => PlaceholderScreen("Notifications"),
  ProfileScreen.routeId: (context) => ProfileScreen(),
  SignInScreen.routeId: (context) => SignInScreenBuilder(),
  SignUpScreen.routeId: (context) => SignUpScreenBuilder(),
  UserSettingsModal.routeId: (context) => UserSettingsModal(),
};
