// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';

/// A component to input and validate text
class TextInput extends StatelessWidget {
  final bool obscureText;
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function onChanged;
  final IconData icon;
  final Function validator;
  final String initialValue;
  final bool isMultiline;

  TextInput({
    this.controller,
    @required this.label,
    this.onChanged,
    this.obscureText = false,
    this.icon,
    this.hintText,
    this.validator,
    this.initialValue,
    this.isMultiline = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 6.0),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onBackground)),
        ),
        TextFormField(
          keyboardType:
              isMultiline ? TextInputType.multiline : TextInputType.text,
          maxLines: isMultiline ? null : 1,
          initialValue: initialValue != null ? initialValue : null,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            alignLabelWithHint: true,
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onBackground,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: Theme.of(context).accentColor, width: 2.0),
            ),
            hintText: hintText,
          ),
          validator: validator,
          controller: controller,
        ),
      ],
    );
  }
}

class MessageForm extends StatelessWidget {
  // final Function onPressed;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final BuildContext context;

  MessageForm({this.controller, this.formKey, this.context});

  /// Handle message input submit
  void _handleSubmit(BuildContext context, SongDetailsViewModel vm) async {
    if (formKey.currentState.validate()) {
      try {
        await vm.createMessage(controller.text);
        controller.clear();
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Form(
              key: formKey,
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
                    onPressed: () => _handleSubmit(context, vm),
                  )
                ],
              ),
            ),
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
    return TextFormField(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      initialValue: initialValue != null ? initialValue : null,
      obscureText: obscureText ?? false,
      cursorColor: Theme.of(context).colorScheme.onSecondary,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        fillColor: Theme.of(context).colorScheme.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
      validator: validator,
      controller: controller,
    );
  }
}
