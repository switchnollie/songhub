// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

/// A component to display read only text
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
          height: 59,
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
