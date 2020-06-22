import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:song_hub/models/song.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:song_hub/components/file_input.dart';
import 'package:song_hub/models/recording.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class FilesGrid extends StatefulWidget {
  final Song song;

  FilesGrid({@required this.song});

  @override
  _FilesGridState createState() => _FilesGridState();
}

class _FilesGridState extends State<FilesGrid> {
  File recordingFile;
  String storagePath;
  final _storage = StorageService();
  final _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getFile() async {
    final File file = await FilePicker.getFile();
    final FirebaseUser user = await _auth.currentUser();

    if (file != null) {
      recordingFile = File(file.path);
      final recordingId = Uuid().v4();
      storagePath = await _storage.uploadRecording(
          widget.song.id,
          recordingId,
          file,
          FileUserPermissions(
              owner: user.uid, participants: widget.song.participants));
      final recording = Recording(
        id: recordingId,
        label: basename(recordingFile.path),
        image: user.uid,
        storagePath: storagePath,
        timestamp: Timestamp.fromDate(DateTime.now().toUtc()),
        // TODO: Version
        // Commit message like
        versionDescription: "Initiation",
      );
      await _db.upsertRecording(widget.song.id, recording);
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
            return FileInput(onPressed: getFile);
          }
          return FileItemContainer(
            name: recordings[index - 1].label,
            version: recordings[index - 1].versionDescription,
            time: DateFormat("yyyy-MM-dd")
                .format(recordings[index - 1].timestamp.toDate()),
            image: recordings[index - 1].image,
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
