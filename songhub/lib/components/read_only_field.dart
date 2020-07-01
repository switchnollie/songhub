import 'package:flutter/material.dart';

/// Read only container
class ReadOnlyField extends StatelessWidget {
  final String text;
  final IconData icon;
  final String prefix;

  ReadOnlyField({
    this.text,
    this.icon,
    @required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).hintColor,
            width: 2,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).hintColor),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text('${prefix ?? ''}: ${text ?? ''}'),
            ),
          ],
        ),
      ),
    );
  }
}
