import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firebase_auth_service.dart';
import 'package:song_hub/services/firestore_database.dart';
import 'package:song_hub/services/storage_service.dart';
import 'package:song_hub/viewModels/user_profile.dart';

class UserWithProfileImage {
  UserWithProfileImage({this.profileImgUrl, this.userDocument});

  final String profileImgUrl;
  final User userDocument;

  @override
  String toString() {
    return "UserDocument: ${userDocument.toString()}, profileImgUrl: $profileImgUrl";
  }
}

class EditProfileViewModel {
  EditProfileViewModel(
      {@required this.database,
      @required this.storageService,
      @required this.authService});
  final FirestoreDatabase database;
  final StorageService storageService;
  final FirebaseAuthService authService;

  /// Get recording creator image from Firebase Storage
  Future<UserWithProfileImage> _getUserDataWithImageUrl(User user) async {
    String profileImgUrl = await storageService
        .loadRecordingCreatorImage('public/profileImgs/${user.id}.jpg');
    return UserWithProfileImage(
        userDocument: user, profileImgUrl: profileImgUrl);
  }

  Stream<UserProfile> get userProfile {
    final userWithProfileImgStream = database
        .userStream()
        .switchMap((user) => Stream.fromFuture(_getUserDataWithImageUrl(user)));
    return Rx.combineLatest2(
        authService.onAuthStateChanged,
        userWithProfileImgStream,
        (FireUser fireUser, UserWithProfileImage user) => UserProfile(
            email: fireUser.email,
            uid: fireUser.uid,
            userDocument: user.userDocument,
            profileImgUrl: user.profileImgUrl));
  }
}
