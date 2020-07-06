import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/autocomplete_textfield.dart';
import 'package:song_hub/components/buttons.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/read_only_field.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firestore_database.dart';
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
  String genre,
  List<String> participants,
});

class SongForm extends StatefulWidget {
  final String appBarTitle;
  final IconButton appBarAction;
  final SongWithImages song;
  final OnSubmit onSubmit;
  final String submitButtonText;
  final String stageName;

  SongForm(
      {this.song,
      this.onSubmit,
      this.submitButtonText,
      this.appBarAction,
      this.appBarTitle,
      this.stageName});

  @override
  _SongFormState createState() {
    return _SongFormState();
  }
}

class _SongFormState extends State<SongForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController,
      _lyricsController,
      _moodController,
      _suggestionsController;

  File imageFile;
  String selectedStatus, selectedGenre, imageUrl, artist;
  List<String> statuses = ['Initiation', 'Idea', 'Demo', 'Release'];
  List<User> selectedParticipants = [];
  List<String> genres = [
    'Pop',
    'Rock',
    'Electro',
    'House',
    'Hip-Hop',
    'Classic',
    'R&B',
    'Soul',
    'Metal',
  ];

  /// Init state
  @override
  void initState() {
    artist = widget.song != null
        ? widget.song.songDocument.artist
        : widget.stageName;
    _titleController =
        TextEditingController(text: widget.song?.songDocument?.title ?? '');
    _lyricsController =
        TextEditingController(text: widget.song?.songDocument?.lyrics ?? '');
    _moodController =
        TextEditingController(text: widget.song?.songDocument?.mood ?? '');
    _suggestionsController = TextEditingController();
    selectedStatus =
        widget.song != null ? widget.song.songDocument.status : 'Initiation';
    selectedGenre =
        widget.song != null ? widget.song.songDocument.genre : 'Pop';

    imageUrl = widget.song?.coverImgUrl;
    Future.delayed(Duration.zero, () async {
      final participants = widget.song?.songDocument?.participants;
      if (participants != null && participants.length > 0) {
        List<User> fetchedParticipants =
            await _getUsersById(context, participants);
        setState(() {
          selectedParticipants = fetchedParticipants;
        });
      } else {
        selectedParticipants = [];
      }
    });
    super.initState();
  }

  Future<List<User>> _getUserSuggestionsByEmailSubstr(
      BuildContext context, String email) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return await database.getUsersByEmail(email);
  }

  Future<List<User>> _getUsersById(
      BuildContext context, List<String> participantIds) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return await database.getUsersById(participantIds);
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
      artist: artist,
      imageFile: imageFile,
      lyrics: _lyricsController.text,
      status: selectedStatus,
      mood: _moodController.text,
      genre: selectedGenre,
      songId: widget.song.songDocument.id,
      participants: widget.song.songDocument.participants,
      context: context,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
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

  _handleChipDelete(String deletedUid) {
    setState(() {
      selectedParticipants = selectedParticipants
          .where((participant) => participant.id != deletedUid)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CustomAppBar(
            title: widget.appBarTitle,
            action: widget.appBarAction,
            backIcon: Icons.close,
            isHeader: false,
            isTransparent: false,
          ),
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
                            imageUrl: imageUrl,
                            label: 'Cover'),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              TextInput(
                                controller: _titleController,
                                label: 'Title',
                                icon: Icons.title,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              _buildRow(ReadOnlyField(
                                icon: Icons.face,
                                label: 'Author',
                                text: widget.song != null
                                    ? widget.song.songDocument.artist
                                    : artist,
                              )),
                            ],
                          ),
                        ),
                      ]),
                  _buildRow(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutocompleteTextField(
                          label: "Participants",
                          hintText: "Search by email to get suggestions...",
                          controller: _suggestionsController,
                          itemBuilder: (context, suggestion) {
                            if (suggestion != null) {
                              return ListTile(
                                leading: Icon(Icons.person),
                                title: Text(suggestion.email),
                                subtitle: Text(suggestion.stageName),
                              );
                            }
                            return null;
                          },
                          onChanged: (pattern) async {
                            final suggestions =
                                await _getUserSuggestionsByEmailSubstr(
                                    context, pattern);
                            print(suggestions);
                            if (suggestions == null) {
                              return [];
                            }
                            return suggestions;
                          },
                          onSelected: (suggestion) {
                            setState(() {
                              selectedParticipants.add(suggestion);
                            });
                          },
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          children: selectedParticipants
                              .map((participant) => Chip(
                                    label: Text(participant.stageName),
                                    onDeleted: () =>
                                        _handleChipDelete(participant.id),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  _buildRow(
                    DropdownInput(
                      label: 'Genre',
                      items: genres,
                      icon: Icons.graphic_eq,
                      value: selectedGenre,
                      onChanged: (newVal) {
                        setState(() {
                          selectedGenre = newVal;
                        });
                      },
                    ),
                  ),
                  _buildRow(
                    DropdownInput(
                      label: 'Status',
                      items: statuses,
                      icon: Icons.calendar_today,
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
                      label: 'Lyrics',
                      icon: Icons.subject,
                      isMultiline: true,
                    ),
                  ),
                  _buildRow(
                    TextInput(
                      controller: _moodController,
                      label: 'Mood',
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
        ],
      ),
    );
  }
}
