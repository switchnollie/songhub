import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/routing.dart';
import 'package:flutter/material.dart';

class SongTitle extends StatelessWidget {
  final String titleText;

  SongTitle({
    @required this.titleText,
  });

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
                Cover(
                  img: imagePath,
                  size: CoverSize.LARGE,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SongTitle(titleText: titleText),
                        Artist(artist: artist),
                        AvatarRow(imgs: participants),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                          ),
                          onPressed: () {
                            buildShowModalBottomSheet(context);
                          },
                        ),
                      ],
                    )),
              ],
            ),
            BodyTabs(),
          ],
        ),
      );

  Future<void> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return EditSheet();
        });
  }
}

class EditSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 175,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text("Cancel"),
              onTap: () {},
            ),
          ],
        ));
  }
}

class BodyTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(tabs: [
              Tab(text: "FILES"),
              Tab(text: "DISCUSSION"),
            ]),
          ),          
          Container(
            //TODO: Set realtive Size (needed due to error of overflowed bottom)
            height: 400,
            child: TabBarView(
                children: [
                  Icon(Icons.file_upload),
                  Icon(Icons.chat),
                ],
              ),
          ),
        ],
      ),
    );
  }
}

class SongDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SongDetailsRouteParams args =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // leading: BackButton(
        //   color: Color(0xFFD2D4DC),
        // ),
      ),
      body: InformationContainer(
          imagePath: args.song.coverImg,
          titleText: args.song.title,
          artist: args.song.artist,
          participants: args.song.participants,
          context: context),
    );
  }
}
