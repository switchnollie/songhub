// TODO: Refactor to use same structure as edit/add_song_modal (seperate recording_form with onSubmit handler as property)
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as Path;
// import 'package:song_hub/components/buttons.dart';
// import 'package:song_hub/components/dropdown_field.dart';
// import 'package:song_hub/components/text_input.dart';
// import 'package:song_hub/models/recording.dart';
// import 'package:song_hub/viewModels/song_with_images.dart';

// typedef void OnSubmit({
//   @required GlobalKey<FormState> formKey,
//   @required BuildContext context,
//   String id,
//   String label,
//   String creator,
//   File recordingFile,
//   Timestamp createdAt,
//   Timestamp updatedAt,
//   String versionDescription,
//   String storagePath,
//   SongWithImages song,
// });

// class RecordingForm extends StatefulWidget {
//   final SongWithImages song;
//   final Recording recording;
//   final OnSubmit onSubmit;
//   final String submitButtonText;

//   RecordingForm(
//       {this.song, this.recording, this.onSubmit, this.submitButtonText});

//   @override
//   _RecordingFormState createState() => _RecordingFormState();
// }

// class _RecordingFormState extends State<RecordingForm> {
//   final _formKey = GlobalKey<FormState>();

//   File recordingFile;
//   String selectedStatus, storagePath;
//   TextEditingController _versionDescriptionController;

//   /// Init state
//   @override
//   void initState() {
//     selectedStatus = widget.recording?.label;
//     _versionDescriptionController =
//         TextEditingController(text: widget.recording?.versionDescription ?? '');
//     super.initState();
//   }

//   /// Get file from picker
//   void getFile() async {
//     final File file = await FilePicker.getFile();
//     if (file != null) {
//       setState(() {
//         recordingFile = File(file.path);
//       });
//     }
//   }

//   /// Push data to Firebase if form fields are valid
//   void _handleSubmit(BuildContext context) {
//     widget.onSubmit(
//       formKey: _formKey,
//       id: widget.recording.id,
//       recordingFile: recordingFile,
//       creator: widget.recording.creator,
//       createdAt: widget.recording.createdAt,
//       updatedAt: widget.recording.updatedAt,
//       label: selectedStatus,
//       storagePath: storagePath,
//       versionDescription: _versionDescriptionController.text,
//       context: context,
//     );
//   }

//   /// Dispose contents
//   @override
//   void dispose() {
//     _versionDescriptionController.dispose();
//     super.dispose();
//   }

//   // /// Handle button submit
//   // void _handleSubmit(
//   //     BuildContext context, bool isAdd, Recording recording) async {
//   //   final database = Provider.of<FirestoreDatabase>(context, listen: false);
//   //   final storageService = Provider.of<StorageService>(context, listen: false);

//   //   if (_formKey.currentState.validate()) {
//   //     if (isAdd) {
//   //       final recordingId = Uuid().v4();
//   //       if (recordingFile != null) {
//   //         storagePath = await storageService.uploadRecording(
//   //             widget.song.songDocument.id,
//   //             recordingId,
//   //             recordingFile,
//   //             FileUserPermissions(
//   //                 owner: database.uid,
//   //                 participants: widget.song.songDocument.participants));
//   //       }
//   //       final recording = Recording(
//   //         id: recordingId,
//   //         label: selectedStatus,
//   //         creator: database.uid,
//   //         storagePath: storagePath,
//   //         createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
//   //         versionDescription: _versionDescriptionController.text,
//   //       );
//   //       await database.setRecording(recording, widget.song.songDocument.id);
//   //     } else {
//   //       if (recordingFile != null) {
//   //         storagePath = await storageService.uploadRecording(
//   //             widget.song.songDocument.id,
//   //             recording.id,
//   //             recordingFile,
//   //             FileUserPermissions(
//   //                 owner: database.uid,
//   //                 participants: widget.song.songDocument.participants));
//   //       }
//   //       final updatedRecording = Recording(
//   //         id: recording.id,
//   //         label: selectedStatus != recording.label
//   //             ? selectedStatus
//   //             : recording.label,
//   //         creator: recording.creator,
//   //         storagePath:
//   //             storagePath != recording.storagePath && storagePath != null
//   //                 ? storagePath
//   //                 : recording.storagePath,
//   //         createdAt: recording.createdAt,
//   //         updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
//   //         versionDescription:
//   //             _versionDescriptionController.text != recording.versionDescription
//   //                 ? _versionDescriptionController.text
//   //                 : recording.versionDescription,
//   //       );
//   //       await database.setRecording(
//   //           updatedRecording, widget.song.songDocument.id);
//   //     }
//   //   }
//   //   Navigator.pop(context);
//   // }

//   /// Build form row
//   Widget _buildRow(Widget wrappedWidget) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
//       child: wrappedWidget,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SingleChildScrollView(
//           child: Form(
//         key: _formKey,
//         child: Column(
//           children: <Widget>[
//             Hero(
//               tag: "file",
//               child: Material(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: <Widget>[
//                     Image.asset("assets/hero_recording_small.jpg"),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: getFile,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             _buildRow(
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(5),
//                 child: Container(
//                   height: 54,
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Theme.of(context).hintColor,
//                       width: 2,
//                     ),
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       Icon(Icons.audiotrack,
//                           color: Theme.of(context).hintColor),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 12.0),
//                         child: Text(recordingFile != null
//                             ? "File: " +
//                                 Path.basename(recordingFile.path).toString()
//                             : widget.recording != null
//                                 ? Path.basename(widget.recording.storagePath)
//                                     .toString()
//                                 : "File:"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             _buildRow(
//               DropdownInput(
//                 // TODO: Define other labels?
//                 items: ["Idea", "Lyrics", "Voice memo", "Demo tape"],
//                 icon: Icons.label,
//                 value: selectedStatus,
//                 onChanged: (newVal) {
//                   setState(() {
//                     selectedStatus = newVal;
//                   });
//                 },
//               ),
//             ),
//             _buildRow(
//               TextInput(
//                 controller: _versionDescriptionController,
//                 label: "Description",
//                 icon: Icons.chat_bubble,
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please enter an label';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             _buildRow(
//               PrimaryButton(
//                 text: widget.submitButtonText,
//                 onPressed: () => _handleSubmit(context),
//               ),
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
