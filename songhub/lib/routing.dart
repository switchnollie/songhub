// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/screens/app/song_details/song_details_screen.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_screen.dart';
import 'package:song_hub/screens/app/user_settings/user_settings_screen.dart';
import 'package:song_hub/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:song_hub/screens/modals/add_recording/add_recording_modal.dart';
import 'package:song_hub/screens/modals/add_song/add_song_modal.dart';
import 'package:song_hub/screens/modals/edit_profile/edit_profile_modal.dart';
import 'package:song_hub/screens/modals/edit_recording/edit_recording_modal.dart';
import 'package:song_hub/screens/modals/edit_song/edit_song_modal.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

@immutable
class SongDetailsScreenRouteParams {
  final String songId;
  final String userId;
  final String songOwnedBy;
  SongDetailsScreenRouteParams({this.songId, this.userId, this.songOwnedBy});
}

@immutable
class EditSongModalRouteParams {
  final SongWithImages song;
  EditSongModalRouteParams({this.song});
}

@immutable
class RecordingModalRouteParams {
  final SongWithImages song;
  final Recording recording;
  final String index;
  RecordingModalRouteParams({this.song, this.recording, this.index});
}

/// The application's top-level routing table.
Map<String, Widget Function(BuildContext)> routes = {
  SongsOverviewScreen.routeId: SongsOverviewScreen.create,
  SongDetailsScreen.routeId: SongDetailsScreen.create,
  AddSongModal.routeId: AddSongModal.create,
  EditSongModal.routeId: (_) => EditSongModal(),
  AddRecordingModal.routeId: (_) => AddRecordingModal(),
  EditRecordingModal.routeId: (_) => EditRecordingModal(),
  EditProfileModal.routeId: EditProfileModal.create,
  "/notifications": (_) => PlaceholderScreen("Notifications"),
  UserSettingsScreen.routeId: (_) => UserSettingsScreen(),
  SignInScreen.routeId: (_) => SignInScreenBuilder(),
  SignUpScreen.routeId: (context) => SignUpScreenBuilder(),
};
