import 'dart:ui';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/screens/authGuard.dart';
import "constants.dart";
import 'package:song_hub/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(Songhub());

class Main extends State<Songhub> {
  final auth = AuthService();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: auth.user),
      ],

      // All data will be available in this child and descendents
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFFFFFFFF),
          accentColor: kAccentColor,
          hintColor: kPlaceholderColor,
          fontFamily: "Roboto",
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 16.0,
              color: kTextSecondary,
            ),
            headline3: TextStyle(
              fontSize: 22.0,
              color: kAccentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: AuthGuard(),
        routes: routes,
      ),
    );
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}
