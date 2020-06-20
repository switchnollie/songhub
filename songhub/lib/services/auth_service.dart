import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:song_hub/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:song_hub/services/db_service.dart';
import 'package:song_hub/services/storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // create a new User document for the newly created user in the db
      await DatabaseService().updateUserData(
          'tbd', 'tbd', 'tbd', 'profileImgs/placeholderProfileImg.png');
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<User> loadUserProfileImageUrl(User user) async {
    user.profileImgUrl =
        await StorageService.loadImage('public/profileImgs/${user.id}.jpg');
    return user;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .switchMap((FirebaseUser user) => _db
            .collection("users")
            .document(user.uid)
            .snapshots()
            .map((DocumentSnapshot doc) => User.fromFirestore(doc, user)))
        .switchMap(
            (User user) => Stream.fromFuture(loadUserProfileImageUrl(user)));
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
