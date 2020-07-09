// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/viewModels/user_profile.dart';

class EditProfileViewModel {
  EditProfileViewModel(
      {@required this.database,
      @required this.storageService,
      @required this.authService});
  final FirestoreDatabase database;
  final StorageService storageService;
  final FirebaseAuthService authService;

  /// Get recording creator image from Firebase Storage
  Future<UserProfile> _getUserDataWithImageUrl(User user) async {
    String profileImgUrl =
        await storageService.loadImage('public/profileImgs/${user.id}.jpg');
    return UserProfile(userDocument: user, profileImgUrl: profileImgUrl);
  }

  Stream<UserProfile> get userProfile {
    return database
        .userStream()
        .switchMap((user) => Stream.fromFuture(_getUserDataWithImageUrl(user)));
  }
}
