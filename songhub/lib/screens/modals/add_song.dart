import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _moodController = TextEditingController();

  String currentStatus = "Initiation";
  List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];

  Future<File> imageFile;

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
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // AddCoverImage(),
                  ImageInput(imageFile: imageFile),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextInput(controller: _titleController, label: "Title"),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TextInput(
                              controller: _artistController, label: "Artist"),
                        ),
                      ],
                    ),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: DropDownInput(
                  statusItems: ["Initiation", "Idea", "Demo", "Release"]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextInput(controller: _lyricsController, label: "Lyrics"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextInput(controller: _moodController, label: "Mood"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: PrimaryButton(
                  text: "Create",
                  onPressed: () {
                    // _storage.uploadFile(collection, _image),
                    _db.addSongDocument(Song(
                        title: _titleController.text,
                        artist: _artistController.text,
                        coverImg: "",
                        participants: [],
                        lyrics: _lyricsController.text,
                        mood: _moodController.text));
                  Navigator.pop(context);
                  }),
            ),
          ],
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