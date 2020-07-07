import 'dart:ui';

import 'package:flutter/foundation.dart';

enum UserRole { Artist, Producer }

/// A model for users
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String stageName;
  final String email;
  // final UserRole role;
  final String role;

  User({
    @required this.id,
    @required this.email,
    @required this.stageName,
    this.firstName,
    this.lastName,
    this.role,
  });

  /// Create user by deserializing a Firestore DocumentSnapshot
  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return User(
      id: documentId,
      firstName: data['firstName'],
      lastName: data['lastName'],
      stageName: data['stageName'],
      role: data['role'],
      email: data['email'],
    );
  }

  /// Serialize user to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'stageName': stageName,
      'role': role,
      'email': email,
    };
  }

  @override
  int get hashCode =>
      hashValues(id, firstName, lastName, stageName, role, email);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final User otherUser = other;
    return id == otherUser.id &&
        firstName == otherUser.firstName &&
        lastName == otherUser.lastName &&
        stageName == otherUser.stageName &&
        role == otherUser.role &&
        email == otherUser.email;
  }

  String toString() {
    return "$firstName $lastName ($stageName), role: $role, id: $id, email: $email";
  }
}
