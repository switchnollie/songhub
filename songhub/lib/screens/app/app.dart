//import 'package:song_hub/constants.dart';
import 'package:song_hub/screens/app/placeholder.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_screen.dart';
import 'package:song_hub/screens/app/user_settings/user_settings_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Navigation State
  int _selectedIndex = 0;

  Widget _getSelectedScreen(BuildContext context, int index) {
    final List<Widget> children = [
      SongsOverviewScreen.create(context),
      PlaceholderScreen("Notifications"),
      UserSettingsScreen(),
    ];
    return children[index];
  }

  // Bottom navigation onTap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(context, _selectedIndex), //_buildOverview(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.queue_music,
            ),
            title: Text(
              "Projects",
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
    );
  }
}
