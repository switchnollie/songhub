// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/components/grid_box.dart';
import 'package:song_hub/components/recording.dart';
import 'package:song_hub/routing.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
import 'package:song_hub/utils/show_snackbar.dart';
import 'package:song_hub/viewModels/recording_with_images.dart';
import 'package:song_hub/viewModels/song_with_images.dart';

class RecordingsGridTabView extends StatefulWidget {
  final SongWithImages song;

  RecordingsGridTabView({@required this.song});

  @override
  _RecordingsGridState createState() => _RecordingsGridState();
}

class _RecordingsGridState extends State<RecordingsGridTabView> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SongDetailsViewModel>(context);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: StreamBuilder<List<RecordingWithImages>>(
        stream: vm.recordings,
        builder: (context, snapshot) => GridView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return InputBox(
                  heroTag: index.toString(),
                  onPressed: () {
                    navigateAndDisplayReturnedMessage(
                      context,
                      "/recordings/add",
                      arguments: RecordingModalRouteParams(
                        song: widget.song,
                        recording: null,
                        index: index.toString(),
                      ),
                    );
                  });
            }
            return Box(
              creator: snapshot.data[index - 1].recordingDocument.creator,
              createdAt: snapshot.data[index - 1].recordingDocument.createdAt,
              label: snapshot.data[index - 1].recordingDocument.label,
              storagePath:
                  snapshot.data[index - 1].recordingDocument.storagePath,
              creatorImgUrl: snapshot.data[index - 1].creatorImgUrl,
              updatedAt: snapshot.data[index - 1].recordingDocument.updatedAt,
              versionDescription:
                  snapshot.data[index - 1].recordingDocument.versionDescription,
              heroTag: index.toString(),
              onTap: () {
                navigateAndDisplayReturnedMessage(
                  context,
                  "/recordings/edit",
                  arguments: RecordingModalRouteParams(
                    song: widget.song,
                    recording: snapshot.data[index - 1].recordingDocument,
                    index: index.toString(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
