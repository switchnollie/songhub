import 'package:flutter/material.dart';

void showSnackBarByScaffoldId(
    GlobalKey<ScaffoldState> scaffoldKey, String text) {
  final snackBarContent = SnackBar(
    content: Text(text),
    action: SnackBarAction(
        label: 'OK', onPressed: scaffoldKey.currentState.hideCurrentSnackBar),
  );
  scaffoldKey.currentState.showSnackBar(snackBarContent);
}

void showSnackBarByContext(BuildContext context, String text) {
  final currentScaffold = Scaffold.of(context);
  final snackBarContent = SnackBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    content: Text(text),
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
