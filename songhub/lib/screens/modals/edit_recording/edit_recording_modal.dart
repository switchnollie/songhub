// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:song_hub/models/models.dart';
// import 'package:song_hub/routing.dart';
// import 'package:song_hub/screens/modals/recording_form.dart';
// import 'package:song_hub/services/firestore_database.dart';
// import 'package:song_hub/services/storage_service.dart';
// import 'package:song_hub/utils/show_snackbar.dart';
// import 'package:song_hub/viewModels/song_with_images.dart';
// import 'package:uuid/uuid.dart';

// class EditRecordingModal extends StatelessWidget {
//   static const routeId = "/recordings/edit";

//   void handleSubmit({
//     @required GlobalKey<FormState> formKey,
//     @required BuildContext context,
//     String id,
//     String label,
//     String creator,
//     File recordingFile,
//     Timestamp createdAt,
//     Timestamp updatedAt,
//     String versionDescription,
//     String storagePath,
//     SongWithImages song,
//   }) async {
//     try {
//       final database = Provider.of<FirestoreDatabase>(context, listen: false);
//       final storageService =
//           Provider.of<StorageService>(context, listen: false);
//       if (formKey.currentState.validate()) {
//         final String recordingId = Uuid().v4();
//         if (recordingFile != null) {
//           storagePath = await storageService.uploadRecording(
//               song.songDocument.id,
//               recordingId,
//               recordingFile,
//               FileUserPermissions(
//                   owner: database.uid,
//                   participants: song.songDocument.participants));
//         }
//         final recording = Recording(
//           id: recordingId,
//           label: label,
//           creator: database.uid,
//           storagePath: storagePath,
//           createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
//           updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
//           versionDescription: versionDescription,
//         );
//         database.setRecording(recording, song.songDocument.id);
//       }
//       Navigator.pop(context, "Successfully updated recording");
//     } catch (err) {
//       // use 'on' clause and handle errors in more detail
//       showSnackBarByContext(context, "Error submitting data");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final RecordingModalRouteParams args =
//         ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit recording'),
//         leading: IconButton(
//           icon: Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         elevation: 0.0,
//       ),
//       body: RecordingForm(
//         song: args.song,
//         recording: null,
//         submitButtonText: 'SAVE',
//         onSubmit: handleSubmit,
//       ),
//       backgroundColor: Colors.white,
//     );
//   }
// }
