import 'package:app/constants.dart';
import 'package:app/screens/overview.dart';
import 'package:app/screens/placeholder.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    SongOverview(),
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
