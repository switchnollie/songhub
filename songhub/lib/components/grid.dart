import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:song_hub/models/song.dart';

import 'package:provider/provider.dart';
import 'package:song_hub/components/file_input.dart';
import 'package:song_hub/models/recording.dart';

class FilesGrid extends StatefulWidget {
  final Song song;

  FilesGrid({@required this.song});

  @override
  _FilesGridState createState() => _FilesGridState(song: song);
}

class _FilesGridState extends State<FilesGrid> {
  final Song song;

  _FilesGridState({this.song});

  @override
  Widget build(BuildContext context) {
    List<Recording> recordings = Provider.of<List<Recording>>(context);
    return GridView.builder(
        padding: EdgeInsets.all(16.0),
        // itemCount: content.length,
        itemCount: recordings != null ? recordings.length + 1 : 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return FileInputContainer(song: song);
          }
          return FileItemContainer(
            label: recordings[index - 1].label,
            versionDescription: recordings[index - 1].versionDescription,
            time: DateFormat("yyyy-MM-dd")
                .format(recordings[index - 1].timestamp.toDate()),
            image: recordings[index - 1].image,
          );
        });
  }
}

class FileItemContainer extends StatelessWidget {
  final String versionDescription, label, image, time;

  FileItemContainer(
      {@required this.versionDescription,
      @required this.label,
      this.image,
      @required this.time});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/recordings/edit",
          );
        },
        child: Container(
          color: Theme.of(context).accentColor.withAlpha(0x22),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  // TODO: Padding not responsive
                  padding: EdgeInsets.only(bottom: 28.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.timeline,
                            size: 16,
                            // TODO: Define color from custom theme?
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              time,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      image != ""
                          ? CircleAvatar(
                              child: ClipOval(
                                child: Image.network(image),
                              ),
                              radius: 14,
                            )
                          : Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                              size: 28,
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Text(
                  versionDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
