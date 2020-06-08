import 'dart:ui';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/screens/authGuard.dart';
import "constants.dart";
import 'package:song_hub/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(Songhub());

class Main extends State<Songhub> {
  final _auth = AuthService();
  final _db = DatabaseService();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User>.value(value: _auth.user),
          StreamProvider<List<Song>>.value(value: _db.songs),
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
        ));
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}
