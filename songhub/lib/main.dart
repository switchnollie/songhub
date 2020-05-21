import 'package:song_hub/app.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import "constants.dart";

void main() => runApp(Songhub());

class Main extends State<Songhub> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFFFFF),
        accentColor: kAccentColor,
        fontFamily: "Roboto",
        textTheme: TextTheme(),
      ),
      home: App(),
      routes: routes,
    );
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}
