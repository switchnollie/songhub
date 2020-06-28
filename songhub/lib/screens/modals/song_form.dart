import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

typedef void OnSubmit({
  @required GlobalKey<FormState> formKey,
  @required BuildContext context,
  String title,
  String artist,
  String lyrics,
  String mood,
  File imageFile,
  String status,
  String songId,
  List<String> participants,
});

class SongForm extends StatefulWidget {
  final SongWithImages song;
  final OnSubmit onSubmit;
  final String submitButtonText;

  SongForm({this.song, this.onSubmit, this.submitButtonText});

  @override
  _SongFormState createState() {
    return _SongFormState();
  }
}

class _SongFormState extends State<SongForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController,
      _artistController,
      _lyricsController,
      _moodController;

  File imageFile;
  String selectedStatus, imageUrl;

  /// Init state
  @override
  void initState() {
    _titleController =
        TextEditingController(text: widget.song?.songDocument?.title ?? "");
    _artistController =
        TextEditingController(text: widget.song?.songDocument?.artist ?? "");
    _lyricsController =
        TextEditingController(text: widget.song?.songDocument?.lyrics ?? "");
    _moodController =
        TextEditingController(text: widget.song?.songDocument?.mood ?? "");
    selectedStatus = widget.song?.songDocument?.status;
    imageUrl = widget.song?.coverImgUrl;
    super.initState();
  }

  void _handleImagePicked(PickedFile image) async {
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  /// Push data to firebase if form fields are valid
  void _handleSubmit(BuildContext context) {
    widget.onSubmit(
      formKey: _formKey,
      title: _titleController.text,
      artist: _artistController.text,
      imageFile: imageFile,
      lyrics: _lyricsController.text,
      status: selectedStatus,
      mood: _moodController.text,
      songId: widget.song.songDocument.id,
      participants: widget.song.songDocument.participants,
      context: context,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _lyricsController.dispose();
    _moodController.dispose();
    super.dispose();
  }

  Widget _buildRow(Widget wrappedWidget) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: wrappedWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // AddCoverImage(),
                    ImageInput(
                        imageFile: imageFile,
                        onPicked: _handleImagePicked,
                        imageUrl: imageUrl),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TextInput(
                            controller: _titleController,
                            label: "Title",
                            icon: Icons.title,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          _buildRow(
                            TextInput(
                              controller: _artistController,
                              label: "Artist",
                              icon: Icons.person,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an artist';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
              _buildRow(
                DropdownInput(
                  items: ["Initiation", "Idea", "Demo", "Release"],
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
                  controller: _lyricsController,
                  label: "Lyrics",
                  icon: Icons.subject,
                ),
              ),
              _buildRow(
                TextInput(
                  controller: _moodController,
                  label: "Mood",
                  icon: Icons.mood,
                ),
              ),
              _buildRow(
                PrimaryButton(
                  text: widget.submitButtonText,
                  onPressed: () => _handleSubmit(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
