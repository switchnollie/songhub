import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/read_only_field.dart';
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
  final String appBarTitle;
  final IconButton appBarAction;

  RecordingModal(
      {@required this.song,
      @required this.recording,
      @required this.submitButtonText,
      @required this.onSubmit,
      @required this.index,
      @required this.appBarTitle,
      this.appBarAction});

  @override
  _RecordingModalState createState() => _RecordingModalState();
}

class _RecordingModalState extends State<RecordingModal> {
  final _formKey = GlobalKey<FormState>();

  File recordingFile;
  Label selectedLabel;
  String storagePath;
  TextEditingController _versionDescriptionController;

  /// Init state
  @override
  void initState() {
    selectedLabel =
        widget.recording != null ? widget.recording.label : Label.Idea;
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

  /// Build form row
  Widget _buildRow(Widget wrappedWidget) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: wrappedWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = mappedLabels.entries.map((e) => e.key).toList();
    return Container(
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Stack(
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
                            icon: Icon(
                              Icons.add,
                              size: 32,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: getFile,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                CustomAppBar(
                    title: widget.appBarTitle,
                    backIcon: Icons.close,
                    isHeader: false,
                    isTransparent: true,
                    action: widget.appBarAction),
              ],
            ),
            _buildRow(
              ReadOnlyField(
                  label: 'File',
                  icon: Icons.audiotrack,
                  text: recordingFile != null
                      ? Path.basename(recordingFile.path).toString()
                      : widget.recording != null
                          ? Path.basename(widget.recording.storagePath)
                              .toString()
                          : ''),
            ),
            _buildRow(
              DropdownInput(
                label: 'Label',
                items: labels,
                icon: Icons.label,
                value: selectedLabel.value,
                onChanged: (newVal) {
                  setState(() {
                    selectedLabel = mappedLabels[newVal];
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
                      selectedLabel,
                      _versionDescriptionController.text,
                      widget.recording)),
            ),
          ],
        ),
      )),
    );
  }
}
