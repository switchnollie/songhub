import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/models.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class RecordingModal extends StatefulWidget {
  final SongWithImages song;
  final Recording recording;
  final String submitButtonText;
  final Function onSubmit;
  final String index;

  RecordingModal(
      {@required this.song,
      @required this.recording,
      @required this.submitButtonText,
      @required this.onSubmit,
      @required this.index});

  @override
  _RecordingModalState createState() => _RecordingModalState();
}

class _RecordingModalState extends State<RecordingModal> {
  final _formKey = GlobalKey<FormState>();

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

  // TODO:? Doesn't has custom data structure OnSubmit like song

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
              tag: widget.index,
              child: Material(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset("assets/hero_recording.jpg"),
                    Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight),
                      child: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: getFile,
                      ),
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
                        child: Text(recordingFile != null
                            ? "File: " +
                                Path.basename(recordingFile.path).toString()
                            : widget.recording != null
                                ? Path.basename(widget.recording.storagePath)
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
                  text: widget.submitButtonText,
                  onPressed: () => widget.onSubmit(
                      context,
                      _formKey,
                      recordingFile,
                      storagePath,
                      widget.song,
                      selectedStatus,
                      _versionDescriptionController.text,
                      widget.recording)),
            ),
          ],
        ),
      )),
    );
  }
}
