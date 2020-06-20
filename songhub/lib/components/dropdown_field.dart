import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final String value;
  final Function onChanged;
  final String initialValue;

  DropdownInput(
      {this.items, this.icon, this.value, this.onChanged, this.initialValue});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
        fillColor: Theme.of(context).accentColor.withAlpha(0x22),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).hintColor,
              )
            : null,
      ),
      child: DropdownButtonFormField<String>(
        isDense: true,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
        ),
        value: value != null && value != "" ? value : initialValue,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
