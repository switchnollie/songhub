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
import 'package:song_hub/routing.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/add";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SongForm(song: null, isAdd: true),
      backgroundColor: Colors.white,
    );
  }
}

class EditSongModal extends StatelessWidget {
  static const routeId = "/songs/edit";
  @override
  Widget build(BuildContext context) {
    final EditSongModalRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
      ),
      body: SongForm(song: args.song, isAdd: false),
      backgroundColor: Colors.white,
    );
  }
}

class _SongFormState extends State<SongForm> {
  final Song song;
  final bool isAdd;

  _SongFormState({this.song, this.isAdd});

  final _db = DatabaseService();
  final _storage = StorageService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController,
      _artistController,
      _lyricsController,
      _moodController;

  String currentStatus = "Initiation";
  File imageFile;
  bool valid;
  String buttonText, dropDownStatus, imageUrl;

  /// Init state
  @override
  void initState() {
    if (song != null) {
      _titleController = TextEditingController(text: song.title);
      _artistController = TextEditingController(text: song.artist);
      _lyricsController = TextEditingController(text: song.lyrics);
      _moodController = TextEditingController(text: song.mood);
      dropDownStatus = song.status;
      imageUrl = song.coverImg;
    }
    super.initState();
  }

  /// Get image state
  Future getImage() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxHeight: 300, maxWidth: 300);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  /// Push data to firebase if form fields are valid
  void _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      if (imageFile != null) {
        imageUrl = await _storage.uploadFile(
            "covers", imageFile, imageFile.toString());
      }
      _db.upsertSong(Song(
          title: _titleController.text,
          artist: _artistController.text,
          coverImg: imageUrl,
          participants: [
            // TODO: Add real participants
            "ypVCXwADSWSToxsRpyspWWAHNfJ2",
            "dMxDgggEyDTYgkcDW8O6MMOPNiD2"
          ],
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
                    ImageInput(
                        imageFile: imageFile,
                        callback: getImage,
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
                  value: dropDownStatus,
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
                  text: isAdd ? "CREATE" : "SAVE",
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
  final bool isAdd;

  SongForm({this.song, this.isAdd});

  @override
  _SongFormState createState() {
    return _SongFormState(song: song, isAdd: isAdd);
  }
}
