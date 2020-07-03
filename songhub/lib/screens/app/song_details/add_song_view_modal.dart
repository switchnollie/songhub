import 'package:flutter/material.dart';
import 'package:song_hub/services/firestore_database.dart';

/// Add song view modal
class AddSongViewModal {
  AddSongViewModal({@required this.database});

  final FirestoreDatabase database;

  /// Get stage name stream of user stream
  Stream<String> get stageName {
    return database.userStream().map((user) => user.stageName);
  }
}
