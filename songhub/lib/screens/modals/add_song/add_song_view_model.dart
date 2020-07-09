// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:song_hub/services/firestore_database.dart';

class AddSongViewModel {
  AddSongViewModel({@required this.database});

  final FirestoreDatabase database;

  /// Get stage name stream of user stream
  Stream<String> get stageName {
    return database.userStream().map((user) => user.stageName);
  }
}
