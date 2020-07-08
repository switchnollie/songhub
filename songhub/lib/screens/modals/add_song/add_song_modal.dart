import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/models/genre.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/screens/modals/add_song/add_song_view_model.dart';
import 'package:uuid/uuid.dart';
import 'package:song_hub/screens/modals/song_form.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/add";

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
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);
      final authService =
          Provider.of<FirebaseAuthService>(context, listen: false);
      final FireUser user = await authService.currentUser();
      if (formKey.currentState.validate()) {
        final String songId = Uuid().v4();
        String imageUrl;
        if (imageFile != null) {
          imageUrl = await storageService.uploadCoverImg(songId, imageFile,
              FileUserPermissions(owner: user.uid, participants: participants));
        }
        await database.setSong(Song(
          id: songId,
          title: title,
          artist: artist,
          coverImg: imageUrl,
          participants: participants,
          lyrics: lyrics,
          status: status,
          genre: genre,
          mood: mood,
          ownedBy: user.uid,
          createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
          updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
        ));
      }
      Navigator.pop(context, "Successfully added song");
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data");
    }
  }

  static Widget create(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    return Provider<AddSongViewModel>(
      create: (_) => AddSongViewModel(
        database: database,
      ),
      child: AddSongModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddSongViewModel>(context);
    return StreamBuilder<String>(
      stream: vm.stageName,
      builder: (context, snapshot) => Scaffold(
        body: snapshot.hasData
            ? SongForm(
                song: null,
                onSubmit: handleSubmit,
                submitButtonText: "ADD",
                appBarTitle: 'New project',
                stageName: snapshot.data,
              )
            : Spinner(),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
