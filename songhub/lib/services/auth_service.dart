import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Dependencies
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  // constructor
  AuthService() {

  }

  void updateUserData(FirebaseUser user) async {


  }


  void signOut() {

  }
}