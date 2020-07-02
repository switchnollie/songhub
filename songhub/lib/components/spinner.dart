import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
