import 'package:cloud_firestore/cloud_firestore.dart';

class Recording {
  final String id;
  final String name;
  final String participantImg;
  final Timestamp timestamp;
  final String version;

  Recording(
      {this.id, this.name, this.participantImg, this.timestamp, this.version});

  /// Create Records instance from Firestore DocumentSnapshot
  factory Recording.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Recording(
        id: doc.documentID,
        name: data["name"],
        participantImg: data["participantImg"] ?? "",
        timestamp: data["timestamp"],
        version: data["version"]);
  }

  /// Create Records instance from map
  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
        id: map["id"],
        name: map["name"],
        participantImg: map["participantImg"] ?? "",
        timestamp: map["timestamp"],
        version: map["version"]);
  }
}
