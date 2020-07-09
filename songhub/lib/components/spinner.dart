// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A component inheriting a loading spinner
class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: SpinKitPulse(
          color: Theme.of(context).accentColor,
          size: 50.0,
        ),
      ),
    );
  }
}
