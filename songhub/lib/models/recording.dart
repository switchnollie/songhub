import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String label;
  final String creator;
  final String storagePath;
  final Timestamp createdAt;
  final String versionDescription;

  Recording(
      {this.id,
      this.label,
      this.creator,
      this.createdAt,
      this.storagePath,
      this.versionDescription});

  /// Create Records instance from Firestore DocumentSnapshot
  factory Recording.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Recording(
        id: doc.documentID,
        label: data['label'],
        creator: data['creator'] ?? '',
        storagePath: data['storagePath'] ?? '',
        createdAt: data['createdAt'],
        versionDescription: data['versionDescription']);
  }

  /// Create Records instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map['id'],
        label: map['data']['label'],
        creator: map['data']['creator'] ?? '',
        storagePath: map['data']['storagePath'] ?? '',
        createdAt: map['data']['createdAt'],
        versionDescription: map['data']['versionDescription']);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'creator': creator,
      'storagePath': storagePath,
      'createdAt': createdAt,
      'versionDescription': versionDescription,
    };
  }
}
