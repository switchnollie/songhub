import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/components/dropdown_field.dart';
import 'package:song_hub/components/image_input.dart';
import 'package:song_hub/components/text_input.dart';
import 'package:song_hub/services/db_service.dart';

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
            // AddCoverImage(),
            ImageInput(),
            Expanded(
              child: Column(
                children: <Widget>[
                  TextInput(controller: _titleController, label: "Title"),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextInput(controller: _artistController, label: "Artist"),
                  ),
                ],
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: DropDownInput(statusItems: ["Initiation", "Idea", "Demo", "Release"]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextInput(controller: _lyricsController, label: "Lyrics"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextInput(controller: _moodController, label: "Mood"),
          ),
          AddSongButton(
            db: _db,
            titleController: _titleController,
            artistController: _artistController,
            statusValue: currentStatus,
            lyricsController: _lyricsController,
            moodController: _moodController,
          ),
        ],
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

class AddSongButton extends StatelessWidget {
  final DatabaseService db;
  final TextEditingController titleController,
      artistController,
      lyricsController,
      moodController;
  final String statusValue;

  const AddSongButton(
      {this.db,
      this.titleController,
      this.artistController,
      this.statusValue,
      this.lyricsController,
      this.moodController});

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
              // db.addSongDocument(
              //   titleController.text, artistController.text, statusValue, lyricsController.text, moodController.text
              //   );
            },
          )),
    );
  }
}

// class LyricsFormEntry extends StatelessWidget {
//   final TextEditingController titleController;
//   final double pad;

//   const LyricsFormEntry({this.titleController, this.pad});

//   final bool _validate = false;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: pad == null ? 16.0 : pad),
//       child: Container(
//         height: 54,
//         child: TextField(
//           controller: titleController,
//           keyboardType: TextInputType.multiline,
//           minLines: 1,
//           maxLines: null,
//           decoration: InputDecoration(
//             fillColor: Color(0xFFF2F5FA),
//             filled: true,
//             border: InputBorder.none,
//             // border: OutlineInputBorder(),
//             labelText: "Lyrics",
//             errorText: _validate ? "Value can\'t be empty!" : null,
//           ),
//         ),
//       ),
//     );
//   }
// }