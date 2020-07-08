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
  String _selectedStatus, _selectedGenre, _imageUrl;
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
    _titleController =
        TextEditingController(text: widget.song?.songDocument?.title ?? '');
    _lyricsController =
        TextEditingController(text: widget.song?.songDocument?.lyrics ?? '');
    _moodController =
        TextEditingController(text: widget.song?.songDocument?.mood ?? '');
    _suggestionsController = TextEditingController();
    _selectedStatus =
        widget.song != null ? widget.song.songDocument.status : 'Initiation';
    _selectedGenre =
        widget.song != null ? widget.song.songDocument.genre : 'Pop';

    _imageUrl = widget.song?.coverImgUrl;
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
    return (await database.getUsersByEmail(email))
        .where((user) => user.id != database.uid)
        .toList();
  }

  Future<List<User>> _getUsersById(
      BuildContext context, List<String> participantIds) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return (await database.getUsersById(participantIds))
        .where((user) => user.id != database.uid)
        .toList();
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
    final uid = Provider.of<FirestoreDatabase>(context, listen: false).uid;
    List<String> participantIds = [];
    participantIds = selectedParticipants.map((user) => user.id).toList()
      ..insert(0, uid);

    widget.onSubmit(
      formKey: _formKey,
      title: _titleController.text,
      artist: widget.song != null
          ? widget.song.songDocument.artist
          : widget.stageName,
      imageFile: imageFile,
      lyrics: _lyricsController.text,
      status: _selectedStatus,
      mood: _moodController.text,
      genre: _selectedGenre,
      participants: participantIds,
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
                            imageUrl: _imageUrl,
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
                                  text: widget.song?.songDocument?.artist)),
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
                            if (suggestions == null) {
                              return [];
                            }
                            return suggestions;
                          },
                          onSelected: (suggestion) {
                            // reset text in form field
                            _suggestionsController.clear();
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
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    label: Text(participant.stageName),
                                    deleteIconColor:
                                        Theme.of(context).primaryColor,
                                    onDeleted: widget
                                                .song?.songDocument?.ownedBy ==
                                            participant.id
                                        ? null
                                        : () =>
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
                      value: _selectedGenre,
                      onChanged: (newVal) {
                        setState(() {
                          _selectedGenre = newVal;
                        });
                      },
                    ),
                  ),
                  _buildRow(
                    DropdownInput(
                      label: 'Status',
                      items: statuses,
                      icon: Icons.calendar_today,
                      value: _selectedStatus,
                      onChanged: (newVal) {
                        setState(() {
                          _selectedStatus = newVal;
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
