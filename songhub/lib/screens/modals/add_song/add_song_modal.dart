import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/song.dart';
import 'package:uuid/uuid.dart';
import 'package:song_hub/screens/modals/song_form.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/add";

  void handleSubmit({
    @required GlobalKey<FormState> formKey,
    @required BuildContext context,
    String title,
    String artist,
    String lyrics,
    String mood,
    File imageFile,
    String status,
    String songId,
    List<String> participants,
  }) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final FireUser user = await authService.currentUser();
      if (formKey.currentState.validate()) {
        final String songId = Uuid().v4();
        final List<String> participants = [
          // TODO: Add real participants
          "ypVCXwADSWSToxsRpyspWWAHNfJ2",
          "dMxDgggEyDTYgkcDW8O6MMOPNiD2"
        ];
        String imageUrl;
        if (imageFile != null) {
          imageUrl = await storageService.uploadCoverImg(songId, imageFile,
              FileUserPermissions(owner: user.uid, participants: participants));
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
            ownedBy: user.uid));
      }
      Navigator.pop(context, "Successfully updated song");
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SongForm(
        song: null,
        onSubmit: handleSubmit,
        submitButtonText: "ADD",
      ),
      backgroundColor: Colors.white,
    );
  }
}
