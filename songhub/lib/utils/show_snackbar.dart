// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

void showSnackBarByScaffoldId(GlobalKey<ScaffoldState> scaffoldKey, String text,
    {bool isError = false}) {
  final snackBarContent = SnackBar(
    content:
        Text(text, style: isError ? TextStyle(color: Colors.redAccent) : null),
    action: SnackBarAction(
        label: 'OK', onPressed: scaffoldKey.currentState.hideCurrentSnackBar),
  );
  scaffoldKey.currentState.showSnackBar(snackBarContent);
}

void showSnackBarByContext(BuildContext context, String text,
    {bool isError = false}) {
  final currentScaffold = Scaffold.of(context);
  final snackBarContent = SnackBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    content:
        Text(text, style: isError ? TextStyle(color: Colors.redAccent) : null),
    action: SnackBarAction(
      label: 'OK',
      onPressed: currentScaffold.hideCurrentSnackBar,
      textColor: Theme.of(context).colorScheme.onSecondary,
    ),
  );
  currentScaffold.showSnackBar(snackBarContent);
}

void navigateAndDisplayReturnedMessage(BuildContext context, String routeName,
    {Object arguments}) async {
  final result =
      await Navigator.pushNamed(context, routeName, arguments: arguments);
  if (result != null) {
    showSnackBarByContext(context, result);
  }
}
