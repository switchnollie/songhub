// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
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
import 'package:path/path.dart' as Path;

/// A modal that wraps a [SongForm].
///
/// Defines a submit handler that calls the [setSong] method
/// on the database service to add the new song as a document to
/// Cloud Firestore.
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
          imageUrl = await storageService.uploadCoverImg(
              songId + (Path.extension(imageFile.path) ?? ""),
              imageFile,
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
      showSnackBarByContext(context, "Error submitting data", isError: true);
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
