// Copyright 2020 Tim Weise, Pascal Schlaak. Use of this source
// code is governed by an MIT-style license that can be found in
// the LICENSE file or at https://opensource.org/licenses/MIT.
// From bizz84's starter architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
// https://github.com/bizz84/starter_architecture_flutter_firebase/blob/replace-platform-alert-dialog-show-alert-dialog/lib/services/firestore_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firestore_paths.dart';
import 'package:song_hub/services/firestore_service.dart';

/// A reduced set of properties from [FirebaseUser] that are relevant
/// for the application.
@immutable
class FireUser {
  const FireUser({
    @required this.uid,
    this.email,
    this.displayName,
  });

  final String uid;
  final String email;
  final String displayName;

  @override
  String toString() {
    return "User $uid, email $email, displayName $displayName";
  }
}

/// A Singleton Service that exposes pure functions to interact with
/// Firebase Authentication API using the firebase_auth plugin
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Firestore is only used for creating a user document on User Sign Up
  final FirestoreService _database = FirestoreService.instance;

  /// Creates a [FireUser] with a reduced set of properties that are relevant
  /// for the application by extracting those fields from the [user] object.
  FireUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return FireUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  /// Creates a [FireUser] with a reduced set of properties that are relevant
  /// for the application which are [uid], [email] and [stageName] (which will get
  /// stored under the [displayName] property).
  FireUser _userFromSignInForm({String uid, String email, String stageName}) {
    if (uid == null || email == null || stageName == null) {
      return null;
    }
    return FireUser(
      uid: uid,
      email: email,
      displayName: stageName,
    );
  }

  /// The current [FireUser] as a stream that changes each time the user signIn or signOut.
  Stream<FireUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  /// Sends a sign in request to Firebase Authentication using the
  /// credentials [email] and [password].
  ///
  /// If successful, it signs the user in, updates the [onAuthStateChanged]
  /// stream and returns a [FireUser].
  Future<FireUser> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  /// Creates a new user with the required parameters [email], [password]
  /// and [stageName] in FirebaseAuth and creates
  /// a user document in Cloud Firestore
  Future<FireUser> createUserWithEmailAndPassword(
      String email, String password, String stageName) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final newUid = authResult.user?.uid;
    final userInfo = UserUpdateInfo();
    userInfo.displayName = stageName;
    await authResult.user.updateProfile(userInfo);
    await _database.setData(
        path: FirestorePath.user(newUid),
        data: User(id: newUid, email: email, stageName: stageName).toMap());
    return _userFromSignInForm(uid: newUid, email: email, stageName: stageName);
  }

  /// Returns the currently logged in user as a [FireUser]
  Future<FireUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  /// Signs out the current user and clears it from the disk cache.
  ///
  /// If successful, it signs the user out of the app and updates the [onAuthStateChanged] stream.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
