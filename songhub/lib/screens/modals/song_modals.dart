import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:uuid/uuid.dart';

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

class SongForm extends StatefulWidget {
  final Song song;
  final bool isAdd;

  SongForm({this.song, this.isAdd});

  @override
  _SongFormState createState() {
    return _SongFormState(song: song, isAdd: isAdd);
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

  File imageFile;
  String buttonText, selectedStatus, imageUrl;

  /// Init state
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.song?.title ?? "");
    _artistController = TextEditingController(text: widget.song?.artist ?? "");
    _lyricsController = TextEditingController(text: widget.song?.lyrics ?? "");
    _moodController = TextEditingController(text: widget.song?.mood ?? "");
    selectedStatus = widget.song?.status;
    imageUrl = widget.song?.coverImg;
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
  void _handleSubmit(Song song, bool isAdd) async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if (_formKey.currentState.validate()) {
      if (isAdd) {
        final String songId = Uuid().v4();
        final List<String> participants = [
          // TODO: Add real participants
          "ypVCXwADSWSToxsRpyspWWAHNfJ2",
          "dMxDgggEyDTYgkcDW8O6MMOPNiD2"
        ];
        if (imageFile != null) {
          imageUrl = await _storage.uploadCoverImg(songId, imageFile,
              FileUserPermissions(owner: user.uid, participants: participants));
        }
        _db.addSong(Song(
            id: songId,
            title: _titleController.text,
            artist: _artistController.text,
            coverImg: imageUrl,
            participants: participants,
            lyrics: _lyricsController.text,
            status: selectedStatus,
            mood: _moodController.text,
            ownedBy: user.uid));
      } else {
        if (imageFile != null) {
          imageUrl = await _storage.uploadCoverImg(
              song.id,
              imageFile,
              FileUserPermissions(
                  owner: user.uid, participants: song.participants));
        }
        _db.upsertSong(Song(
            id: song.id,
            title: _titleController.text,
            artist: _artistController.text,
            coverImg: imageUrl,
            // participants: song.participants,
            lyrics: _lyricsController.text,
            status: selectedStatus,
            mood: _moodController.text));
      }
      Navigator.pop(context);
    }
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
                  text: widget.isAdd ? "CREATE" : "SAVE",
                  onPressed: () => _handleSubmit(song, isAdd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
