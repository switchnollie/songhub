import 'package:flutter/material.dart';
// TODO: grid and discussion are not reusable and shouldn't be in coponents
// Define recordings_grid.dart and discussion.dart in this folder and
// access reusable Grid from there
import 'package:song_hub/components/discussion.dart';
import 'package:song_hub/components/grid.dart';
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TabBar(
                tabs: [Tab(text: 'FILES'), Tab(text: 'DISCUSSION')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  FilesGrid(song: song),
                  Discussion(song: song),
                ],
              ),
            )
          ],
        ),
      ),
    )
  }
}
