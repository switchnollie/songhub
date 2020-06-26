import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:uuid/uuid.dart';

class TextInput extends StatelessWidget {
  final bool obscureText;
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function onChanged;
  final IconData icon;
  final Function validator;
  final String initialValue;

  TextInput({
    this.controller,
    this.label,
    this.onChanged,
    this.obscureText,
    this.icon,
    this.hintText,
    this.validator,
    this.initialValue,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      child: TextFormField(
        initialValue: initialValue != null ? initialValue : null,
        // obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Theme.of(context).accentColor.withAlpha(0x1E),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  color: Theme.of(context).hintColor,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          ),
          hintText: hintText,
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }
}

class MessageForm extends StatelessWidget {
  final String songId;

  MessageForm({this.songId});

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _db = DatabaseService();

  var controller = TextEditingController();

  void _handleSubmit(BuildContext context) async {
    final FirebaseUser user = await _auth.currentUser();

    if (_formKey.currentState.validate()) {
      final messageId = Uuid().v4();
      await _db.createMessage(
          songId,
          Message(
            id: messageId,
            creator: user.uid,
            content: controller.text,
            creationTime: Timestamp.fromDate(DateTime.now().toUtc()),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Theme.of(context).accentColor.withAlpha(0x2E),
        child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: MessageInput(
                  controller: controller,
                  label: "Type message",
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                ),
                onPressed: () => _handleSubmit(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageInput extends StatelessWidget {
  final bool obscureText;
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String placeholder;
  final Function onChanged;
  final IconData icon;
  final Function validator;
  final String initialValue;

  MessageInput({
    this.controller,
    this.label,
    this.placeholder,
    this.onChanged,
    this.obscureText,
    this.icon,
    this.hintText,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
        ),
        initialValue: initialValue != null ? initialValue : null,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          hintText: hintText,
          fillColor: Colors.white.withAlpha(0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        validator: validator,
        controller: controller,
      ),
    );
  }
}
