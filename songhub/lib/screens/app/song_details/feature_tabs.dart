// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:song_hub/screens/app/song_details/discussion_tab_view.dart';
import 'package:song_hub/screens/app/song_details/recordings_grid_tab_view.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class FeatureTabs extends StatelessWidget {
  final SongWithImages song;

  FeatureTabs({@required this.song});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TabBar(
                tabs: [Tab(text: 'FILES'), Tab(text: 'DISCUSSION')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RecordingsGridTabView(song: song),
                  DiscussionTabView(song: song),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
