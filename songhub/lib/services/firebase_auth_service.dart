// From bizz84's starter architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
// https://github.com/bizz84/starter_architecture_flutter_firebase/blob/replace-platform-alert-dialog-show-alert-dialog/lib/services/firestore_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:song_hub/models/user.dart';
import 'package:song_hub/services/firestore_paths.dart';
import 'package:song_hub/services/firestore_service.dart';

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

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Firestore is only used for creating a user document on User Sign Up
  final FirestoreService _database = FirestoreService.instance;

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

  Stream<FireUser> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<FireUser> signInAnonymously() async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<FireUser> signInWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  /// Creates a new user in FirebaseAuth and creates a user document in
  /// Cloud Firestore
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FireUser> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
