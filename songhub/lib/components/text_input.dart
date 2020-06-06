import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final bool obscureText;
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String placeholder;
  final Function onChanged;
  final IconData icon;
  final Function validator;
  final String initialValue;

  TextInput({
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
      initialValue: initialValue != null ? initialValue : null,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Theme.of(context).accentColor.withAlpha(0x1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).hintColor,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        hintText: hintText,
      ),
      validator: validator,
      controller: controller,
    );
  }
}
