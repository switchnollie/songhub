// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:song_hub/services/firestore_database.dart';

/// View model that exposes the app state that is needed by the [AddSongModal]
/// widget.
class AddSongViewModel {
  AddSongViewModel({@required this.database});

  final FirestoreDatabase database;

  /// The stage name of the signed in user exposed as a realtime data stream.
  Stream<String> get stageName {
    return database.userStream().map((user) => user.stageName);
  }
}
