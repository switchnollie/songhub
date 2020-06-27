import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/components/discussion.dart';
import 'package:song_hub/components/recordings_grid.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

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
  final Song song;

  InformationContainer({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Cover(
                img: song.coverImg,
                size: CoverSize.LARGE,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SongTitle(titleText: song.title),
                      Artist(artist: song.artist),
                      AvatarRow(imgs: song.participants),
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
        ),
        BodyTabs(
          song: song,
        ),
      ],
    );
  }

  Future<void> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return EditSheet(song: song);
        });
  }
}

class EditSheet extends StatelessWidget {
  final Song song;

  EditSheet({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 168,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit"),
              onTap: () {
                navigateAndDisplayReturnedMessage(
                  context,
                  "/songs/edit",
                  arguments: EditSongModalRouteParams(song: song),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
  }
}

class BodyTabs extends StatelessWidget {
  final Song song;

  BodyTabs({@required this.song});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBar(tabs: [
                  Tab(text: "FILES"),
                  Tab(text: "DISCUSSION"),
                ]),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 259.0,
              child: TabBarView(
                children: [
                  RecordingsGrid(song: song),
                  Discussion(song: song),
                ],
              ),
            ),
          ]),
    );
  }
}

class SongDetailsScreen extends StatelessWidget {
  static const routeId = "/songs/details";

  @override
  Widget build(BuildContext context) {
    final _db = DatabaseService();
    final SongDetailsScreenRouteParams args =
        ModalRoute.of(context).settings.arguments;
    Song song = Provider.of<List<Song>>(context)
        .firstWhere((songEl) => songEl.id == args.songId);
    return MultiProvider(
      providers: [
        StreamProvider<List<Recording>>.value(value: _db.getRecordings(song)),
        StreamProvider<List<Message>>.value(value: _db.getMessages(song)),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: InformationContainer(song: song),
        ),
      ),
    );
  }
}
