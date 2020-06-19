import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:song_hub/services/auth_service.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/file_input.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class FilesGrid extends StatefulWidget {
  final String songId;

  FilesGrid({@required this.songId});

  @override
  _FilesGridState createState() => _FilesGridState(songId: songId);
}

class _FilesGridState extends State<FilesGrid> {
  final String songId;

  _FilesGridState({this.songId});

  File recordingFile;
  String storagePath;
  final _storage = StorageService();
  final _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getFile() async {
    File file = await FilePicker.getFile();
    FirebaseUser user = await _auth.currentUser();

    if (file != null) {
      recordingFile = File(file.path);
      // TODO: Change UID?
      final recordingId = Uuid().v4();
      storagePath =
          await _storage.uploadFile("recordings", recordingFile, recordingId);
      final recording = Recording(
        id: recordingId,
        name: basename(recordingFile.path),
        //TODO: Image path of creator uid
        // image: user.uid,
        image: null,
        storagePath: storagePath,
        timestamp: Timestamp.fromDate(DateTime.now().toUtc()),
        // TODO: Version
        version: "Initiation",
      );
      await _db.upsertRecording(songId, recording);
    }
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
