import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  final String label;
  final List<String> items;
  final IconData icon;
  final String value;
  final Function onChanged;
  final String initialValue;

  DropdownInput(
      {@required this.label,
      this.items,
      this.icon,
      this.value,
      this.onChanged,
      this.initialValue});

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
        InputDecorator(
          decoration: InputDecoration(
            errorStyle: TextStyle(
                color: Theme.of(context).colorScheme.error, fontSize: 16.0),
            fillColor: Theme.of(context).colorScheme.background,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onBackground,
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
        ),
      ],
    );
  }
}
