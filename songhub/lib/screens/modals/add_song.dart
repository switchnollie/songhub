import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: AddSongForm(),
      backgroundColor: Colors.white,
    );
  }
}

class _AddSongFormState extends State<AddSongForm> {
  final _db = DatabaseService();
  final _storage = StorageService();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _moodController = TextEditingController();

  String currentStatus = "Initiation";
  List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];

  File imageFile;
  bool valid;

  Future getImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      String imageUrl = await _storage.uploadFile("covers", imageFile);
      _db.addSongDocument(Song(
          title: _titleController.text,
          artist: _artistController.text,
          coverImg: imageUrl,
          participants: [],
          lyrics: _lyricsController.text,
          mood: _moodController.text));
    }
  }

  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _lyricsController.dispose();
    _moodController.dispose();
    super.dispose();
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
                    ImageInput(imageFile: imageFile, callback: getImage),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextInput(
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: DropDownInput(
                  statusItems: ["Initiation", "Idea", "Demo", "Release"],
                  icon: Icons.label,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextInput(
                  controller: _lyricsController,
                  label: "Lyrics",
                  icon: Icons.subject,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextInput(
                  controller: _moodController,
                  label: "Mood",
                  icon: Icons.mood,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: PrimaryButton(
                  text: "Create",
                  onPressed: () { 
                    _handleSubmit();
                    Navigator.pop(context);
                    },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddSongForm extends StatefulWidget {
  @override
  _AddSongFormState createState() {
    return _AddSongFormState();
  }
}
