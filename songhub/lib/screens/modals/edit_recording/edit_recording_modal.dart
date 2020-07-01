import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/alert.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/recording_form.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

/// Edit recording modal
class EditRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/edit";

  /// Handle edit submission
  void _handleSubmit(
      BuildContext context,
      GlobalKey<FormState> formKey,
      // TODO: File type will generate error!
      recordingFile,
      String storagePath,
      SongWithImages song,
      String selectedStatus,
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
              label: selectedStatus != recording.label
                  ? selectedStatus
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
            song.songDocument.id);
        Navigator.pop(context, "Successfully added recording");
      }
    } catch (err) {
      // use 'on' clause and handle errors in more detail
      showSnackBarByContext(context, "Error submitting data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final RecordingModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Edit recording'),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _showDeleteAlert(context, args),
          )
        ],
      ),
      body: RecordingModal(
          song: args.song,
          recording: args.recording,
          submitButtonText: 'SAVE',
          onSubmit: _handleSubmit,
          index: args.index),
      backgroundColor: Colors.white,
    );
  }

  /// Show alert to confirm recording delete
  Future<void> _showDeleteAlert(
      BuildContext context, RecordingModalRouteParams args) async {
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
          onTap: () =>
              _handleRecordingDelete(context, args.song, args.recording),
        );
      },
    );
  }

  /// Delete recording from Firestore and Storage
  void _handleRecordingDelete(
      BuildContext context, SongWithImages song, Recording recording) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);

    try {
      database.deleteRecording(recording, song.songDocument.id);
      storageService.deleteFile(recording.storagePath);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}
