// Copyright 2020 Pascal Schlaak, Tim Weise. Use of this source 
// code is governed by an MIT-style license that can be found in 
// the LICENSE file or at https://opensource.org/licenses/MIT.
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:song_hub/models/label.dart';

/// A model for recordings
class Recording {
  final String id;
  final Label label;
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
      label: data['label'] != null ? mappedLabels[data['label']] : null,
      creator: data['creator'],
      createdAt: data['createdAt'],
      versionDescription: data['versionDescription'],
      storagePath: data['storagePath'],
    );
  }

  /// Serialize recording to update or add in Firestore
  Map<String, dynamic> toMap() {
    return {
      'label': label.value,
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
