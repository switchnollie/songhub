import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String label;
  final String creator;
  final String storagePath;
  final Timestamp creationTime;
  final String versionDescription;

  Recording(
      {this.id,
      this.label,
      this.creator,
      this.creationTime,
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
        creationTime: data['creationTime'],
        versionDescription: data['versionDescription']);
  }

  /// Create Records instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map['id'],
        label: map['data']['label'],
        creator: map['data']['creator'] ?? '',
        storagePath: map['data']['storagePath'] ?? '',
        creationTime: map['data']['creationTime'],
        versionDescription: map['data']['versionDescription']);
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'creator': creator,
      'storagePath': storagePath,
      'creationTime': creationTime,
      'versionDescription': versionDescription,
    };
  }
}
