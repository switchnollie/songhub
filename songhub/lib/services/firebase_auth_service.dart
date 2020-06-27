// From bizz84's starter architecture for flutter and firebase (https://github.com/bizz84/starter_architecture_flutter_firebase)
// https://github.com/bizz84/starter_architecture_flutter_firebase/blob/replace-platform-alert-dialog-show-alert-dialog/lib/services/firestore_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class FireUser {
  const FireUser({
    @required this.uid,
    this.email,
  });

  final String uid;
  final String email;
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FireUser _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return FireUser(
      uid: user.uid,
      email: user.email,
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

  Future<FireUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final AuthResult authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
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
