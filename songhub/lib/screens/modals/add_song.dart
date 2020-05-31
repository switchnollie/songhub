import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db_service.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // actions: [
        //   new FlatButton(
        //     onPressed: () {
        //     },
        //     child: Text("SAVE"),
        //   )
        // ],
      ),
      body: AddSongForm(),
      backgroundColor: Colors.white,
    );
  }
}

class _AddSongFormState extends State<AddSongForm> {
  final _db = DatabaseService();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _moodController = TextEditingController();
  String currentStatus = "Initiation";
  List<String> statusValues = ["Initiation", "Idea", "Demo", "Release"];

  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            AddCoverImage(),
            Expanded(
              child: Column(
                children: <Widget>[
                  SongFormEntry(
                    titleController: _titleController,
                    label: "Title",
                    pad: 0.0,
                  ),
                  SongFormEntry(
                    titleController: _artistController,
                    label: "Artist",
                  ),
                ],
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: buildStatusField(),
          ),
          LyricsFormEntry(
            titleController: _lyricsController,
          ),
          SongFormEntry(
            titleController: _moodController,
            label: "Mood",
          ),
          AddSongButton(db: _db, titleController: _titleController, artistController: _artistController, statusValue: currentStatus, lyricsController: _lyricsController, moodController: _moodController,),
        ],
      ),
    );
  }

  FormField<String> buildStatusField() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            // labelStyle: textStyle,
            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            hintText: 'Please select expense',
            fillColor: Color(0xFFF2F5FA),
            filled: true,
            border: InputBorder.none,
          ),
          // OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: currentStatus == "",
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentStatus,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  currentStatus = newValue;
                  state.didChange(newValue);
                });
              },
              items: statusValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class AddCoverImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: Color(0xFFF2F5FA),
          width: 125,
          height: 125,
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class AddSongButton extends StatelessWidget {
  final DatabaseService db;
  final TextEditingController titleController, artistController, lyricsController, moodController;
  final String statusValue;

  const AddSongButton({
    this.db,
    this.titleController,
    this.artistController,
    this.statusValue,
    this.lyricsController,
    this.moodController
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: SizedBox(
          width: double.infinity,
          height: 54,
          child: RaisedButton(
            textColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                "Create",
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              db.addSongDocument(
                titleController.text, artistController.text, statusValue, lyricsController.text, moodController.text
                );
            },
          )),
    );
  }
}

class SongFormEntry extends StatelessWidget {
  final TextEditingController titleController;
  final String label;
  final double pad;

  const SongFormEntry({this.titleController, this.label, this.pad});

  final bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: pad == null ? 16.0 : pad),
      child: Container(
        height: 54,
        child: TextField(
          controller: titleController,
          decoration: InputDecoration(
            fillColor: Color(0xFFF2F5FA),
            filled: true,
            border: InputBorder.none,
            // border: OutlineInputBorder(),
            labelText: label,
            errorText: _validate ? "Value can\'t be empty!" : null,
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

class LyricsFormEntry extends StatelessWidget {
  final TextEditingController titleController;
  final double pad;

  const LyricsFormEntry({this.titleController, this.pad});

  final bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: pad == null ? 16.0 : pad),
      child: Container(
        height: 54,
        child: TextField(
          controller: titleController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
            fillColor: Color(0xFFF2F5FA),
            filled: true,
            border: InputBorder.none,
            // border: OutlineInputBorder(),
            labelText: "Lyrics",
            errorText: _validate ? "Value can\'t be empty!" : null,
          ),
        ),
      ),
    );
  }
}