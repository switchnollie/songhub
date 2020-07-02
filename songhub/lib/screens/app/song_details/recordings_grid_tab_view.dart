import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/components/recording.dart';
import 'package:song_hub/screens/app/song_details/song_details_view_model.dart';
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
          // itemCount: content.length,
          itemCount: snapshot.data != null ? snapshot.data.length + 1 : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return RecordingInputItem(
                  song: widget.song, index: index.toString());
            }
            return RecordingItem(
              song: widget.song,
              recording: snapshot.data[index - 1],
              index: index.toString(),
            );
          },
        ),
      ),
    );
  }
}
