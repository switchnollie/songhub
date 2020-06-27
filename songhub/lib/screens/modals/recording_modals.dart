import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class AddRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/add";
  @override
  Widget build(BuildContext context) {
    final RecordingModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add recording'),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: RecordingModal(song: args.song, recording: null, isAdd: true),
      backgroundColor: Colors.white,
    );
  }
}

class EditRecordingModal extends StatelessWidget {
  static const routeId = "/recordings/edit";
  @override
  Widget build(BuildContext context) {
    final RecordingModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit recording"),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: RecordingModal(
          song: args.song, recording: args.recording, isAdd: false),
      backgroundColor: Colors.white,
    );
  }
}

class RecordingModal extends StatefulWidget {
  final Song song;
  final Recording recording;
  final bool isAdd;

  RecordingModal({this.song, this.recording, this.isAdd});

  @override
  _RecordingModalState createState() =>
      _RecordingModalState(song: song, recording: recording, isAdd: isAdd);
}

class _RecordingModalState extends State<RecordingModal> {
  final Song song;
  final Recording recording;
  final bool isAdd;

  _RecordingModalState({this.song, this.recording, this.isAdd});

  final _formKey = GlobalKey<FormState>();
  final _storage = StorageService();
  final _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File recordingFile;
  String selectedStatus, storagePath;
  TextEditingController _versionDescriptionController;

  /// Init state
  @override
  void initState() {
    selectedStatus = widget.recording?.label;
    _versionDescriptionController =
        TextEditingController(text: widget.recording?.versionDescription ?? '');
    super.initState();
  }

  /// Dispose contents
  @override
  void dispose() {
    _versionDescriptionController.dispose();
    super.dispose();
  }

  /// Get file from picker
  void getFile() async {
    final File file = await FilePicker.getFile();
    if (file != null) {
      setState(() {
        recordingFile = File(file.path);
      });
    }
  }

  /// Handle button submit
  void _handleSubmit(
      BuildContext context, bool isAdd, Recording recording) async {
    final FirebaseUser user = await _auth.currentUser();

    if (_formKey.currentState.validate()) {
      if (isAdd) {
        final recordingId = Uuid().v4();
        if (recordingFile != null) {
          storagePath = await _storage.uploadRecording(
              song.id,
              recordingId,
              recordingFile,
              FileUserPermissions(
                  owner: user.uid, participants: song.participants));
        }
        final recording = Recording(
          id: recordingId,
          label: selectedStatus,
          creator: user.uid,
          storagePath: storagePath,
          createdAt: Timestamp.fromDate(DateTime.now().toUtc()),
          versionDescription: _versionDescriptionController.text,
        );
        await _db.createRecording(song, recording);
      } else {
        if (recordingFile != null) {
          storagePath = await _storage.uploadRecording(
              song.id,
              recording.id,
              recordingFile,
              FileUserPermissions(
                  owner: user.uid, participants: song.participants));
        }
        final updatedRecording = Recording(
          id: recording.id,
          label: selectedStatus != recording.label
              ? selectedStatus
              : recording.label,
          creator: recording.creator,
          storagePath:
              storagePath != recording.storagePath && storagePath != null
                  ? storagePath
                  : recording.storagePath,
          // TODO: Created or last updated?
          createdAt: recording.createdAt,
          updatedAt: Timestamp.fromDate(DateTime.now().toUtc()),
          versionDescription:
              _versionDescriptionController.text != recording.versionDescription
                  ? _versionDescriptionController.text
                  : recording.versionDescription,
        );
        await _db.updateRecording(song, updatedRecording);
      }
    }
    Navigator.pop(context);
  }

  /// Build form row
  Widget _buildRow(Widget wrappedWidget) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: wrappedWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Hero(
              tag: "file",
              child: Material(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset("assets/hero_recording_small.jpg"),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: getFile,
                    )
                  ],
                ),
              ),
            ),
            _buildRow(
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).hintColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.audiotrack,
                          color: Theme.of(context).hintColor),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        // TODO : Not working atm
                        child: Text(recordingFile != null
                            ? "File: " +
                                Path.basename(recordingFile.path).toString()
                            : recording != null
                                ? Path.basename(recording.storagePath)
                                    .toString()
                                : "File:"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildRow(
              DropdownInput(
                // TODO: Define other labels?
                items: ["Idea", "Lyrics", "Voice memo", "Demo tape"],
                icon: Icons.label,
                value: selectedStatus,
                onChanged: (newVal) {
                  setState(() {
                    selectedStatus = newVal;
                  });
                },
              ),
            ),
            _buildRow(
              TextInput(
                controller: _versionDescriptionController,
                label: "Description",
                icon: Icons.chat_bubble,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an label';
                  }
                  return null;
                },
              ),
            ),
            _buildRow(
              PrimaryButton(
                text: widget.isAdd ? "CREATE" : "SAVE",
                onPressed: () => _handleSubmit(context, isAdd, recording),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
