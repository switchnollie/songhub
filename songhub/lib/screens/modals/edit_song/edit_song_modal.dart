import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/song_form.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class EditSongModal extends StatelessWidget {
  static const routeId = "/songs/edit";

  void handleSubmit(
      GlobalKey<FormState> formKey,
      BuildContext context,
      String title,
      String artist,
      String lyrics,
      String mood,
      File imageFile,
      String status,
      SongWithImages song,
      List<String> participants) async {
    try {
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
            song.songDocument.id,
            imageFile,
            FileUserPermissions(owner: user.uid, participants: participants),
          );
        }
        await database.setSong(Song(
          id: song.songDocument.id,
          title: title != null ? title : song.songDocument.title,
          artist: artist != null ? artist : song.songDocument.artist,
          coverImg: imageUrl != song.songDocument.coverImg && imageUrl != null
              ? imageUrl
              : song.songDocument.coverImg,
          participants: participants,
          lyrics: lyrics,
          status: status,
          mood: mood,
          ownedBy: song.songDocument.ownedBy,
          createdAt: song.songDocument.createdAt,
          updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
        ));
      }
      // TODO: Error no Scaffold
      // Navigator.pop(context, "Successfully updated song");
      Navigator.of(context).pop();
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final EditSongModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
