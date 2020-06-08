import 'package:flutter/material.dart';

class _DropDownInputState extends State<DropDownInput> {
  String value;
  final IconData icon;
  final List<String> statusItems;

  _DropDownInputState({this.statusItems, this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
        hintText: 'Please select expense',
        fillColor: Theme.of(context).accentColor.withAlpha(0x22),
        filled: true,
        border: InputBorder.none,
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).hintColor,
              )
            : null,
      ),
      // OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: value != null ? value : "Initiation",
          onChanged: (String newValue) {
            setState(() {
              value = newValue;
            });
          },
          items: statusItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DropDownInput extends StatefulWidget {
  final List<String> statusItems;
  final IconData icon;
  final String value;

  DropDownInput({this.statusItems, this.icon, this.value});

  _DropDownInputState createState() =>
      _DropDownInputState(statusItems: statusItems, icon: icon, value: value);
}
