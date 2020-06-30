import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/modals/recording_form.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:uuid/uuid.dart';

/// Add recording modal
class AddRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/add";

  /// Handle add submission
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
        final recordingId = Uuid().v4();
        if (recordingFile != null) {
          storagePath = await storageService.uploadRecording(
              song.songDocument.id,
              recordingId,
              recordingFile,
              FileUserPermissions(
                  owner: database.uid,
                  participants: song.songDocument.participants));
        }
        final recording = Recording(
          id: recordingId,
          label: selectedStatus,
          creator: database.uid,
          storagePath: storagePath,
          createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
          updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
          versionDescription: versionDescription,
        );
        await database.setRecording(recording, song.songDocument.id);
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
        title: Text('Add recording'),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: RecordingModal(
          song: args.song,
          recording: null,
          submitButtonText: 'CREATE',
          onSubmit: _handleSubmit),
      backgroundColor: Colors.white,
    );
  }
}
