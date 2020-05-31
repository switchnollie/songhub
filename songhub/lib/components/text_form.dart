import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final TextEditingController titleController;
  final String label;
  final double pad;

  const TextForm({this.titleController, this.label, this.pad});

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