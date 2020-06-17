import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { Artist, Producer }

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImg;
  // final UserRole role;
  final String role;

  User({this.id, this.firstName, this.lastName, this.profileImg, this.role});
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
        id: doc.documentID,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        profileImg: data['profileImg'] ?? "",
        role: data['role'] ?? '');
  }
  String toString() {
    return "$firstName $lastName, profileImgPath:$profileImg, role: $role, id: $id";
  }
}
