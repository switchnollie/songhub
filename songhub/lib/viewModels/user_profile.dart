// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:song_hub/models/user.dart';

/// A user document with additional properties that are specific
/// to its UI representation.
///
/// Besides the user document that is a direct object representation of
/// a user document in Cloud Firestore this includes the [profileImgUrl].
@immutable
class UserProfile {
  final User userDocument;
  final String profileImgUrl;

  UserProfile({this.userDocument, this.profileImgUrl});
}
