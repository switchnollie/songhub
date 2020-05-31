import 'package:song_hub/app.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
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
            fontFamily: "Roboto",
            textTheme: TextTheme(),
          ),
          home: App(),
          routes: routes,
        ));
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}
