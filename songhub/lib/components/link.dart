// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

/// A widget that warps a [GestureDetector]
///
/// [to] defines where to navigate. [child] can define a widget to be build
/// inside.
class Link extends StatelessWidget {
  final String to;
  final Widget child;
  Link({this.to, this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, to);
      },
      child: child,
    );
  }
}
