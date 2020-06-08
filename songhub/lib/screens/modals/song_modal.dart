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

import '../../routing.dart';

class SongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    final SongModalRouteParams args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SongForm(song: args.song),
      backgroundColor: Colors.white,
    );
  }
}

class _SongFormState extends State<SongForm> {
  final Song song;

  _SongFormState({this.song});

  final _db = DatabaseService();
  final _storage = StorageService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController,
      _artistController,
      _lyricsController,
      _moodController;

  String currentStatus = "Initiation";
  List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];
  File imageFile;
  bool valid;
  String buttonText;

  /// Init state
  @override
  void initState() {
    if (song != null) {
      buttonText = "SAVE";
      _titleController = TextEditingController(text: song.title);
      _artistController = TextEditingController(text: song.artist);
      _lyricsController = TextEditingController(text: song.lyrics);
      _moodController = TextEditingController(text: song.mood);
    } else {
      buttonText = "CREATE";
    }
    super.initState();
  }

  /// Get image state
  Future getImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  /// Push data to firebase if forms are valid
  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      String imageUrl = await _storage.uploadFile("covers", imageFile);
      _db.upsertSong(Song(
          title: _titleController.text,
          artist: _artistController.text,
          coverImg: imageUrl,
          participants: [],
          lyrics: _lyricsController.text,
          mood: _moodController.text));
    }
  }

  /// Dispose forms
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
                  text: buttonText,
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

class SongForm extends StatefulWidget {
  final Song song;

  SongForm({this.song});

  @override
  _SongFormState createState() {
    return _SongFormState(song: song);
  }
}
