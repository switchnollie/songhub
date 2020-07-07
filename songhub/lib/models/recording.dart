import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

/// A model for recordings
class Recording {
  final String id;
  final String label;
  final String creator;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String versionDescription;
  final String storagePath;

  Recording(
      {this.id,
      this.label,
      this.creator,
      this.updatedAt,
      this.createdAt,
      this.versionDescription,
      this.storagePath});

  /// Create recording by deserializing a Firestore DocumentSnapshot
  factory Recording.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    return Recording(
      id: documentId,
      label: data['label'],
      creator: data['creator'],
      createdAt: data['createdAt'],
      versionDescription: data['versionDescription'],
      storagePath: data['storagePath'],
    );
  }

  /// Serialize recording to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'creator': creator,
      'createdAt': createdAt,
      'updateAt': updatedAt,
      'versionDescription': versionDescription,
      'storagePath': storagePath,
    };
  }

  @override
  int get hashCode => hashValues(id, label, versionDescription, createdAt);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Recording otherRecording = other;
    return id == otherRecording.id &&
        label == otherRecording.label &&
        versionDescription == otherRecording.versionDescription &&
        createdAt == otherRecording.createdAt &&
        storagePath == otherRecording.storagePath &&
        updatedAt == otherRecording.updatedAt;
  }
}
