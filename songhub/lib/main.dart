// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Mainscreen widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFFFFFFF),
        accentColor: Color(0xFF4066F0),
        fontFamily: "Roboto",
        textTheme: TextTheme(),
      ),
      home: SongElements(),
    );
  }
}

class SongOverview extends State<SongElements> {
  // Bottom navigation
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(),
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
    );
  }

  Widget _buildList() => ListView(
        // Example list items! Should be fetched from database later!
        children: [
          _header(),
          for (int i = 0; i < 15; i++)
            Column(
              children: <Widget>[
                Divider(),
                _song("Lorem ipsum dolor set amet", "Sarah Corner",
                    "assets/example_cover.jpg", [
                  "assets/example_participant_1.jpg",
                  "assets/example_participant_2.jpg",
                  "assets/example_participant_3.jpg"
                ]),
              ],
            ),
        ],
      );

  Widget _header() => Container(
        // Song overview header
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Songs",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 38,
              ),
              color: Color(0xFFD2D4DC),
              onPressed: () {},
            )
          ],
        ),
      );

  ListTile _song(
          String title, String artist, String img, List<String> participants) =>
      ListTile(

          // Song entry widget
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(img),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            artist,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Wrap(
            spacing: -10,
            children: <Widget>[
              for (var i = 0; i < participants.length; i++)
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(participants[i]),
                    radius: 12.5,
                  ),
                ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SongDetails(
                    titleText: title,
                    artist: artist,
                    imagePath: img,
                    participants: participants),
              ),
            );
          });
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

  SongDetails({
    String title,
    @required this.titleText,
    String art,
    @required this.artist,
    String image,
    @required this.imagePath,
    List participant,
    @required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: BackButton(
          color: Color(0xFFD2D4DC),
        ),
      ),
      body: _songInformations(context),
    );
  }

  Widget _songInformations(BuildContext context) => Padding (
    
    padding: const EdgeInsets.symmetric(horizontal: 16),

        // Song overview header
        child: Column(
          children: <Widget>[

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.asset(
                  imagePath,
                  width: 125,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          titleText,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          artist,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Wrap(
                        spacing: -10,
                        children: <Widget>[
                          for (var i = 0; i < participants.length; i++)
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(participants[i]),
                                radius: 12.5,
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )),
            ],
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 50),
                  child: TabBar(tabs: [
                    Tab(text: "FILES"),
                    Tab(text: "DISCUSSION"),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
  );
}
