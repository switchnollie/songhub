import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String label;
  final String creator;
  final String storagePath;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String versionDescription;

  Recording(
      {this.id,
      this.label,
      this.creator,
      this.createdAt,
      this.updatedAt,
      this.storagePath,
      this.versionDescription});

  /// Create Recording instance from Firestore DocumentSnapshot
  factory Recording.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Recording(
        id: doc.documentID,
        label: data['label'],
        creator: data['creator'] ?? '',
        storagePath: data['storagePath'] ?? '',
        createdAt: data['createdAt'],
        updatedAt: data['updatedAt'],
        versionDescription: data['versionDescription']);
  }

  /// Create Recording instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map['id'],
        label: map['data']['label'],
        creator: map['data']['creator'] ?? '',
        storagePath: map['data']['storagePath'] ?? '',
        createdAt: map['data']['createdAt'],
        updatedAt: map['data']['updatedAt'],
        versionDescription: map['data']['versionDescription']);
  }

  // Create map from Recording
  Map<String, dynamic> toMap(bool isUpdate) {
    return isUpdate
        ? {
            'label': label,
            'storagePath': storagePath,
            'updatedAt': updatedAt,
            'versionDescription': versionDescription,
          }
        : {
            'label': label,
            'creator': creator,
            'storagePath': storagePath,
            'createdAt': createdAt,
            'versionDescription': versionDescription,
          };
  }
}
