// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';


class PlaceholderScreen extends StatelessWidget {
  final String text;

  PlaceholderScreen(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(this.text),
      ),
    );
  }
}