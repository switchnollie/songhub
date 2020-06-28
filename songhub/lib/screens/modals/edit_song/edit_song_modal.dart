import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/song_form.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class EditSongModal extends StatelessWidget {
  static const routeId = "/songs/edit";

  void handleSubmit(
      {@required GlobalKey<FormState> formKey,
      @required String title,
      @required String artist,
      @required String lyrics,
      @required String mood,
      @required File imageFile,
      @required String status,
      @required String songId,
      @required List<String> participants,
      @required BuildContext context}) async {
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
            songId,
            imageFile,
            FileUserPermissions(owner: user.uid, participants: participants),
          );
        }
        database.setSong(Song(
          id: songId,
          title: title,
          artist: artist,
          coverImg: imageUrl,
          participants: participants,
          lyrics: lyrics,
          status: status,
          mood: mood,
        ));
      }
      Navigator.pop(context, "Successfully updated song");
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SongForm(
        song: args.song,
        onSubmit: handleSubmit,
        submitButtonText: "SAVE",
      ),
      backgroundColor: Colors.white,
    );
  }
}
