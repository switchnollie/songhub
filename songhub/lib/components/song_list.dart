import 'package:app/components/cover.dart';
import 'package:app/components/avatar.dart';
import 'package:app/main.dart';
import "package:flutter/material.dart";
import "package:app/models/song.dart";

class SongList extends StatelessWidget {
  SongList({this.songs});

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Divider(),
            SongListEntry(
              context: context,
              title: songs[index].title,
              artist: songs[index].artist,
              img: songs[index].img,
              participants: songs[index].participants,
            ),
          ],
        );
      },
    );
  }
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
  Widget build(BuildContext context) => ListTile(
      // Song entry widget
      leading: Cover(
        img: img,
        size: CoverSize.SMALL,
      ),
      title: ListTitle(title: title),
      subtitle: ListSubtitle(artist: artist),
      trailing: AvatarRow(imgs: participants),
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
