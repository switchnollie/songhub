import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/models/message.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/models/song.dart';
import 'package:song_hub/routing.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/app/song_details/body_tabs.dart';
import 'package:song_hub/screens/app/song_details/edit_sheet.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class SongDetailsScreen extends StatelessWidget {
  static const routeId = "/songs/details";

  @override
  Widget build(BuildContext context) {
    final _db = DatabaseService();
    final SongDetailsScreenRouteParams args =
        ModalRoute.of(context).settings.arguments;
    SongWithImages song = Provider.of<List<Song>>(context)
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
          child: DetailsView(song: song),
        ),
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  final SongWithImages song;

  DetailsView({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DetailsViewHeader(song: song),
        FeatureTabs(
          song: song,
        ),
      ],
    );
  }
}

class DetailsViewHeader extends StatelessWidget {
  final SongWithImages song;

  DetailsViewHeader({@required this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Cover(
            img: song.coverImgUrl,
            size: CoverSize.LARGE,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SongTitle(titleText: song.song.title),
                  Artist(artist: song.song.artist),
                  AvatarRow(imgs: song.song.participants),
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
