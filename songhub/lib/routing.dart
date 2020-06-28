import 'package:song_hub/models/recording.dart';
import 'package:song_hub/screens/app/song_details/song_details_screen.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_screen.dart';
import 'package:song_hub/screens/app/user_settings/user_settings_screen.dart';
import 'package:song_hub/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:song_hub/screens/modals/add_song/add_song_modal.dart';
import 'package:song_hub/screens/modals/edit_profile/edit_profile_modal.dart';
import 'package:song_hub/screens/modals/edit_song/edit_song_modal.dart';
import 'package:song_hub/screens/modals/recording_modals.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class SongDetailsScreenRouteParams {
  final SongWithImages song;
  SongDetailsScreenRouteParams({this.song});
}

class EditSongModalRouteParams {
  final SongWithImages song;
  EditSongModalRouteParams({this.song});
}

class RecordingModalRouteParams {
  final SongWithImages song;
  final Recording recording;
  RecordingModalRouteParams({this.song, this.recording});
}

Map<String, Widget Function(BuildContext)> routes = {
  SongsOverviewScreen.routeId: SongsOverviewScreen.create,
  SongDetailsScreen.routeId: SongDetailsScreen.create,
  AddSongModal.routeId: (_) => AddSongModal(),
  EditSongModal.routeId: (_) => EditSongModal(),
  AddRecordingModal.routeId: (_) => AddRecordingModal(),
  EditRecordingModal.routeId: (_) => EditRecordingModal(),
  EditProfileModal.routeId: EditProfileModal.create,
  "/notifications": (_) => PlaceholderScreen("Notifications"),
  UserSettingsScreen.routeId: (_) => UserSettingsScreen(),
  SignInScreen.routeId: (_) => SignInScreenBuilder(),
  SignUpScreen.routeId: (context) => SignUpScreenBuilder(),
};
