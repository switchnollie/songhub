// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/genre.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/song_form.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class EditSongModal extends StatelessWidget {
  static const routeId = "/songs/edit";

  void handleSubmit({
    GlobalKey<FormState> formKey,
    BuildContext context,
    String title,
    String artist,
    String lyrics,
    String mood,
    File imageFile,
    String status,
    Genre genre,
    List<String> participants,
  }) async {
    try {
      final EditSongModalRouteParams args =
          ModalRoute.of(context).settings.arguments;
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final FireUser user = await authService.currentUser();
      if (formKey.currentState.validate()) {
        String imageUrl;
        if (imageFile != null) {
          imageUrl = await storageService.uploadCoverImg(
            args.song.songDocument.id,
            imageFile,
            FileUserPermissions(owner: user.uid, participants: participants),
          );
        }
        await database.setSong(
            Song(
              id: args.song.songDocument.id,
              title: title ?? args.song.songDocument.title,
              artist: artist ?? args.song.songDocument.artist,
              coverImg: imageUrl != args.song.songDocument.coverImg &&
                      imageUrl != null
                  ? imageUrl
                  : args.song.songDocument.coverImg,
              participants: participants,
              lyrics: lyrics,
              status: status,
              genre: genre,
              mood: mood,
              ownedBy: args.song.songDocument.ownedBy,
              createdAt: args.song.songDocument.createdAt,
              updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
            ),
            args.song.songDocument.ownedBy);
      }
      Navigator.of(context).pop("Successfully updated song");
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      print(err);
      showSnackBarByContext(context, "Error submitting data", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final EditSongModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SongForm(
        song: args.song,
        onSubmit: handleSubmit,
        submitButtonText: "SAVE",
        appBarTitle: 'Edit project',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
