import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/app.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/screens/authentication/login.dart';

class AuthGuard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return LoginScreen();
    } else {
      return App();
    }
  }
}
