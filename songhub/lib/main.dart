import 'dart:ui';

import 'package:song_hub/app.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/screens/login.dart';
import "constants.dart";
import 'package:provider/provider.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/models/song.dart';

void main() => runApp(Songhub());

class Main extends State<Songhub> {
  final db = DatabaseService();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<Song>>.value(value: db.streamSongs()),
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
          home: LoginScreen(),
          initialRoute: LoginScreen.routeId,
          routes: routes,
        ));
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}
