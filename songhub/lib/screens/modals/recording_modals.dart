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
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: RecordingModal(song: args.song, isAdd: true),
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
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: RecordingModal(song: args.song, isAdd: false),
      backgroundColor: Colors.white,
    );
  }
}

class RecordingModal extends StatefulWidget {
  final Song song;
  final bool isAdd;

  RecordingModal({this.song, this.isAdd});

  @override
  _RecordingModalState createState() => _RecordingModalState(song: song);
}

class _RecordingModalState extends State<RecordingModal> {
  final bool isAdd;
  final Song song;

  _RecordingModalState({this.song, this.isAdd});

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
    selectedStatus = "Idea";
    _versionDescriptionController = TextEditingController();
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
  void _handleSubmit() async {
    final FirebaseUser user = await _auth.currentUser();

    if (_formKey.currentState.validate()) {
      final recordingId = Uuid().v4();
      storagePath = await _storage.uploadRecording(
          song.id,
          recordingId,
          recordingFile,
          FileUserPermissions(
              owner: user.uid, participants: song.participants));
      final recording = Recording(
        id: recordingId,
        label: selectedStatus,
        image: user.uid,
        storagePath: storagePath,
        timestamp: Timestamp.fromDate(DateTime.now().toUtc()),
        versionDescription: _versionDescriptionController.text,
      );
      await _db.upsertRecording(song.id, recording);
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
            Image.asset("assets/hero_recording_small.jpg"),
            _buildRow(
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: getFile,
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    color: Theme.of(context).accentColor.withAlpha(0x22),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add_circle,
                            color: Theme.of(context).hintColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(recordingFile != null
                              ? Path.basename(recordingFile.path).toString()
                              : "Select file"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildRow(
              DropdownInput(
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
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
