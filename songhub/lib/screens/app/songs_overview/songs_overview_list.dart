import 'package:provider/provider.dart';
import 'package:song_hub/components/alert.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/routing.dart';
import "package:flutter/material.dart";
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class SongList extends StatelessWidget {
  SongList({this.songs});

  final List<SongWithImages> songs;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: songs != null ? songs.length + 1 : 0,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if (index == songs.length) {
          return Divider(height: 1);
        }
        return SongListEntry(
          song: songs[index],
        );
      },
    );
  }
}

class SongListEntry extends StatelessWidget {
  final SongWithImages song;

  SongListEntry({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(song.songDocument.id),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Color(0xFFF0597E),
        child: Padding(
          padding: const EdgeInsets.only(right: 31),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDeleteAlert(context);
      },
      child: Column(
        children: <Widget>[
          Divider(height: 1),
          ListTile(
            // Song entry widget
            leading: Cover(
              img: song.coverImgUrl,
              size: CoverSize.SMALL,
            ),
            title: ListTitle(title: song.songDocument.title),
            subtitle: ListSubtitle(artist: song.songDocument.artist),
            trailing: AvatarRow(imgs: song.participantImgUrls),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onTap: () {
              Navigator.pushNamed(
                context,
                "/songs/details",
                arguments: SongDetailsScreenRouteParams(song: song),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Show alert to confirm delete of song project
  Future<bool> showDeleteAlert(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertWidget(
          title: 'Delete project',
          text:
              'This action can\'t be undone and will also remove all files and messages!',
          option1: 'CANCEL',
          option2: 'DELETE',
          onTap: () => _handleSongDelete(context, song),
        );
      },
    );
  }

  /// Delete song document in Firestore
  /// TODO: Delete files and messages in Storage too
  void _handleSongDelete(BuildContext context, SongWithImages song) async {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    // final storageService = Provider.of<StorageService>(context, listen: false);

    try {
      database.deleteSong(song.songDocument);
    } catch (e) {
      print(e);
    }
  }
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
