import 'package:app/components/buttons.dart';
import 'package:app/components/images.dart';
import 'package:app/components/user.dart';
import 'package:flutter/material.dart';


class SongTitle extends StatelessWidget {
  
  final String titleText;

  SongTitle({@required this.titleText,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}

class Artist extends StatelessWidget {
  
  final String artist;

  Artist({@required this.artist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        artist,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}

class InformationContainer extends StatelessWidget {
  
  final String imagePath;
  final String titleText;
  final String artist;
  final List<String> participants;
  final BuildContext context;

  InformationContainer({
    Key key,
    @required this.imagePath,
    @required this.titleText,
    @required this.artist,
    @required this.participants,
    @required this.context,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        // Song overview header
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CoverLarge(imagePath: imagePath),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SongTitle(titleText: titleText),
                        Artist(artist: artist),
                        Participants(participants: participants),
                        Settings(),
                      ],
                    )),
              ],
            ),
            BodyTabs(),
          ],
        ),
      );
}

class BodyTabs extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
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
}