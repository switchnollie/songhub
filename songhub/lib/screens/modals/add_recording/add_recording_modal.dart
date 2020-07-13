// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/label.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/recording_form.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:uuid/uuid.dart';
import 'package:song_hub/models/recording.dart';
import 'package:path/path.dart' as Path;

/// A modal that wraps a [RecordingForm].
///
/// Defines a submit handler that calls the [setRecording] method
/// on the database service to add the new recording as a document to
/// Cloud Firestore.
class AddRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/add";

  /// Handle add submission
  void _handleSubmit(
      BuildContext context,
      GlobalKey<FormState> formKey,
      recordingFile,
      String storagePath,
      SongWithImages song,
      Label selectedLabel,
      String versionDescription,
      Recording recording) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final storageService =
          Provider.of<StorageService>(context, listen: false);

      if (formKey.currentState.validate()) {
        final recordingId = Uuid().v4();
        if (recordingFile != null) {
          // Push currently selected file to Firebase Storage and retrieve path
          storagePath = await storageService.uploadRecording(
            song.songDocument.id,
            recordingId + (Path.extension(recordingFile.path) ?? ""),
            recordingFile,
            FileUserPermissions(
                owner: database.uid,
                participants: song.songDocument.participants),
            song.songDocument.ownedBy,
          );
        }
        final recording = Recording(
          id: recordingId,
          label: selectedLabel,
          creator: database.uid,
          storagePath: storagePath,
          createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
          updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
          versionDescription: versionDescription,
        );
        await database.setRecording(
            recording, song.songDocument.id, song.songDocument.ownedBy);
        Navigator.of(context).pop("Successfully added recording");
      }
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RecordingModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: RecordingForm(
        song: args.song,
        recording: null,
        submitButtonText: 'CREATE',
        onSubmit: _handleSubmit,
        index: args.index,
        appBarTitle: 'New Recording',
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}
