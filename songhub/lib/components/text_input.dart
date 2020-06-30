import 'package:flutter/material.dart';

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
  final Function onPressed;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  MessageForm({this.onPressed, this.controller, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Theme.of(context).accentColor.withAlpha(0x22),
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
                    onPressed: () => onPressed(context),
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
