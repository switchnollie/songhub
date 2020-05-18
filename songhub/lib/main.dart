import 'package:app/components/buttons.dart';
import 'package:app/components/images.dart';
import 'package:app/screens/details.dart';
import 'package:app/screens/placeholder.dart';
import "package:flutter/material.dart";
import "constants.dart";
import "components/user.dart";
import "components/lists.dart";
import "screens/overview.dart";

void main() => runApp(Songhub());

class Main extends State<Songhub> {
  // Mainscreen widget

  // Bottom navigation
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _children = [
    SongElements(),
    PlaceholderScreen("Notifications"),
    PlaceholderScreen("Account")
  ];

  // Bottom navigation onTap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFFFFF),
        accentColor: kAccentColor,
        fontFamily: "Roboto",
        textTheme: TextTheme(),
      ),
      home: Scaffold(
        body: _children[_selectedIndex], //_buildOverview(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFF2F5FA),
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Color(0xFFD2D4DC),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.queue_music,
              ),
              title: Text(
                "Songs",
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
              ),
              title: Text(
                "Notifications",
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text(
                "Account",
              ),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class Songhub extends StatefulWidget {
  @override
  Main createState() => Main();
}

class SongOverview extends State<SongElements> {
  @override
  Widget build(BuildContext context) {
    return ListGenerator(context: context);
  }
}

class SongElements extends StatefulWidget {
  @override
  SongOverview createState() => SongOverview();
}

class SongDetails extends StatelessWidget {
  final String titleText;
  final String artist;
  final String imagePath;
  final List<String> participants;

  SongDetails({this.titleText, this.artist, this.imagePath, this.participants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: BackButton(
          color: Color(0xFFD2D4DC),
        ),
      ),
      body: InformationContainer(imagePath: imagePath, titleText: titleText, artist: artist, participants: participants, context: context),
    );
  }
}