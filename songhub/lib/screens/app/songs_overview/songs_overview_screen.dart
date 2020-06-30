import 'package:provider/provider.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_list.dart';
import 'package:song_hub/components/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_view_model.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

class SongsOverviewScreen extends StatelessWidget {
  static const routeId = "/songs";

  static Widget create(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    return Provider<SongsOverviewViewModel>(
      create: (_) => SongsOverviewViewModel(
          database: database, storageService: storageService),
      child: SongsOverviewScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongsOverviewViewModel>(context);
    return StreamBuilder<List<SongWithImages>>(
      stream: vm.songs,
      builder: (context, snapshot) {
        return ScreenContainer(
          header: ScreenHeader(
            title: "Projects",
            actionButton: IconButton(
              icon: Icon(
                Icons.add,
                size: 32.0,
              ),
              color: Color(0xFFD2D4DC),
              onPressed: () {
                navigateAndDisplayReturnedMessage(
                  context,
                  "/songs/add",
                );
              },
            ),
          ),
          body: SongList(songs: snapshot.data),
        );
      },
    );
  }
}
