// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:provider/provider.dart';
import 'package:song_hub/components/custom_app_bar.dart';
import 'package:song_hub/components/screen_container.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_list.dart';
import 'package:flutter/material.dart';
import 'package:song_hub/viewModels/song_with_images.dart';
import 'package:song_hub/screens/app/songs_overview/songs_overview_view_model.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/utils/show_snackbar.dart';

/// A view to build this apps songs overview.
///
/// On create this view initializes [Provider]s to feed its childs with cloud
/// data. Stream builder functionality will update [SongList] if data changes
/// occur.
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
          header: CustomAppBar(
            title: 'Projects',
            action: IconButton(
              icon: Icon(
                Icons.add,
              ),
              color: Theme.of(context).colorScheme.onBackground,
              onPressed: () {
                navigateAndDisplayReturnedMessage(
                  context,
                  "/songs/add",
                );
              },
            ),
            isHeader: true,
            isTransparent: false,
          ),
          body: SongList(songs: snapshot.data),
        );
      },
    );
  }
}
