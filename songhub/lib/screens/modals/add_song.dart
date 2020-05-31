import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/components/text_input.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          FlatButton(
            onPressed: () {
            },
            child: Text("SAVE"),
          )
        ],
      ),
      body: AddSongForm(),
    );
  }
}

class AddSongForm extends StatefulWidget {
  @override
  _AddSongFormState createState() {
    return _AddSongFormState();
  }
}

class _AddSongFormState extends State<AddSongForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextInput(label: "Lyrics"),
            TextInput(label: "Mood"),
          ],
        ),
      ),
    );
  }
}
