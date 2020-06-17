import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/file_input.dart';
import 'package:song_hub/models/recording.dart';

class FilesGrid extends StatefulWidget {
  final String id;

  FilesGrid({@required this.id});

  @override
  _FilesGridState createState() => _FilesGridState();
}

class _FilesGridState extends State<FilesGrid> {
  File recordFile;
  String recordUrl;

  void getFile() async {
    File file = await FilePicker.getFile();

    setState(() {
      if (file != null) {
        recordFile = File(file.path);
        print("New file: $recordFile");
        // TODO: Push and render file
        // - X: Push storage
        // - X: Return path in storage
        // - Add record path in database
        // - Update file grid
      }
    });

    // if (recordFile != null) {
    //   recordUrl = await _storage.uploadFile("records", recordFile);
    // }
  }

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
            return FileInput(callback: getFile);
          }
          return FileItemContainer(
            name: recordings[index - 1].name,
            version: recordings[index - 1].version,
            time: DateFormat("yyyy-MM-dd")
                .format(recordings[index - 1].timestamp.toDate()),
          );
        });
  }
}

class FileItemContainer extends StatelessWidget {
  final String version, name, image, time;

  FileItemContainer(
      {@required this.version,
      @required this.name,
      this.image,
      @required this.time});

  // TODO: Fetch image url from path of image variable

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: InkWell(
        // TODO: onTap function
        // Fetch and open file
        onTap: () => print("File tapped"),
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
                      image != null
                          ? Image.network(image)
                          : Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                            )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    version,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                Text(
                  name,
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
