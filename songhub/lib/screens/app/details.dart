import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/services/db_service.dart';

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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),

        // Song overview header
        child: Column(
          children: <Widget>[
            Row(
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
            BodyTabs(
              id: song.id,
            ),
          ],
        ),
      );

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
                Navigator.pushNamed(
                  context,
                  "/songs/new",
                  arguments: SongModalRouteParams(song: song),
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
  final String id;

  BodyTabs({@required this.id});

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
          SizedBox(
            height: MediaQuery.of(context).size.height - 259.0,
            child: TabBarView(
              children: [
                FilesGrid(id: id),
                Icon(Icons.chat),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilesGrid extends StatelessWidget {
  final String id;

  FilesGrid({@required this.id});

  final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _db.getRecords(id),
        builder: (BuildContext context, AsyncSnapshot snapchot) {
          if (!snapchot.hasData) {
            return new Container();
          }
          // Map content = snapchot.data;
          return GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              // itemCount: content.length,
              itemCount: snapchot.data.documents.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return AddItemContainer();
                }
                return FileItemContainer(
                  name: snapchot.data.documents[index - 1]["name"],
                  version: snapchot.data.documents[index - 1]["version"],
                );
              });
        });
  }
}

class AddItemContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Theme.of(context).accentColor.withAlpha(0x22),
        child: Center(
            child: IconButton(
          icon: Icon(Icons.add),
          // TODO: onTap function
          onPressed: () => print("Add file"),
        )),
      ),
    );
  }
}

class FileItemContainer extends StatelessWidget {
  final String version, name;

  FileItemContainer({this.version, this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        // TODO: onTap function
        onTap: () => print("File tapped"),
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    version,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SongDetailsScreen extends StatelessWidget {
  static const routeId = "/songs/details";

  @override
  Widget build(BuildContext context) {
    final SongDetailsScreenRouteParams args =
        ModalRoute.of(context).settings.arguments;
    Song song = Provider.of<List<Song>>(context)
        .firstWhere((songEl) => songEl.id == args.songId);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: InformationContainer(song: song));
  }
}
