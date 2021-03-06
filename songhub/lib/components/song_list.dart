import 'package:song_hub/components/cover.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import "package:song_hub/models/song.dart";

class SongList extends StatelessWidget {
  SongList({this.songs});

  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: songs != null ? songs.length : 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Divider(),
            SongListEntry(
              song: songs[index],
            ),
          ],
        );
      },
    );
  }
}

class SongListEntry extends StatelessWidget {
  final Song song;

  SongListEntry({@required this.song});

  @override
  Widget build(BuildContext context) => ListTile(
      // Song entry widget
      leading: Cover(
        img: song.coverImg,
        size: CoverSize.SMALL,
      ),
      title: ListTitle(title: song.title),
      subtitle: ListSubtitle(artist: song.artist),
      trailing: AvatarRow(imgs: song.participants),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/songs/details",
          arguments: SongDetailsScreenRouteParams(song: song),
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
