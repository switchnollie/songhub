import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddSongModal extends StatelessWidget {
  static const routeId = "/songs/new";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          new FlatButton(
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
  InformationForm createState() {
    return InformationForm();
  }
}

class InformationForm extends State<AddSongForm> {
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
            GeneralTextForm(label: "Lyrics"),
            GeneralTextForm(label: "Mood"),
          ],
        ),
      ),
    );
  }
}

class GeneralTextForm extends StatelessWidget {
  final String label;

  const GeneralTextForm({this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}
