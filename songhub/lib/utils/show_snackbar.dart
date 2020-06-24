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
    content: Text(text),
    action: SnackBarAction(
        label: 'OK', onPressed: currentScaffold.hideCurrentSnackBar),
  );
  currentScaffold.showSnackBar(snackBarContent);
}

navigateAndDisplayReturnedMessage(BuildContext context, String routeName,
    {Object arguments}) async {
  final result =
      await Navigator.pushNamed(context, routeName, arguments: arguments);
  if (result != null) {
    showSnackBarByContext(context, result);
  }
}
