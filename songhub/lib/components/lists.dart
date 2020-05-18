import 'package:app/components/images.dart';
import 'package:app/components/user.dart';
import 'package:app/main.dart';
import 'package:app/screens/overview.dart';
import "package:flutter/material.dart";


class ListGenerator extends StatelessWidget {

  final BuildContext context;

  ListGenerator({this.context});

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          ScreenHeader(title: "Songs"),
          // TODO: Example list items! Should be fetched from database later!
          for (int i = 0; i < 15; i++)
            Column(
              children: <Widget>[
                Divider(),
                SongListEntry(context: context, title: "Lorem ipsum dolor set amet", artist: "Sarah Corner", img: "assets/example_cover.jpg", participants: [
                  "assets/example_participant_1.jpg",
                  "assets/example_participant_2.jpg",
                  "assets/example_participant_3.jpg"
                ]),
              ],
            ),
        ],
      );
}

class SongListEntry extends StatelessWidget {
  
  final BuildContext context;
  final String title;
  final String artist;
  final String img;
  final List<String> participants;

  SongListEntry({
    @required this.context,
    @required this.title,
    @required this.artist,
    @required this.img,
    @required this.participants,
  });

  @override
  Widget build(BuildContext context) =>
      ListTile(

          // Song entry widget
          leading: CoverSmall(img: img),
          title: ListTitle(title: title),
          subtitle: ListSubtitle(artist: artist),
          trailing: Participants(participants: participants),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          onTap: () {
            //TODO: Extract routes
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

class ListSubtitle extends StatelessWidget {
  
  final String artist;
  
  ListSubtitle({@required this.artist});

  @override
  Widget build(BuildContext context) {
    return Text(
      artist,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}

class ListTitle extends StatelessWidget {
  
  final String title;
  
  ListTitle({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }
}
