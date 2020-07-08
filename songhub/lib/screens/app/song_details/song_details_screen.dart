import 'package:provider/provider.dart';
import 'package:song_hub/components/avatar.dart';
import 'package:song_hub/components/cover.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/spinner.dart';
import 'package:song_hub/routing.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/screens/app/song_details/feature_tabs.dart';
// import 'package:song_hub/screens/app/song_details/edit_song_sheet.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class SongDetailsScreen extends StatelessWidget {
  static const routeId = "/songs/details";

  static Widget create(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final SongDetailsScreenRouteParams args =
        ModalRoute.of(context).settings.arguments;

    return Provider<SongDetailsViewModel>(
      create: (_) => SongDetailsViewModel(
          songId: args.songId,
          userId: args.userId,
          database: database,
          storageService: storageService,
          authService: authService),
      child: SongDetailsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return StreamBuilder<SongWithImages>(
      stream: vm.song,
      builder: (context, snapshot) => Scaffold(
        body: snapshot.hasData ? DetailsView(song: snapshot.data) : Spinner(),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
        CustomAppBar(
            title: 'Song Details', isHeader: false, isTransparent: false),
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
                  SongTitle(titleText: song.songDocument.title),
                  Artist(artist: song.songDocument.artist),
                  AvatarRow(imgs: song.participantImgUrls),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onPressed: () {
                      navigateAndDisplayReturnedMessage(
                        context,
                        "/songs/edit",
                        arguments: EditSongModalRouteParams(song: song),
                      );
                      // buildShowModalBottomSheet(context);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
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
