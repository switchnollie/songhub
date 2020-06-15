import 'package:flutter/material.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:song_hub/components/file_input.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class FilesGrid extends StatefulWidget {
  final String id;

  FilesGrid({@required this.id});

  @override
  _FilesGridState createState() => _FilesGridState();
}

class _FilesGridState extends State<FilesGrid> {
  final _db = DatabaseService();
  final _storage = StorageService();
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
    return FutureBuilder(
        future: _db.getRecordsBySongId(widget.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return new Container();
          }
          return GridView.builder(
              padding: EdgeInsets.all(16.0),
              // itemCount: content.length,
              itemCount: snapshot.data.documents.length + 1,
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
                  name: snapshot.data.documents[index - 1]["name"],
                  version: snapshot.data.documents[index - 1]["version"],
                  time: snapshot.data.documents[index - 1]["timestamp"],
                );
              });
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
