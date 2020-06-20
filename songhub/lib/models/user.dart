import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { Artist, Producer }

class AuthInfo {
  final String email;
  AuthInfo({this.email});
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String stageName;
  String profileImgUrl;
  // final UserRole role;
  final String role;

  final AuthInfo auth;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.profileImgUrl,
      this.role,
      this.stageName,
      this.auth});

  factory User.fromFirestore(DocumentSnapshot doc, FirebaseUser user) {
    Map data = doc.data;

    return User(
        id: doc.documentID,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        role: data['role'] ?? '',
        stageName: data['stageName'] ?? '',
        auth: AuthInfo(email: user.email),
        profileImgUrl: null);
  }

  String toString() {
    return "$firstName $lastName ($stageName), profileImgUrl:$profileImgUrl, role: $role, id: $id";
  }
}
