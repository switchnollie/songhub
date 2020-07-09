// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/alert.dart';
import 'package:song_hub/models/label.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/recording_form.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

/// A modal that wraps a [RecordingForm].
///
/// Defines a submit handler that calls the [setRecording] method
/// on the database service to update the recording document in
/// Cloud Firestore.
class EditRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/edit";

  /// Handles the form submission:
  ///
  /// Validates the input fields, uploads the [recordingFile] to Storage under
  /// [storagePath] and updates the recording document using the input field
  /// values.
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
        if (recordingFile != null) {
          storagePath = await storageService.uploadRecording(
              song.songDocument.id,
              recording.id,
              recordingFile,
              FileUserPermissions(
                  owner: database.uid,
                  participants: song.songDocument.participants));
        }
        await database.setRecording(
            Recording(
              id: recording.id,
              label: selectedLabel != recording.label
                  ? selectedLabel
                  : recording.label,
              creator: recording.creator,
              storagePath:
                  storagePath != recording.storagePath && storagePath != null
                      ? storagePath
                      : recording.storagePath,
              createdAt: recording.createdAt,
              updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
              versionDescription:
                  versionDescription != recording.versionDescription
                      ? versionDescription
                      : recording.versionDescription,
            ),
            song.songDocument.id,
            song.songDocument.ownedBy);
        Navigator.of(context).pop("Successfully updated recording");
      }
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final RecordingModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: RecordingForm(
        song: args.song,
        recording: args.recording,
        submitButtonText: 'SAVE',
        onSubmit: _handleSubmit,
        index: args.index,
        appBarTitle: 'Edit recording',
        appBarAction: IconButton(
          icon: Icon(Icons.delete_outline,
              color: Theme.of(context).colorScheme.secondary),
          onPressed: () => _showDeleteAlert(context, args.song, args.recording),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  /// Shows an alert to confirm the deletion of the provided [recording]
  /// that is part of the provided [song].
  Future<void> _showDeleteAlert(
      BuildContext context, SongWithImages song, Recording recording) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertWidget(
          title: 'Delete file',
          text:
              'Are you sure you want to delete this file? This action can\'t be undone!',
          option1: 'CANCEL',
          option2: 'DELETE',
          onTap: () => _handleRecordingDelete(context, song, recording),
        );
      },
    );
  }

  /// Deletes the [recording] document of the [song] from Cloud Firestore and Storage
  /// and navigates back displaying a snackbar message.
  void _handleRecordingDelete(
      BuildContext context, SongWithImages song, Recording recording) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);

    try {
      database.deleteRecording(recording, song.songDocument.id);
      storageService.deleteFile(recording.storagePath);
      Navigator.of(context).pop("Successfully deleted recording");
    } catch (e) {
      print(e);
    }
  }
}
