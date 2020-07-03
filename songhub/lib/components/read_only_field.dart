import 'package:flutter/material.dart';

/// Read only container
class ReadOnlyField extends StatelessWidget {
  final String text;
  final String label;
  final IconData icon;

  ReadOnlyField({
    this.text,
    this.icon,
    @required this.label,
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
        Container(
          // TODO: Delete fixed Form height
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
                color: Theme.of(context).colorScheme.onBackground, width: 2.0),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: Theme.of(context).colorScheme.onBackground),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  '${text ?? ''}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
