import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final bool obscureText;
  final String label;
  final TextEditingController controller;
  final String placeholder;
  final Function onChanged;

  TextInput(
      {this.controller,
      this.label,
      this.placeholder,
      this.onChanged,
      this.obscureText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).accentColor.withAlpha(0x22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return placeholder ?? 'Please enter some text';
        }
        return null;
      },
      controller: controller,
    );
  }
}
